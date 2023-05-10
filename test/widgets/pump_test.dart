import 'package:flutter_test/flutter_test.dart';
// import 'package:otlplus/models/timetable.dart';
import 'package:otlplus/providers/search_model.dart';
import 'package:otlplus/widgets/course_block.dart';
import 'package:otlplus/widgets/course_search.dart';
import 'package:otlplus/widgets/lecture_group_block.dart';
import 'package:otlplus/widgets/lecture_group_block_row.dart';
import 'package:otlplus/widgets/lecture_group_simple_block.dart';
import 'package:otlplus/widgets/lecture_search.dart';
import 'package:otlplus/widgets/lecture_simple_block.dart';
import 'package:otlplus/widgets/review_write_block.dart';
import 'package:otlplus/widgets/search_filter.dart';
// import 'package:otlplus/widgets/timetable.dart' as widget;
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

  testWidgets('pump CourseSearch', (WidgetTester tester) async {
    await tester.pumpWidget(CourseSearch().scaffoldAndNotifier(SearchModel()));
  });

  testWidgets('pump LectureGroupBlockRow', (WidgetTester tester) async {
    await tester.pumpWidget(LectureGroupBlockRow(
        lecture: SampleLecture.shared,
        onTap: () {
          return;
        }).material);
  });

  testWidgets('pump LectureGroupBlock', (WidgetTester tester) async {
    await tester.pumpWidget(LectureGroupBlock(
        lectures: [SampleLecture.shared],
        onTap: (_) {
          return;
        },
        onLongPress: (_) {
          return;
        }).material);
  });

  testWidgets('pump LectureGroupSimpleBlock', (WidgetTester tester) async {
    await tester.pumpWidget(
        LectureGroupSimpleBlock(lectures: [], semester: 1).material);
  });

  testWidgets('pump LectureSearch', (WidgetTester tester) async {
    await tester.pumpWidget(LectureSearch().scaffoldAndNotifier(SearchModel()));
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

  testWidgets('pump SearchFilter', (WidgetTester tester) async {
    await tester.pumpWidget(SearchFilter(
      property: "property",
      items: {"ALL": "전체"},
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
            length: 1, onTap: (_) {}, onAddTap: () {}, onSettingsTap: () {})
        .material);
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
