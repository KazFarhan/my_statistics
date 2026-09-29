import 'dart:math' as math;

import 'variance.dart';

/// Population and sample standard deviation.
class StandardDeviation {
  StandardDeviation._();

  /// Population standard deviation (√ of population variance).
  static double population(Iterable<num> values) =>
      math.sqrt(Variance.population(values));

  /// Sample standard deviation (√ of sample variance).
  static double sample(Iterable<num> values) =>
      math.sqrt(Variance.sample(values));

  /// Default alias — sample standard deviation.
  static double of(Iterable<num> values) => sample(values);

  /// Coefficient of variation: σ / μ (uses sample σ).
  static double coefficientOfVariation(Iterable<num> values) {
    final list = values.toList(growable: false);
    if (list.isEmpty) {
      throw ArgumentError('Cannot compute CV of an empty collection.');
    }
    var sum = 0.0;
    for (final v in list) {
      sum += v;
    }
    final mean = sum / list.length;
    if (mean == 0) {
      throw ArgumentError('Coefficient of variation is undefined when mean is 0.');
    }
    return sample(list) / mean.abs();
  }
}
