import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeplanner_mobile/widgets/lecture_group_simple_block.dart';

void main() {
  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: LectureGroupSimpleBlock(lectures: [], semester: 1)));
  });
}
