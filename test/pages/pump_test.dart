import 'package:flutter_test/flutter_test.dart';
import 'package:otlplus/pages/course_detail_page.dart';
import 'package:otlplus/pages/dictionary_page.dart';
import 'package:otlplus/pages/lecture_detail_page.dart';
import 'package:otlplus/pages/login_page.dart';
// import 'package:otlplus/pages/main_page.dart';
// import 'package:otlplus/pages/review_page.dart';
// import 'package:otlplus/pages/settings_page.dart';
import 'package:otlplus/pages/timetable_page.dart';
// import 'package:otlplus/pages/user_page.dart';
import 'package:otlplus/providers/course_detail_model.dart';
// import 'package:otlplus/providers/info_model.dart';
import 'package:otlplus/providers/lecture_detail_model.dart';
// import 'package:otlplus/providers/review_model.dart';
import 'package:otlplus/providers/lecture_search_model.dart';
// import 'package:otlplus/providers/settings_model.dart';
import 'package:otlplus/providers/timetable_model.dart';

import '../utils/extensions.dart';

void main() {
  testWidgets("pump CourseDetailPage", (WidgetTester tester) async {
    tester.pumpWidget(
        CourseDetailPage().scaffoldAndNotifier(CourseDetailModel()));
  });

  testWidgets("pump DictionaryPage", (WidgetTester tester) async {
    tester
        .pumpWidget(DictionaryPage().scaffoldAndNotifier(LectureSearchModel()));
  });

  testWidgets("pump LectureDetailPage", (WidgetTester tester) async {
    tester.pumpWidget(
        LectureDetailPage().scaffoldAndNotifier(LectureDetailModel()));
  });

  testWidgets("pump LoginPage", (WidgetTester tester) async {
    tester.pumpWidget(LoginPage().material);
  });

  testWidgets("pump MainPage", (WidgetTester tester) async {
    // tester.pumpWidget(MainPage().materialAndNotifier(InfoModel()));
  });

  testWidgets("pump ReviewPage", (WidgetTester tester) async {
    // tester.pumpWidget(ReviewPage().materialAndNotifier(ReviewModel()));
  });

  testWidgets("pump SettingsPage", (WidgetTester tester) async {
    // tester.pumpWidget(SettingsPage().materialAndNotifier(SettingsModel()));
  });

  testWidgets("pump TimetablePage", (WidgetTester tester) async {
    tester.pumpWidget(TimetablePage().materialAndNotifier(TimetableModel()));
  });

  testWidgets("pump UserPage", (WidgetTester tester) async {
    // tester.pumpWidget(UserPage().materialAndNotifier(InfoModel()));
  });
}
