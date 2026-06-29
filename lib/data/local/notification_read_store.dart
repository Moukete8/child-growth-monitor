import 'package:shared_preferences/shared_preferences.dart';

/// Tracks which alert notifications a parent has already opened. Local-only
/// (no Supabase column, no sync) — namespaced by user id so a shared demo
/// device doesn't leak read state between accounts.
class NotificationReadStore {
  Future<Set<String>> readIds(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key(userId)) ?? const []).toSet();
  }

  Future<void> markRead(String userId, String alertId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_key(userId)) ?? const []).toSet()
      ..add(alertId);
    await prefs.setStringList(_key(userId), ids.toList());
  }

  String _key(String userId) => 'read_alert_ids:$userId';
}
