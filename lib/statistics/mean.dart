import 'dart:math' as math;

/// Arithmetic, geometric, harmonic and weighted mean helpers.
class Mean {
  Mean._();

  /// Returns the arithmetic mean of [values].
  ///
  /// Throws [ArgumentError] when the collection is empty.
  static double of(Iterable<num> values) {
    final list = values.toList(growable: false);
    if (list.isEmpty) {
      throw ArgumentError('Cannot compute mean of an empty collection.');
    }
    var sum = 0.0;
    for (final v in list) {
      sum += v;
    }
    return sum / list.length;
  }

  /// Weighted arithmetic mean.
  ///
  /// [values] and [weights] must have the same non-zero length.
  static double weighted(Iterable<num> values, Iterable<num> weights) {
    final xs = values.toList(growable: false);
    final ws = weights.toList(growable: false);
    if (xs.isEmpty) {
      throw ArgumentError(
        'Cannot compute weighted mean of an empty collection.',
      );
    }
    if (xs.length != ws.length) {
      throw ArgumentError('values and weights must have the same length.');
    }
    var weightedSum = 0.0;
    var weightTotal = 0.0;
    for (var i = 0; i < xs.length; i++) {
      weightedSum += xs[i] * ws[i];
      weightTotal += ws[i];
    }
    if (weightTotal == 0) {
      throw ArgumentError('Sum of weights must not be zero.');
    }
    return weightedSum / weightTotal;
  }

  /// Geometric mean. All values must be strictly greater than zero.
  static double geometric(Iterable<num> values) {
    final list = values.toList(growable: false);
    if (list.isEmpty) {
      throw ArgumentError(
        'Cannot compute geometric mean of an empty collection.',
      );
    }
    var logSum = 0.0;
    for (final v in list) {
      if (v <= 0) {
        throw ArgumentError(
          'Geometric mean requires strictly positive values.',
        );
      }
      logSum += math.log(v.toDouble());
    }
    return math.exp(logSum / list.length);
  }

  /// Harmonic mean. All values must be strictly greater than zero.
  static double harmonic(Iterable<num> values) {
    final list = values.toList(growable: false);
    if (list.isEmpty) {
      throw ArgumentError(
        'Cannot compute harmonic mean of an empty collection.',
      );
    }
    var invSum = 0.0;
    for (final v in list) {
      if (v <= 0) {
        throw ArgumentError('Harmonic mean requires strictly positive values.');
      }
      invSum += 1 / v;
    }
    return list.length / invSum;
  }
}
