import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roadscan/main.dart';
import 'package:roadscan/pages/main_page.dart';
import 'package:roadscan/pages/scan_page.dart';

void main() {
  testWidgets('Main page renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const RoadScanApp());
    expect(find.text('RoadScan'), findsOneWidget);
    expect(find.text('Start Inspection'), findsOneWidget);
  });

  testWidgets('Navigate to scan page', (WidgetTester tester) async {
    await tester.pumpWidget(const RoadScanApp());
    await tester.tap(find.text('Start Inspection'));
    await tester.pumpAndSettle();
    expect(find.byType(ScanPage), findsOneWidget);
  });
}
