import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlplus/widgets/backdrop.dart';
import 'package:otlplus/widgets/course_block.dart';
import 'package:otlplus/widgets/lecture_group_block.dart';
import 'package:otlplus/widgets/lecture_group_block_row.dart';
import 'package:otlplus/widgets/lecture_group_simple_block.dart';
import 'package:otlplus/widgets/lecture_simple_block.dart';
import 'package:otlplus/widgets/review_block.dart';
import 'package:otlplus/widgets/timetable_block.dart';
import 'package:otlplus/widgets/timetable_summary.dart';
import 'package:otlplus/widgets/timetable_tabs.dart';
import 'package:otlplus/widgets/today_timetable.dart';

import '../samples.dart';

void main() {
  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: BackdropScaffold(frontLayer: Text(""), backLayers: [Text("")])));
  });

  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: CourseBlock(course: SampleCourse.shared)));
  });

  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: LectureGroupBlockRow(
            lecture: SampleLecture.shared,
            onTap: () {
              return;
            })));
  });

  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: LectureGroupBlock(
            lectures: [SampleLecture.shared],
            onTap: (_) {
              return;
            },
            onLongPress: (_) {
              return;
            })));
  });

  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: LectureGroupSimpleBlock(lectures: [], semester: 1)));
  });

  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: LectureSimpleBlock(lecture: SampleLecture.shared)));
  });

  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: ReviewBlock(review: SampleReview.shared)));
  });

  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: TimetableBlock(lecture: SampleLecture.shared)));
  });

  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TimetableSummary(lectures: [])));
  });

  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: TimetableTabs(
            length: 1, onTap: (_) {}, onAddTap: () {}, onSettingsTap: () {})));
  });

  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: TodayTimetable(
            lectures: [SampleLecture.shared],
            builder: (lecture, _) {
              return TimetableBlock(lecture: lecture);
            },
            now: DateTime.now())));
  });
}
