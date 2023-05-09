import 'package:flutter/material.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/models/review.dart';

class HallOfFameModel extends ChangeNotifier {
  int _page = 0;
  int get page => _page;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Review> _hallOfFames = <Review>[];
  List<Review> hallOfFames(int year, int semester) {
    if (_hallOfFames.length == 0 && !_isLoading)
      loadHallOfFames(year, semester);
    return _hallOfFames;
  }

  Future<void> clear(int year, int semester) async {
    _hallOfFames.clear();
    _page = 0;
    await loadHallOfFames(year, semester);
  }

  Future<void> loadHallOfFames(int year, int semester) async {
    _isLoading = true;

    try {
      final response =
          await DioProvider().dio.get(API_REVIEW_URL, queryParameters: {
        "lecture_year": year,
        "lecture_semester": semester,
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
