import 'package:flutter_test/flutter_test.dart';
import 'package:otlplus/providers/lecture_search_model.dart';
import 'package:otlplus/widgets/course_block.dart';
import 'package:otlplus/widgets/lecture_group_simple_block.dart';
import 'package:otlplus/widgets/lecture_search.dart';
import 'package:otlplus/widgets/lecture_simple_block.dart';
import 'package:otlplus/widgets/review_write_block.dart';
import 'package:otlplus/widgets/timetable_block.dart';
import 'package:otlplus/widgets/timetable_summary.dart';
import 'package:otlplus/widgets/timetable_tabs.dart';
import 'package:otlplus/widgets/today_timetable.dart';

import '../utils/extensions.dart';
import '../utils/samples.dart';

void main() {
  testWidgets('pump CourseBlock', (WidgetTester tester) async {
    await tester.pumpWidget(CourseBlock(course: SampleCourse.shared).material);
  });

  testWidgets('pump LectureGroupBlockRow', (WidgetTester tester) async {
    // await tester.pumpWidget(LectureGroupBlockRow(lecture: SampleLecture.shared).materialAndNotifier(TimetableModel(forTest: true)));
  });

  testWidgets('pump LectureGroupBlock', (WidgetTester tester) async {
    // await tester.pumpWidget(LectureGroupBlock(
    //     lectures: [SampleLecture.shared],
    //     onLongPress: (_) {
    //       return;
    //     }).material);
  });

  testWidgets('pump LectureGroupSimpleBlock', (WidgetTester tester) async {
    await tester.pumpWidget(
        LectureGroupSimpleBlock(lectures: [], semester: 1).material);
  });

  testWidgets('pump LectureSearch', (WidgetTester tester) async {
    await tester
        .pumpWidget(LectureSearch().scaffoldAndNotifier(LectureSearchModel()));
  });

  testWidgets('pump LectureSimpleBlock', (WidgetTester tester) async {
    await tester
        .pumpWidget(LectureSimpleBlock(lecture: SampleLecture.shared).material);
  });

  testWidgets('pump ReviewWriteBlock', (WidgetTester tester) async {
    await tester.pumpWidget(ReviewWriteBlock(
      lecture: SampleLecture.shared,
    ).scaffold);
  });

  testWidgets('pump SemesterPicker', (WidgetTester tester) async {
    // await tester
    //     .pumpWidget(SemesterPicker(onSemesterChanged: () => null).scaffoldAndNotifier(TimetableModel()));
  });

  testWidgets('pump TimetableBlock', (WidgetTester tester) async {
    await tester
        .pumpWidget(TimetableBlock(lecture: SampleLecture.shared).material);
  });

  testWidgets('pump TimetableSummary', (WidgetTester tester) async {
    await tester.pumpWidget(TimetableSummary(lectures: []).material);
  });

  testWidgets('pump TimetableTabs', (WidgetTester tester) async {
    await tester.pumpWidget(TimetableTabs(
      length: 1,
      onTap: (_) {},
      onCopyTap: () {},
      onDeleteTap: () {},
      onExportTap: (_) {},
    ).material);
  });

  testWidgets('pump Timetable', (WidgetTester tester) async {
    //   await tester.pumpWidget(widget.Timetable(lectures: [], builder: (lecture,_)=> TimetableBlock(lecture: lecture)).scaffold);
  });

  testWidgets('pump TodayTimetable', (WidgetTester tester) async {
    await tester.pumpWidget(TodayTimetable(
            lectures: [SampleLecture.shared],
            builder: (lecture, _) {
              return TimetableBlock(lecture: lecture);
            },
            now: DateTime.now())
        .material);
  });
}
