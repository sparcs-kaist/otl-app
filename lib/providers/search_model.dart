import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/dio_provider.dart';
import 'package:timeplanner_mobile/models/course.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/models/semester.dart';

class SearchModel extends ChangeNotifier {
  List<Course> _courses;
  List<Course> get courses => _courses ?? [];

  List<List<Lecture>> _lectures;
  List<List<Lecture>> get lectures => _lectures ?? [];

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Future<void> courseSearch(String keyword,
      {String department = "ALL",
      String type = "ALL",
      String grade = "ALL",
      String term = "ALL"}) async {
    _isSearching = true;
    notifyListeners();

    try {
      final response =
          await DioProvider().dio.get(API_COURSE_URL, queryParameters: {
        "keyword": keyword,
        "department": department,
        "type": type,
        "grade": grade,
        "term": term,
      });

      final rawCourses = response.data as List;
      _courses = rawCourses.map((course) => Course.fromJson(course)).toList();
    } catch (exception) {
      print(exception);
    }

    _isSearching = false;
    notifyListeners();
  }

  Future<void> lectureSearch(Semester semester, String keyword,
      {String department = "ALL",
      String type = "ALL",
      String grade = "ALL"}) async {
    _isSearching = true;
    notifyListeners();

    try {
      final response =
          await DioProvider().dio.get(API_LECTURE_URL, queryParameters: {
        "year": semester.year,
        "semester": semester.semester,
        "keyword": keyword,
        "department": department,
        "type": type,
        "grade": grade,
      });

      final rawLectures = response.data as List;
      final lectures = rawLectures.map((lecture) => Lecture.fromJson(lecture));
      final courseIds = lectures.map((lecture) => lecture.course).toSet();

      _lectures = courseIds
          .map((course) =>
              lectures.where((lecture) => lecture.course == course).toList())
          .where((course) => course.length > 0)
          .toList();
    } catch (exception) {
      print(exception);
    }

    _isSearching = false;
    notifyListeners();
  }
}
