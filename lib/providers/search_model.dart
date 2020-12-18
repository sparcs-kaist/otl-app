import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/models/semester.dart';

enum SearchState {
  progress,
  error,
  done,
}

class SearchModel extends ChangeNotifier {
  List<List<Lecture>> _courses;
  List<List<Lecture>> get courses => _courses ?? [];

  SearchState _state = SearchState.done;
  SearchState get state => _state;

  final _dio = Dio();

  Future<void> search(Semester semester, String keyword,
      {String department = "ALL",
      String type = "ALL",
      String grade = "ALL"}) async {
    _state = SearchState.progress;
    notifyListeners();

    final response = await _dio.get(API_LECTURE_URL, queryParameters: {
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

    _courses = courseIds
        .map((course) =>
            lectures.where((lecture) => lecture.course == course).toList())
        .where((course) => course.length > 0)
        .toList();
    _courses.sort((a, b) => a.first.oldCode.compareTo(b.first.oldCode));

    _state = SearchState.done;
    notifyListeners();
  }
}
