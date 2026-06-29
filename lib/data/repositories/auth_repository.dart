import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../local/app_database.dart';
import '../local/database_provider.dart';
import '../remote/supabase_client.dart';

/// Thrown for any sign-in/sign-up failure, including the special
/// [confirmEmailRequired] case so the UI can show the right message.
class AppAuthException implements Exception {
  AppAuthException(this.message, {this.confirmEmailRequired = false});

  final String message;
  final bool confirmEmailRequired;

  @override
  String toString() => message;
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.role,
    required this.fullName,
    this.email,
    this.phone,
    this.hospitalId,
    this.avatarUrl,
  });

  final String id;
  final String role; // 'parent' | 'nurse'
  final String fullName;
  final String? email;
  final String? phone;
  final String? hospitalId;
  final String? avatarUrl;

  bool get isNurse => role == 'nurse';

  /// True for accounts created via an OAuth provider (e.g. Google) whose
  /// profile was auto-created by the `handle_new_user` trigger with no
  /// `full_name` metadata — they still need to pick a role and confirm
  /// their name before reaching a dashboard.
  bool get needsProfileCompletion => fullName.trim().isEmpty;

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        id: map['id'] as String,
        role: map['role'] as String,
        fullName: map['full_name'] as String,
        email: map['email'] as String?,
        phone: map['phone'] as String?,
        hospitalId: map['hospital_id'] as String?,
        avatarUrl: map['avatar_url'] as String?,
      );

  factory UserProfile.fromRow(UserRow row) => UserProfile(
        id: row.id,
        role: row.role,
        fullName: row.fullName,
        email: row.email,
        phone: row.phone,
        hospitalId: row.hospitalId,
        avatarUrl: row.avatarUrl,
      );
}

/// Wraps Supabase Auth for sign-up/sign-in/sign-out, and keeps a synced copy
/// of the caller's own profile row in the local drift `users` table so the
/// app can resolve "who am I, and what role" without a network round trip.
class AuthRepository {
  AuthRepository({SupabaseClient? client, AppDatabase? db})
      : _client = client ?? AppSupabase.client,
        _db = db ?? appDatabase;

  final SupabaseClient _client;
  final AppDatabase _db;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  User? get currentUser => _client.auth.currentUser;

  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? phone,
    String? hospitalId,
  }) async {
    AuthResponse res;
    try {
      res = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': role,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          if (hospitalId != null && hospitalId.isNotEmpty) 'hospital_id': hospitalId,
        },
      );
    } on AuthException catch (e) {
      throw AppAuthException(e.message);
    }

    final user = res.user;
    if (user == null) {
      throw AppAuthException('Sign up failed — no account was created.');
    }
    if (res.session == null) {
      // Email confirmation is required. The public.users row is already
      // created by the on_auth_user_created trigger, but there is no
      // session to fetch/cache it with yet.
      throw AppAuthException(
        'Check your email to confirm your account, then log in.',
        confirmEmailRequired: true,
      );
    }
    return _fetchAndCacheProfile(user.id);
  }

  Future<UserProfile> signIn({required String email, required String password}) async {
    AuthResponse res;
    try {
      res = await _client.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw AppAuthException(e.message);
    }
    final user = res.user;
    if (user == null) {
      throw AppAuthException('Sign in failed.');
    }
    return _fetchAndCacheProfile(user.id);
  }

  /// Starts the Google OAuth flow. On web this navigates the current tab to
  /// Google's consent screen; on success the browser is redirected back and
  /// the session is picked up automatically on the next app load, so callers
  /// should not expect this future to resolve into a usable session.
  Future<bool> signInWithGoogle() async {
    try {
      return await _client.auth.signInWithOAuth(OAuthProvider.google);
    } on AuthException catch (e) {
      throw AppAuthException(e.message);
    }
  }

  Future<void> signOut() => _client.auth.signOut();

  /// Sends a password-reset email via Supabase Auth. This always resolves
  /// successfully even for an unknown email (Supabase doesn't leak account
  /// existence) — callers should show a generic confirmation regardless.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email.trim());
    } on AuthException catch (e) {
      throw AppAuthException(e.message);
    }
  }

  /// Uploads a new avatar for the current user to the public `avatars`
  /// bucket and updates their profile. Online-first with no offline
  /// fallback — a photo can't be usefully queued while offline, so a
  /// network failure here surfaces as a real error to the caller.
  Future<UserProfile> updateAvatar(Uint8List bytes, {required String contentType}) async {
    final uid = currentUser?.id;
    if (uid == null) {
      throw AppAuthException('No active session — please sign in again.');
    }
    final path = '$uid/user.jpg';
    await _client.storage.from('avatars').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: contentType, upsert: true),
        );
    final url = _client.storage.from('avatars').getPublicUrl(path);
    await _client.from('users').update({'avatar_url': url}).eq('id', uid);
    return _fetchAndCacheProfile(uid);
  }

  /// Profile for the current session read from the local cache only — used
  /// at splash so routing doesn't block on a network call.
  Future<UserProfile?> cachedProfile() async {
    final uid = currentUser?.id;
    if (uid == null) return null;
    final row = await (_db.select(_db.users)..where((t) => t.id.equals(uid))).getSingleOrNull();
    return row == null ? null : UserProfile.fromRow(row);
  }

  /// Cached profile if available, otherwise fetched from Supabase. Returns
  /// null (rather than throwing) when there is no session or no network —
  /// callers should fall back to the login screen in that case.
  Future<UserProfile?> resolveCurrentProfile() async {
    final cached = await cachedProfile();
    if (cached != null) return cached;
    final uid = currentUser?.id;
    if (uid == null) return null;
    try {
      return await _fetchAndCacheProfile(uid);
    } catch (_) {
      return null;
    }
  }

  /// Fills in role/full name/hospital id for an account that was created
  /// without them (Google OAuth sign-up), then caches the result locally.
  Future<UserProfile> completeProfile({
    required String fullName,
    required String role,
    String? hospitalId,
  }) async {
    final uid = currentUser?.id;
    if (uid == null) {
      throw AppAuthException('No active session — please sign in again.');
    }
    await _client.from('users').update({
      'full_name': fullName,
      'role': role,
      if (hospitalId != null && hospitalId.isNotEmpty) 'hospital_id': hospitalId,
    }).eq('id', uid);
    return _fetchAndCacheProfile(uid);
  }

  Future<UserProfile> _fetchAndCacheProfile(String userId) async {
    final map = await _client.from('users').select().eq('id', userId).single();
    final profile = UserProfile.fromMap(map);
    await _db.into(_db.users).insertOnConflictUpdate(
          UsersCompanion.insert(
            id: profile.id,
            role: profile.role,
            fullName: profile.fullName,
            email: Value(profile.email),
            phone: Value(profile.phone),
            hospitalId: Value(profile.hospitalId),
            avatarUrl: Value(profile.avatarUrl),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
    return profile;
  }
}
