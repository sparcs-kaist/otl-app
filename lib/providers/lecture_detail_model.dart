import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/dio_provider.dart';
import 'package:timeplanner_mobile/models/course.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/models/review.dart';

class LectureDetailModel extends ChangeNotifier {
  Lecture _lecture;
  Lecture get lecture => _lecture;

  Course _course;
  Course get course => _course;

  bool _hasData = false;
  bool get hasData => _hasData;

  List<Review> _reviews;
  List<Review> get reviews => _reviews;

  Future<void> loadLecture(Lecture lecture) async {
    _hasData = false;
    notifyListeners();

    _lecture = lecture;
    _course = await getLectureCourse();
    _reviews = await getLectureReviews();

    _hasData = true;
    notifyListeners();
  }

  Future<List<Review>> getLectureReviews() async {
    final response = await DioProvider().dio.get(API_LECTURE_RELATED_REVIEWS_URL
        .replaceFirst("{id}", _lecture.id.toString()));
    final rawReviews = response.data as List;
    return rawReviews.map((review) => Review.fromJson(review)).toSet().toList();
  }

  Future<Course> getLectureCourse() async {
    final response = await DioProvider()
        .dio
        .get(API_COURSE_URL + "/" + _lecture.course.toString());
    return Course.fromJson(response.data);
  }
}
