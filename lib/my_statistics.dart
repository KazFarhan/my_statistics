/// Descriptive statistics + eye-catching Flutter charts.
library my_statistics;

// Statistics imports
import 'statistics/mean.dart';
import 'statistics/median.dart';
import 'statistics/mode.dart';
import 'statistics/variance.dart';
import 'statistics/standard_deviation.dart';

// Chart exports
export 'charts/chart_theme.dart';
export 'charts/chart_frame.dart';
export 'charts/line_chart.dart';
export 'charts/bar_chart.dart';
export 'charts/pie_chart.dart';

// Statistics exports
export 'statistics/mean.dart';
export 'statistics/median.dart';
export 'statistics/mode.dart';
export 'statistics/variance.dart';
export 'statistics/standard_deviation.dart';

/// One-call summary of a numeric collection.
class Stats {
  const Stats._({
    required this.count,
    required this.sum,
    required this.min,
    required this.max,
    required this.range,
    required this.mean,
    required this.median,
    required this.mode,
    required this.variance,
    required this.stdDev,
    required this.q1,
    required this.q3,
    required this.iqr,
  });

  final int count;
  final double sum;
  final double min;
  final double max;
  final double range;
  final double mean;
  final double median;
  final List<num> mode;
  final double variance;
  final double stdDev;
  final double q1;
  final double q3;
  final double iqr;

  /// Build a full descriptive snapshot of [values].
  factory Stats.describe(Iterable<num> values) {
    final list = values.toList(growable: false);

    if (list.isEmpty) {
      throw ArgumentError('Cannot describe an empty collection.');
    }

    var sum = 0.0;
    var min = list.first.toDouble();
    var max = list.first.toDouble();

    for (final v in list) {
      final d = v.toDouble();

      sum += d;

      if (d < min) {
        min = d;
      }

      if (d > max) {
        max = d;
      }
    }

    return Stats._(
      count: list.length,
      sum: sum,
      min: min,
      max: max,
      range: max - min,
      mean: Mean.of(list),
      median: Median.of(list),
      mode: Mode.of(list),
      variance: list.length >= 2 ? Variance.sample(list) : 0,
      stdDev: list.length >= 2 ? StandardDeviation.sample(list) : 0,
      q1: Median.q1(list),
      q3: Median.q3(list),
      iqr: Median.iqr(list),
    );
  }

  Map<String, Object> toMap() {
    return {
      'count': count,
      'sum': sum,
      'min': min,
      'max': max,
      'range': range,
      'mean': mean,
      'median': median,
      'mode': mode,
      'variance': variance,
      'stdDev': stdDev,
      'q1': q1,
      'q3': q3,
      'iqr': iqr,
    };
  }

  @override
  String toString() {
    String f(double v) => v.toStringAsFixed(3);

    return 'Stats(n=$count, mean=${f(mean)}, '
        'median=${f(median)}, σ=${f(stdDev)}, '
        'min=${f(min)}, max=${f(max)})';
  }
}