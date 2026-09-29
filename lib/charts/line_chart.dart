import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'chart_frame.dart';
import 'chart_theme.dart';

/// Smooth, glowing, animated line / area chart.
class GlowLineChart extends StatefulWidget {
  const GlowLineChart({
    super.key,
    required this.points,
    this.title,
    this.subtitle,
    this.height = 280,
    this.theme = ChartTheme.dark,
    this.animate = true,
    this.showArea = true,
    this.showDots = true,
    this.showGrid = true,
    this.strokeWidth = 3.0,
    this.yTicks = 4,
  });

  final List<ChartPoint> points;
  final String? title;
  final String? subtitle;
  final double height;
  final ChartTheme theme;
  final bool animate;
  final bool showArea;
  final bool showDots;
  final bool showGrid;
  final double strokeWidth;
  final int yTicks;

  @override
  State<GlowLineChart> createState() => _GlowLineChartState();
}

class _GlowLineChartState extends State<GlowLineChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _t = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant GlowLineChart oldWidget) {
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
            painter: _LineChartPainter(
              points: widget.points,
              theme: widget.theme,
              progress: _t.value,
              showArea: widget.showArea,
              showDots: widget.showDots,
              showGrid: widget.showGrid,
              strokeWidth: widget.strokeWidth,
              yTicks: widget.yTicks,
            ),
          );
        },
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.points,
    required this.theme,
    required this.progress,
    required this.showArea,
    required this.showDots,
    required this.showGrid,
    required this.strokeWidth,
    required this.yTicks,
  });

  final List<ChartPoint> points;
  final ChartTheme theme;
  final double progress;
  final bool showArea;
  final bool showDots;
  final bool showGrid;
  final double strokeWidth;
  final int yTicks;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const left = 44.0;
    const right = 12.0;
    const top = 12.0;
    const bottom = 32.0;
    final chart = Rect.fromLTRB(
      left,
      top,
      size.width - right,
      size.height - bottom,
    );

    final values = points.map((p) => p.value).toList();
    var minV = values.reduce(math.min);
    var maxV = values.reduce(math.max);
    if (minV == maxV) {
      minV -= 1;
      maxV += 1;
    }
    final pad = (maxV - minV) * 0.12;
    minV -= pad;
    maxV += pad;

    if (showGrid) {
      _drawGrid(canvas, chart, minV, maxV);
    }

    final path = _smoothPath(chart, minV, maxV);
    final metrics = path.computeMetrics();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final extract = metric.extractPath(
      0,
      metric.length * progress.clamp(0.0, 1.0),
    );

    if (showArea && extract.computeMetrics().isNotEmpty) {
      final last = _lastPointOn(extract, chart);
      final area = Path.from(extract)
        ..lineTo(last.dx, chart.bottom)
        ..lineTo(chart.left, chart.bottom)
        ..close();
      final fill = Paint()
        ..shader = ui.Gradient.linear(
          Offset(chart.left, chart.top),
          Offset(chart.left, chart.bottom),
          [
            theme.accent.withOpacity(0.42),
            theme.accentAlt.withOpacity(0.02),
          ],
        );
      canvas.drawPath(area, fill);
    }

    final glow = Paint()
      ..color = theme.glow
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawPath(extract, glow);

    final line = Paint()
      ..shader = ui.Gradient.linear(
        Offset(chart.left, 0),
        Offset(chart.right, 0),
        [theme.accent, theme.accentAlt],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(extract, line);

    if (showDots) {
      final n = points.length;
      for (var i = 0; i < n; i++) {
        final t = n == 1 ? 0.0 : i / (n - 1);
        if (t > progress) break;
        final p = _pointAt(chart, minV, maxV, i);
        canvas.drawCircle(p, 7, Paint()..color = theme.glow);
        canvas.drawCircle(
          p,
          4.2,
          Paint()
            ..shader = ui.Gradient.radial(p, 6, [
              Colors.white,
              theme.accent,
            ]),
        );
      }
    }

    _drawXLabels(canvas, chart);
  }

  Offset _lastPointOn(Path extract, Rect chart) {
    final ms = extract.computeMetrics();
    if (ms.isEmpty) return Offset(chart.left, chart.bottom);
    final m = ms.first;
    final t = m.getTangentForOffset(m.length);
    return t?.position ?? Offset(chart.left, chart.bottom);
  }

  void _drawGrid(Canvas canvas, Rect chart, double minV, double maxV) {
    final paint = Paint()
      ..color = theme.grid
      ..strokeWidth = 1;
    final ticks = math.max(1, yTicks);
    const tpStyle = TextStyle(
      color: Color(0xB3E6EEFF),
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );
    for (var i = 0; i <= ticks; i++) {
      final t = i / ticks;
      final y = chart.bottom - chart.height * t;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), paint);
      final value = minV + (maxV - minV) * t;
      final tp = TextPainter(
        text: TextSpan(
          text: _fmt(value),
          style: tpStyle.copyWith(color: theme.axisLabel),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(chart.left - tp.width - 6, y - tp.height / 2));
    }
  }

  void _drawXLabels(Canvas canvas, Rect chart) {
    final style = TextStyle(
      color: theme.axisLabel,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );
    final n = points.length;
    final step = n <= 8 ? 1 : (n / 6).ceil();
    for (var i = 0; i < n; i += step) {
      final x = n == 1
          ? chart.center.dx
          : chart.left + chart.width * i / (n - 1);
      final tp = TextPainter(
        text: TextSpan(text: points[i].label, style: style),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 64);
      tp.paint(canvas, Offset(x - tp.width / 2, chart.bottom + 8));
    }
  }

  Path _smoothPath(Rect chart, double minV, double maxV) {
    final n = points.length;
    final pts = <Offset>[
      for (var i = 0; i < n; i++) _pointAt(chart, minV, maxV, i),
    ];
    final path = Path();
    if (pts.isEmpty) return path;
    path.moveTo(pts.first.dx, pts.first.dy);
    if (pts.length == 1) return path;
    if (pts.length == 2) {
      path.lineTo(pts[1].dx, pts[1].dy);
      return path;
    }
    for (var i = 0; i < pts.length - 1; i++) {
      final p0 = pts[i];
      final p1 = pts[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      path.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }
    return path;
  }

  Offset _pointAt(Rect chart, double minV, double maxV, int i) {
    final n = points.length;
    final x = n == 1
        ? chart.center.dx
        : chart.left + chart.width * i / (n - 1);
    final t = (points[i].value - minV) / (maxV - minV);
    final y = chart.bottom - chart.height * t;
    return Offset(x, y);
  }

  String _fmt(double v) {
    if (v.abs() >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    if (v == v.roundToDouble()) return v.toStringAsFixed(0);
    return v.toStringAsFixed(1);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) =>
      old.progress != progress || old.points != points || old.theme != theme;
}
