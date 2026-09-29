import 'package:flutter_test/flutter_test.dart';
import 'package:my_statistics/my_statistics.dart';

void main() {
  group('Mean', () {
    test('arithmetic mean', () {
      expect(Mean.of([1, 2, 3, 4, 5]), 3);
    });

    test('weighted mean', () {
      expect(Mean.weighted([10, 20], [1, 3]), 17.5);
    });

    test('geometric mean of 1,3,9', () {
      expect(Mean.geometric([1, 3, 9]), closeTo(3, 1e-9));
    });

    test('harmonic mean of 1,2,4', () {
      expect(Mean.harmonic([1, 2, 4]), closeTo(12 / 7, 1e-9));
    });

    test('empty throws', () {
      expect(() => Mean.of([]), throwsArgumentError);
    });
  });

  group('Median', () {
    test('odd length', () {
      expect(Median.of([9, 1, 5]), 5);
    });

    test('even length', () {
      expect(Median.of([1, 2, 3, 4]), 2.5);
    });

    test('percentile 50 equals median for odd n', () {
      expect(Median.percentile([1, 2, 3, 4, 5], 50), 3);
    });
  });

  group('Mode', () {
    test('unimodal', () {
      expect(Mode.of([1, 2, 2, 3]), [2]);
    });

    test('bimodal', () {
      expect(Mode.of([1, 1, 2, 2, 3]), [1, 2]);
    });
  });

  group('Variance & SD', () {
    test('population variance of 1..5', () {
      // mean=3, ss=10, n=5 → 2
      expect(Variance.population([1, 2, 3, 4, 5]), closeTo(2, 1e-9));
    });

    test('sample variance of 1..5', () {
      expect(Variance.sample([1, 2, 3, 4, 5]), closeTo(2.5, 1e-9));
    });

    test('sample standard deviation of 1..5', () {
      expect(
        StandardDeviation.sample([1, 2, 3, 4, 5]),
        closeTo(1.58113883008, 1e-9),
      );
    });
  });

  group('Stats.describe', () {
    test('snapshot fields', () {
      final s = Stats.describe([2, 4, 4, 4, 5, 5, 7, 9]);
      expect(s.count, 8);
      expect(s.mean, 5);
      expect(s.median, 4.5);
      expect(s.mode, [4]);
      expect(s.min, 2);
      expect(s.max, 9);
    });
  });
}
