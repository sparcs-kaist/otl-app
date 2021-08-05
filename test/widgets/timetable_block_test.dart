import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlplus/models/classtime.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/widgets/timetable_block.dart';

void main() {
  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: TimetableBlock(
      lecture: Lecture(course: 1, classtimes: [Classtime()]),
    )));
  });
}
