/// Formats a past [DateTime] as "Today", "1 day ago" or "N days ago" —
/// the day-granularity relative time used across dashboards, alerts and
/// notifications.
String relativeTime(DateTime d) {
  final days = DateTime.now().difference(d).inDays;
  if (days <= 0) return 'Today';
  if (days == 1) return '1 day ago';
  return '$days days ago';
}
