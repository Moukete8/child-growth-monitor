/// One row of a WHO LMS reference table: the L (Box-Cox power), M (median)
/// and S (coefficient of variation) parameters for a single lookup point.
///
/// [x] is age in months for weight/height/BMI-for-age, but is the measured
/// length/height in cm for weight-for-height — WHO indexes that one
/// indicator by the child's height, not their age (see
/// `assets/who_tables/README.md`).
class LmsEntry {
  const LmsEntry({required this.x, required this.l, required this.m, required this.s});

  final double x;
  final double l;
  final double m;
  final double s;
}

/// A sex-specific WHO LMS reference table for one indicator
/// (e.g. weight-for-age, height-for-age, weight-for-height).
///
/// Entries must be sorted by [LmsEntry.x] ascending. Values between two
/// entries are linearly interpolated, which matches the approach used by
/// WHO Anthro for non-tabulated points.
class LmsTable {
  const LmsTable(this.entries);

  final List<LmsEntry> entries;

  /// Returns the interpolated (L, M, S) triple for lookup value [x] (age in
  /// months, or height in cm for weight-for-height).
  LmsEntry at(double x) {
    if (entries.isEmpty) {
      throw StateError('LmsTable has no entries loaded.');
    }
    if (x <= entries.first.x) return entries.first;
    if (x >= entries.last.x) return entries.last;

    for (var i = 0; i < entries.length - 1; i++) {
      final a = entries[i];
      final b = entries[i + 1];
      if (x >= a.x && x <= b.x) {
        final t = (x - a.x) / (b.x - a.x);
        return LmsEntry(
          x: x,
          l: a.l + (b.l - a.l) * t,
          m: a.m + (b.m - a.m) * t,
          s: a.s + (b.s - a.s) * t,
        );
      }
    }
    throw RangeError('x=$x is outside the table range.');
  }

  factory LmsTable.fromJson(List<dynamic> rows) {
    return LmsTable(rows
        .map((r) => LmsEntry(
              x: (r['x'] as num).toDouble(),
              l: (r['l'] as num).toDouble(),
              m: (r['m'] as num).toDouble(),
              s: (r['s'] as num).toDouble(),
            ))
        .toList());
  }
}
