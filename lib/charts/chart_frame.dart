import 'package:flutter/material.dart';

import 'chart_theme.dart';

/// Frosted glass panel that wraps every chart.
class ChartFrame extends StatelessWidget {
  const ChartFrame({
    super.key,
    required this.theme,
    required this.child,
    required this.height,
    this.title,
    this.subtitle,
  });

  final ChartTheme theme;
  final Widget child;
  final double height;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.panel,
            Color.lerp(theme.panel, theme.background, 0.45)!,
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
        boxShadow: [
          BoxShadow(
            color: theme.glow.withOpacity(0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                color: theme.title,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 8),
                child: Text(
                  subtitle!,
                  style: TextStyle(color: theme.subtitle, fontSize: 12),
                ),
              )
            else
              const SizedBox(height: 8),
          ],
          SizedBox(height: height, child: child),
        ],
      ),
    );
  }
}
