import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/dio_provider.dart';
import 'package:timeplanner_mobile/models/course.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/models/professor.dart';
import 'package:timeplanner_mobile/models/review.dart';

class CourseDetailModel extends ChangeNotifier {
  Course _course;
  Course get course => _course;

  List<Lecture> _lectures;
  List<Lecture> get lectures => _lectures;

  bool _hasData = false;
  bool get hasData => _hasData;

  String _selectedFilter;

  List<Professor> _reviewProfessors;
  List<Professor> get reviewProfessors => _reviewProfessors;

  List<Review> _reviews;
  List<Review> get reviews {
    if (_reviews == null) return [];
    if (_selectedFilter == "ALL") return _reviews;
    return _reviews
        .where((review) => review.lecture.professors.any(
            (professor) => professor.professorId.toString() == _selectedFilter))
        .toList();
  }

  Future<void> loadCourse(Course course) async {
    _hasData = false;
    notifyListeners();

    _course = course;
    _lectures = await getCourseLectures();
    _reviews = await getCourseReviews();
    _reviewProfessors = _reviews
        .map((review) => review.lecture.professors)
        .fold<List<Professor>>(<Professor>[], (acc, val) => [...acc, ...val])
          ..sort((a, b) => a.name.compareTo(b.name));
    _selectedFilter = "ALL";

    _hasData = true;
    notifyListeners();
  }

  Future<List<Lecture>> getCourseLectures() async {
    final response = await DioProvider().dio.get(
        API_COURSE_LECTURE_URL.replaceFirst("{id}", _course.id.toString()));
    final rawLectures = response.data as List;
    return rawLectures.map((lecture) => Lecture.fromJson(lecture)).toList();
  }

  Future<List<Review>> getCourseReviews() async {
    final response = await DioProvider()
        .dio
        .get(API_COURSE_REVIEW_URL.replaceFirst("{id}", _course.id.toString()));
    final rawReviews = response.data as List;
    return rawReviews.map((review) => Review.fromJson(review)).toList();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }
}
