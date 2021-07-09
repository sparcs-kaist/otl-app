import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeplanner_mobile/widgets/timetable_summary.dart';

void main() {
  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TimetableSummary(lectures: [])));
  });
}
