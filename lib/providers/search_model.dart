import 'package:flutter/material.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/models/course.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/models/semester.dart';

class SearchModel extends ChangeNotifier {
  List<Course> _courses;
  List<Course> get courses => _courses ?? [];

  List<List<Lecture>> _lectures;
  List<List<Lecture>> get lectures => _lectures ?? [];

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  void lectureClear() {
    _lectures = null;
    notifyListeners();
  }

  Future<void> courseSearch(String keyword,
      {List<String> department,
      List<String> type,
      List<String> grade,
      String order = "DEF",
      String term = "ALL",
      double tune = 3}) async {
    _isSearching = true;
    notifyListeners();

    try {
      final response = await DioProvider()
          .dio
          .getUri(Uri(path: API_COURSE_URL, queryParameters: {
            "keyword": keyword,
            "department": department ?? "ALL",
            "type": type ?? "ALL",
            "grade": grade ?? "ALL",
            "term": term,
          }));

      final rawCourses = response.data as List;
      _courses = rawCourses.map((course) => Course.fromJson(course)).toList();

      switch (order) {
        case "RAT":
          final avgRatings = _courses.fold<double>(
                  0, (acc, val) => acc + val.grade + val.load + val.speech) /
              _courses.length;
          _courses.sort((a, b) {
            final aRating = ((a.grade + a.load + a.speech) * a.reviewNum +
                    avgRatings * tune) /
                (a.reviewNum + tune);
            final bRating = ((b.grade + b.load + b.speech) * b.reviewNum +
                    avgRatings * tune) /
                (b.reviewNum + tune);
            return bRating.compareTo(aRating);
          });
          break;
        case "GRA":
          final avgRatings =
              _courses.fold<double>(0, (acc, val) => acc + val.grade) /
                  _courses.length;
          _courses.sort((a, b) {
            final aRating = (a.grade * a.reviewNum + avgRatings * tune) /
                (a.reviewNum + tune);
            final bRating = (b.grade * b.reviewNum + avgRatings * tune) /
                (b.reviewNum + tune);
            return bRating.compareTo(aRating);
          });
          break;
        case "LOA":
          final avgRatings =
              _courses.fold<double>(0, (acc, val) => acc + val.load) /
                  _courses.length;
          _courses.sort((a, b) {
            final aRating = (a.load * a.reviewNum + avgRatings * tune) /
                (a.reviewNum + tune);
            final bRating = (b.load * b.reviewNum + avgRatings * tune) /
                (b.reviewNum + tune);
            return bRating.compareTo(aRating);
          });
          break;
        case "SPE":
          final avgRatings =
              _courses.fold<double>(0, (acc, val) => acc + val.speech) /
                  _courses.length;
          _courses.sort((a, b) {
            final aRating = (a.speech * a.reviewNum + avgRatings * tune) /
                (a.reviewNum + tune);
            final bRating = (b.speech * b.reviewNum + avgRatings * tune) /
                (b.reviewNum + tune);
            return bRating.compareTo(aRating);
          });
          break;
      }
    } catch (exception) {
      print(exception);
    }

    _isSearching = false;
    notifyListeners();
  }

  Future<void> lectureSearch(Semester semester, String keyword,
      {List<String> department, List<String> type, List<String> grade}) async {
    _isSearching = true;
    notifyListeners();

    try {
      final response = await DioProvider()
          .dio
          .getUri(Uri(path: API_LECTURE_URL, queryParameters: {
            "year": semester.year.toString(),
            "semester": semester.semester.toString(),
            "keyword": keyword,
            "department": department,
            "type": type,
            "grade": grade,
          }));

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
