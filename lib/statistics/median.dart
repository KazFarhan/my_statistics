/// Median and related order-statistic helpers.
class Median {
  Median._();

  /// Returns the median of [values].
  ///
  /// For an even-sized collection the average of the two central values is used.
  /// Throws [ArgumentError] when the collection is empty.
  static double of(Iterable<num> values) {
    final list = values.map((e) => e.toDouble()).toList()..sort();
    if (list.isEmpty) {
      throw ArgumentError('Cannot compute median of an empty collection.');
    }
    final mid = list.length ~/ 2;
    if (list.length.isOdd) {
      return list[mid];
    }
    return (list[mid - 1] + list[mid]) / 2;
  }

  /// Lower quartile (Q1, 25th percentile) using the inclusive method.
  static double q1(Iterable<num> values) => percentile(values, 25);

  /// Upper quartile (Q3, 75th percentile) using the inclusive method.
  static double q3(Iterable<num> values) => percentile(values, 75);

  /// Interquartile range: Q3 − Q1.
  static double iqr(Iterable<num> values) => q3(values) - q1(values);

  /// Linear-interpolation percentile in `[0, 100]`.
  static double percentile(Iterable<num> values, num p) {
    if (p < 0 || p > 100) {
      throw ArgumentError('Percentile must be between 0 and 100.');
    }
    final list = values.map((e) => e.toDouble()).toList()..sort();
    if (list.isEmpty) {
      throw ArgumentError('Cannot compute percentile of an empty collection.');
    }
    if (list.length == 1) return list.first;
    final rank = (p / 100) * (list.length - 1);
    final lo = rank.floor();
    final hi = rank.ceil();
    if (lo == hi) return list[lo];
    final t = rank - lo;
    return list[lo] * (1 - t) + list[hi] * t;
  }
}
