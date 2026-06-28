import '../../data/repositories/measurement_repository.dart';

/// Formats a date of birth as e.g. "8 mo" or "2 yrs 3 mo", matching the
/// prototype's child-list/profile copy.
String formatAge(DateTime dateOfBirth, {DateTime? at}) {
  final months = ageInMonths(dateOfBirth, at ?? DateTime.now());
  if (months < 12) return '$months mo';
  final years = months ~/ 12;
  final rem = months % 12;
  final yearsLabel = '$years yr${years == 1 ? '' : 's'}';
  return rem == 0 ? yearsLabel : '$yearsLabel $rem mo';
}
