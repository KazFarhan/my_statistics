import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'chart_frame.dart';
import 'chart_theme.dart';

/// Animated donut / pie chart with glow, percentages and a legend.
class GlowPieChart extends StatefulWidget {
  const GlowPieChart({
    super.key,
    required this.slices,
    this.title,
    this.subtitle,
    this.height = 280,
    this.theme = ChartTheme.dark,
    this.animate = true,
    this.donut = true,
    this.showPercent = true,
    this.centerLabel,
    this.centerValue,
  });

  final List<ChartSlice> slices;
  final String? title;
  final String? subtitle;
  final double height;
  final ChartTheme theme;
  final bool animate;
  final bool donut;
  final bool showPercent;
  final String? centerLabel;
  final String? centerValue;

  @override
  State<GlowPieChart> createState() => _GlowPieChartState();
}

class _GlowPieChartState extends State<GlowPieChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _t = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant GlowPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slices != widget.slices && widget.animate) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChartFrame(
      theme: widget.theme,
      title: widget.title,
      subtitle: widget.subtitle,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _t,
        builder: (context, _) {
          return CustomPaint(
            painter: _PieChartPainter(
              slices: widget.slices,
              theme: widget.theme,
              progress: _t.value.clamp(0.0, 1.0),
              donut: widget.donut,
              showPercent: widget.showPercent,
              centerLabel: widget.centerLabel,
              centerValue: widget.centerValue,
            ),
          );
        },
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  _PieChartPainter({
    required this.slices,
    required this.theme,
    required this.progress,
    required this.donut,
    required this.showPercent,
    this.centerLabel,
    this.centerValue,
  });

  final List<ChartSlice> slices;
  final ChartTheme theme;
  final double progress;
  final bool donut;
  final bool showPercent;
  final String? centerLabel;
  final String? centerValue;

  @override
  void paint(Canvas canvas, Size size) {
    if (slices.isEmpty) return;
    final total = slices.fold<double>(0, (a, s) => a + s.value);
    if (total <= 0) return;

    final side = math.min(size.height, size.width * 0.58);
    final center = Offset(side / 2 + 8, size.height / 2);
    final radius = side * 0.38;
    final stroke = donut ? radius * 0.46 : radius;

    // outer glow ring
    canvas.drawCircle(
      center,
      radius + 6,
      Paint()
        ..color = theme.glow.withOpacity(0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );

    var start = -math.pi / 2;
    for (var i = 0; i < slices.length; i++) {
      final sweep = (slices[i].value / total) * math.pi * 2 * progress;
      final color = slices[i].color ?? theme.colorAt(i);

      final glow = Paint()
        ..color = color.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke + 8
        ..strokeCap = StrokeCap.butt
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        glow,
      );

      final paint = Paint()
        ..shader = ui.Gradient.sweep(
          center,
          [
            Color.lerp(Colors.white, color, 0.25)!,
            color,
            Color.lerp(color, Colors.black, 0.18)!,
          ],
          const [0.0, 0.55, 1.0],
          TileMode.clamp,
          start,
          start + (sweep == 0 ? 0.001 : sweep),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );

      if (showPercent && progress > 0.85 && sweep > 0.28) {
        final mid = start + sweep / 2;
        final labelR = radius;
        final pos = Offset(
          center.dx + math.cos(mid) * labelR,
          center.dy + math.sin(mid) * labelR,
        );
        final pct = '${((slices[i].value / total) * 100).round()}%';
        final tp = TextPainter(
          text: TextSpan(
            text: pct,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
      }

      start += sweep;
    }

    if (donut) {
      canvas.drawCircle(
        center,
        radius - stroke / 2 - 2,
        Paint()
          ..color = theme.panel
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.4),
      );
      canvas.drawCircle(
        center,
        radius - stroke / 2 - 2,
        Paint()
          ..shader = ui.Gradient.radial(center, radius * 0.7, [
            Color.lerp(theme.panel, Colors.white, 0.06)!,
            theme.panel,
          ]),
      );

      if (centerValue != null) {
        final valueTp = TextPainter(
          text: TextSpan(
            text: centerValue,
            style: TextStyle(
              color: theme.title,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        valueTp.paint(
          canvas,
          center - Offset(valueTp.width / 2, valueTp.height / 2 + 8),
        );
      }
      if (centerLabel != null) {
        final labelTp = TextPainter(
          text: TextSpan(
            text: centerLabel,
            style: TextStyle(
              color: theme.subtitle,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        labelTp.paint(
          canvas,
          center - Offset(labelTp.width / 2, -10),
        );
      }
    }

    _drawLegend(canvas, size, side, total);
  }

  void _drawLegend(Canvas canvas, Size size, double pieSide, double total) {
    final origin = Offset(pieSide + 16, 16);
    var y = origin.dy;
    for (var i = 0; i < slices.length; i++) {
      final color = slices[i].color ?? theme.colorAt(i);
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(origin.dx, y + 3, 10, 10),
        const Radius.circular(3),
      );
      canvas.drawRRect(r, Paint()..color = color);

      final pct = ((slices[i].value / total) * 100).toStringAsFixed(1);
      final tp = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${slices[i].label}\n',
              style: TextStyle(
                color: theme.title,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: '$pct%  ·  ${_fmt(slices[i].value)}',
              style: TextStyle(color: theme.subtitle, fontSize: 10),
            ),
          ],
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width - origin.dx - 8);
      tp.paint(canvas, Offset(origin.dx + 16, y));
      y += tp.height + 12;
    }
  }

  String _fmt(double v) {
    if (v.abs() >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(1);
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter old) =>
      old.progress != progress || old.slices != slices || old.theme != theme;
}
