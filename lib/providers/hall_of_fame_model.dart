import 'package:flutter/material.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/models/review.dart';
import 'package:otlplus/models/semester.dart';

class HallOfFameModel extends ChangeNotifier {
  int _page = 0;
  int get page => _page;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Review> _hallOfFames = <Review>[];
  List<Review> hallOfFames(Semester s) {
    if (_hallOfFames.length == 0 && !_isLoading) loadHallOfFames(s);
    return _hallOfFames;
  }

  Future<void> clear(Semester s) async {
    _hallOfFames.clear();
    _page = 0;
    await loadHallOfFames(s);
  }

  Future<void> loadHallOfFames(Semester s) async {
    _isLoading = true;

    try {
      final response =
          await DioProvider().dio.get(API_REVIEW_URL, queryParameters: {
        "lecture_year": s.year,
        "lecture_semester": s.semester,
        "order": "-like",
        "offset": _page * 10,
        "limit": 10,
      });
      final rawReviews = response.data as List;
      _hallOfFames.addAll(rawReviews.map((review) => Review.fromJson(review)));
      _page++;
      _isLoading = false;
      notifyListeners();
    } catch (exception) {
      print(exception);
      _isLoading = false;
    }
  }
}
