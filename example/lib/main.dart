import 'package:flutter/material.dart';
import 'package:my_statistics/my_statistics.dart';

void main() => runApp(const StatsGalleryApp());

class StatsGalleryApp extends StatelessWidget {
  const StatsGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'my_statistics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF070B16),
        fontFamily: 'Roboto',
      ),
      home: const GalleryPage(),
    );
  }
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  static const sales = <num>[42, 55, 48, 70, 63, 88, 79, 94, 81, 110, 98, 124];
  static const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final stats = Stats.describe(sales);
    final points = [
      for (var i = 0; i < sales.length; i++)
        ChartPoint(label: months[i], value: sales[i].toDouble()),
    ];

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF070B16), Color(0xFF121833), Color(0xFF0B1020)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            children: [
              const Text(
                'my_statistics',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Descriptive stats + neon charts',
                style: TextStyle(color: Colors.white.withOpacity(0.55)),
              ),
              const SizedBox(height: 20),
              _StatGrid(stats: stats),
              const SizedBox(height: 20),
              GlowLineChart(
                title: 'Monthly revenue',
                subtitle: 'Smooth glow line · sample year',
                points: points,
                theme: ChartTheme.midnight,
              ),
              const SizedBox(height: 20),
              GlowBarChart(
                title: 'Monthly revenue',
                subtitle: 'Rounded gradient bars',
                points: points,
                theme: ChartTheme.dark,
              ),
              const SizedBox(height: 20),
              GlowPieChart(
                title: 'Channel mix',
                subtitle: 'Donut with live legend',
                theme: ChartTheme.sunset,
                centerLabel: 'Share',
                centerValue: '100%',
                slices: const [
                  ChartSlice(label: 'Organic', value: 38),
                  ChartSlice(label: 'Paid', value: 27),
                  ChartSlice(label: 'Referral', value: 18),
                  ChartSlice(label: 'Social', value: 12),
                  ChartSlice(label: 'Other', value: 5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.stats});

  final Stats stats;

  @override
  Widget build(BuildContext context) {
    final cards = <(String, String)>[
      ('Mean', stats.mean.toStringAsFixed(2)),
      ('Median', stats.median.toStringAsFixed(2)),
      ('Mode', stats.mode.join(', ')),
      ('σ  Std Dev', stats.stdDev.toStringAsFixed(2)),
      ('Variance', stats.variance.toStringAsFixed(2)),
      ('Range', stats.range.toStringAsFixed(0)),
      ('Q1 / Q3', '${stats.q1.toStringAsFixed(1)}  ·  ${stats.q3.toStringAsFixed(1)}'),
      ('n', '${stats.count}'),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        for (final c in cards)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xFF141A2E),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  c.$1,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  c.$2,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF5CE1FF),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
