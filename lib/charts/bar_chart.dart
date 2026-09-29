import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'chart_frame.dart';
import 'chart_theme.dart';

/// Rounded, gradient, glowing bar chart with optional value labels.
class GlowBarChart extends StatefulWidget {
  const GlowBarChart({
    super.key,
    required this.points,
    this.title,
    this.subtitle,
    this.height = 280,
    this.theme = ChartTheme.dark,
    this.animate = true,
    this.showValues = true,
    this.showGrid = true,
    this.yTicks = 4,
  });

  final List<ChartPoint> points;
  final String? title;
  final String? subtitle;
  final double height;
  final ChartTheme theme;
  final bool animate;
  final bool showValues;
  final bool showGrid;
  final int yTicks;

  @override
  State<GlowBarChart> createState() => _GlowBarChartState();
}

class _GlowBarChartState extends State<GlowBarChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    );
    _t = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant GlowBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.points != widget.points && widget.animate) {
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
            painter: _BarChartPainter(
              points: widget.points,
              theme: widget.theme,
              progress: _t.value.clamp(0.0, 1.0),
              showValues: widget.showValues,
              showGrid: widget.showGrid,
              yTicks: widget.yTicks,
            ),
          );
        },
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  _BarChartPainter({
    required this.points,
    required this.theme,
    required this.progress,
    required this.showValues,
    required this.showGrid,
    required this.yTicks,
  });

  final List<ChartPoint> points;
  final ChartTheme theme;
  final double progress;
  final bool showValues;
  final bool showGrid;
  final int yTicks;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const left = 44.0;
    const right = 12.0;
    const top = 18.0;
    const bottom = 32.0;
    final chart = Rect.fromLTRB(
      left,
      top,
      size.width - right,
      size.height - bottom,
    );

    final values = points.map((p) => p.value).toList();
    var maxV = values.reduce(math.max);
    if (maxV <= 0) maxV = 1;

    if (showGrid) _drawGrid(canvas, chart, maxV);

    final n = points.length;
    final slot = chart.width / n;
    final barW = slot * 0.55;

    for (var i = 0; i < n; i++) {
      final color = points[i].color ?? theme.colorAt(i);
      final h = (points[i].value / maxV) * chart.height * progress;
      final cx = chart.left + slot * i + slot / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, chart.bottom - h / 2),
          width: barW,
          height: math.max(h, 0),
        ),
        const Radius.circular(10),
      );

      final glow = Paint()
        ..color = color.withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawRRect(rect.inflate(3), glow);

      final fill = Paint()
        ..shader = ui.Gradient.linear(
          Offset(cx, chart.bottom - h),
          Offset(cx, chart.bottom),
          [
            Color.lerp(Colors.white, color, 0.25)!,
            color,
            Color.lerp(color, Colors.black, 0.25)!,
          ],
          const [0.0, 0.45, 1.0],
        );
      canvas.drawRRect(rect, fill);

      // glossy highlight
      final gloss = Paint()
        ..shader = ui.Gradient.linear(
          Offset(rect.left, rect.top),
          Offset(rect.right, rect.top),
          [
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.22),
            Colors.white.withOpacity(0.0),
          ],
        );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(rect.left, rect.top, rect.width, math.min(18, h)),
          const Radius.circular(10),
        ),
        gloss,
      );

      if (showValues && progress > 0.85) {
        final label = _fmt(points[i].value);
        final tp = TextPainter(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: theme.title,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
          canvas,
          Offset(cx - tp.width / 2, chart.bottom - h - tp.height - 4),
        );
      }

      final axis = TextPainter(
        text: TextSpan(
          text: points[i].label,
          style: TextStyle(
            color: theme.axisLabel,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: slot);
      axis.paint(canvas, Offset(cx - axis.width / 2, chart.bottom + 8));
    }
  }

  void _drawGrid(Canvas canvas, Rect chart, double maxV) {
    final paint = Paint()
      ..color = theme.grid
      ..strokeWidth = 1;
    final ticks = math.max(1, yTicks);
    for (var i = 0; i <= ticks; i++) {
      final t = i / ticks;
      final y = chart.bottom - chart.height * t;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), paint);
      final tp = TextPainter(
        text: TextSpan(
          text: _fmt(maxV * t),
          style: TextStyle(color: theme.axisLabel, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(chart.left - tp.width - 6, y - tp.height / 2));
    }
  }

  String _fmt(double v) {
    if (v.abs() >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(1);
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) =>
      old.progress != progress || old.points != points || old.theme != theme;
}
