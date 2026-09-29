# my_statistics

Descriptive statistics for Dart, plus **eye-catching** Flutter charts — glow
lines, gradient bars, neon donuts — with **zero extra chart packages**.

```
my_statistics/
├── lib/
│   ├── my_statistics.dart
│   ├── statistics/
│   │   ├── mean.dart
│   │   ├── median.dart
│   │   ├── mode.dart
│   │   ├── variance.dart
│   │   └── standard_deviation.dart
│   └── charts/
│       ├── line_chart.dart
│       ├── bar_chart.dart
│       └── pie_chart.dart
├── example/          # live gallery app
├── test/
├── README.md
├── CHANGELOG.md
├── LICENSE
└── pubspec.yaml
```

---

## Install

Path dependency (this zip):

```yaml
dependencies:
  my_statistics:
    path: ../my_statistics
```

Then:

```dart
import 'package:my_statistics/my_statistics.dart';
```

---

## Statistics

```dart
final data = [2, 4, 4, 4, 5, 5, 7, 9];

Mean.of(data);                       // 5.0
Mean.weighted([10, 20], [1, 3]);     // 17.5
Mean.geometric([1, 3, 9]);           // 3.0
Mean.harmonic([1, 2, 4]);            // ≈ 1.714

Median.of(data);                     // 4.5
Median.q1(data);
Median.q3(data);
Median.iqr(data);
Median.percentile(data, 90);

Mode.of(data);                       // [4]
Mode.primary(data);                  // 4

Variance.sample(data);               // n − 1
Variance.population(data);           // n
StandardDeviation.sample(data);
StandardDeviation.coefficientOfVariation(data);

final snap = Stats.describe(data);
print(snap.mean);
print(snap.stdDev);
print(snap.toMap());
```

Empty input throws `ArgumentError`. Sample variance / SD need at least 2 values.

---

## Charts

Drop any widget into a dark scaffold. They animate on first build.

```dart
GlowLineChart(
  title: 'Monthly revenue',
  subtitle: 'Smooth glow line',
  theme: ChartTheme.midnight,
  points: const [
    ChartPoint(label: 'Jan', value: 42),
    ChartPoint(label: 'Feb', value: 55),
    ChartPoint(label: 'Mar', value: 70),
  ],
);

GlowBarChart(
  title: 'Monthly revenue',
  theme: ChartTheme.dark,
  points: const [
    ChartPoint(label: 'Jan', value: 42),
    ChartPoint(label: 'Feb', value: 55),
  ],
);

GlowPieChart(
  title: 'Channel mix',
  theme: ChartTheme.sunset,
  centerLabel: 'Share',
  centerValue: '100%',
  slices: const [
    ChartSlice(label: 'Organic', value: 38),
    ChartSlice(label: 'Paid', value: 27),
    ChartSlice(label: 'Referral', value: 18),
  ],
);
```

Themes: `ChartTheme.dark`, `ChartTheme.midnight`, `ChartTheme.sunset`.
Pass your own `ChartTheme(...)` to recolor the palette.

---

## Run the gallery

```bash
cd example
flutter pub get
flutter run
```

The example page shows a stat grid plus line, bar and pie on the same dataset.

---

## Tests

```bash
flutter test
```

---

## License

MIT — see [LICENSE](LICENSE).
