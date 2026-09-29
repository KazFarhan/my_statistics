import 'mean.dart';

/// Population and sample variance.
class Variance {
  Variance._();

  /// Population variance (divides by **n**).
  static double population(Iterable<num> values) => _compute(values, sample: false);

  /// Unbiased sample variance (divides by **n − 1**).
  static double sample(Iterable<num> values) => _compute(values, sample: true);

  /// Default alias — sample variance, the usual choice for observed data.
  static double of(Iterable<num> values) => sample(values);

  static double _compute(Iterable<num> values, {required bool sample}) {
    final list = values.toList(growable: false);
    if (list.isEmpty) {
      throw ArgumentError('Cannot compute variance of an empty collection.');
    }
    if (sample && list.length < 2) {
      throw ArgumentError('Sample variance requires at least two values.');
    }
    final mu = Mean.of(list);
    var ss = 0.0;
    for (final v in list) {
      final d = v - mu;
      ss += d * d;
    }
    final denom = sample ? (list.length - 1) : list.length;
    return ss / denom;
  }
}
