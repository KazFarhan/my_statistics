import 'package:flutter/material.dart';

/// Visual language shared by every chart in this package.
///
/// Dark glass panels, neon accents, soft glow — built to look good
/// on a dashboard without extra dependencies.
class ChartTheme {
  const ChartTheme({
    this.background = const Color(0xFF0B1020),
    this.panel = const Color(0xFF141A2E),
    this.grid = const Color(0x22E6EEFF),
    this.axisLabel = const Color(0xB3E6EEFF),
    this.title = const Color(0xFFF4F7FF),
    this.subtitle = const Color(0x8AE6EEFF),
    this.accent = const Color(0xFF5CE1FF),
    this.accentAlt = const Color(0xFFB388FF),
    this.accentWarm = const Color(0xFFFFC857),
    this.glow = const Color(0x665CE1FF),
    this.palette = const [
      Color(0xFF5CE1FF),
      Color(0xFFB388FF),
      Color(0xFFFF6B9D),
      Color(0xFFFFC857),
      Color(0xFF45F0C0),
      Color(0xFF7AA2FF),
      Color(0xFFFF8A5B),
      Color(0xFFDE5CFF),
    ],
  });

  final Color background;
  final Color panel;
  final Color grid;
  final Color axisLabel;
  final Color title;
  final Color subtitle;
  final Color accent;
  final Color accentAlt;
  final Color accentWarm;
  final Color glow;
  final List<Color> palette;

  Color colorAt(int index) => palette[index % palette.length];

  static const ChartTheme dark = ChartTheme();

  static const ChartTheme midnight = ChartTheme(
    background: Color(0xFF070B16),
    panel: Color(0xFF101628),
    accent: Color(0xFF4DFFDF),
    accentAlt: Color(0xFF7C6BFF),
    glow: Color(0x664DFFDF),
  );

  static const ChartTheme sunset = ChartTheme(
    background: Color(0xFF140A12),
    panel: Color(0xFF221018),
    accent: Color(0xFFFF6B6B),
    accentAlt: Color(0xFFFFC857),
    glow: Color(0x66FF6B6B),
    palette: [
      Color(0xFFFF6B6B),
      Color(0xFFFFC857),
      Color(0xFFFF8A5B),
      Color(0xFFE056A0),
      Color(0xFFFFD6A5),
      Color(0xFFFF5D8F),
    ],
  );
}

/// A named numeric point used by line and bar charts.
class ChartPoint {
  const ChartPoint({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final double value;
  final Color? color;
}

/// A named slice used by the pie / donut chart.
class ChartSlice {
  const ChartSlice({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final double value;
  final Color? color;
}
