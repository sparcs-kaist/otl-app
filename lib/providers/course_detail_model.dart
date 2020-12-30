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

  String _selectedFilter;
  String get selectedFilter => _selectedFilter;

  Lecture get selectedLecture {
    if (_selectedFilter == "ALL") return null;
    return _lectures.firstWhere(
        (lecture) => lecture.professors.any(
            (professor) => professor.professorId.toString() == _selectedFilter),
        orElse: () => null);
  }

  List<Lecture> _lectures;
  List<Lecture> get lectures => _lectures;

  List<Professor> _professors;
  List<Professor> get professors => _professors;

  bool _hasData = false;
  bool get hasData => _hasData;

  List<Review> _reviews;
  List<Review> get reviews {
    if (_reviews == null) return [];
    if (_selectedFilter == "ALL") return _reviews;
    return _reviews
        .where((review) => review.lecture.professors.any(
            (professor) => professor.professorId.toString() == _selectedFilter))
        .toList();
  }

  Future<void> loadCourse(int courseId) async {
    _hasData = false;
    notifyListeners();

    final response =
        await DioProvider().dio.get(API_COURSE_URL + "/" + courseId.toString());

    _course = Course.fromJson(response.data);
    _lectures = await getCourseLectures();
    _professors = _lectures
        .map((lecture) => lecture.professors)
        .expand((e) => e)
        .toSet()
        .toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    _reviews = await getCourseReviews();
    _selectedFilter = "ALL";

    _hasData = true;
    notifyListeners();
  }

  Future<void> updateCourseReviews(Review review) async {
    int index = _reviews.indexOf(review);
    if (index > -1) {
      _reviews.removeAt(index);
      _reviews.insert(index, review);
    } else {
      _reviews.insert(0, review);
    }
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
