import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_statistics/my_statistics.dart';

void main() {
  testWidgets('GlowLineChart builds', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GlowLineChart(
            animate: false,
            title: 'Line',
            points: [
              ChartPoint(label: 'A', value: 2),
              ChartPoint(label: 'B', value: 5),
              ChartPoint(label: 'C', value: 3),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Line'), findsOneWidget);
  });

  testWidgets('GlowBarChart builds', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GlowBarChart(
            animate: false,
            title: 'Bar',
            points: [
              ChartPoint(label: 'A', value: 10),
              ChartPoint(label: 'B', value: 20),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Bar'), findsOneWidget);
  });

  testWidgets('GlowPieChart builds', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GlowPieChart(
            animate: false,
            title: 'Pie',
            slices: [
              ChartSlice(label: 'A', value: 40),
              ChartSlice(label: 'B', value: 60),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Pie'), findsOneWidget);
  });
}
