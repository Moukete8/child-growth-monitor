import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Initializes the Supabase client from values loaded by `flutter_dotenv`.
/// Call [init] once, before `runApp`, after `dotenv.load()` has completed.
class AppSupabase {
  static Future<void> init() async {
    final url = dotenv.env['SUPABASE_URL'];
    final publishableKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'];
    if (url == null || publishableKey == null) {
      throw StateError(
        'Missing SUPABASE_URL / SUPABASE_PUBLISHABLE_KEY — check .env (see .env.example).',
      );
    }
    await Supabase.initialize(
      url: url,
      publishableKey: publishableKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
