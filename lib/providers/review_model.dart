import 'package:flutter/material.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/models/review.dart';

class ReviewModel extends ChangeNotifier {
  int _page = 0;
  int get page => _page;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Review> _reviews = <Review>[];
  List<Review> get reviews {
    if (_reviews.length == 0 && !_isLoading) loadReviews();
    return _reviews;
  }

  Future<void> clear() async {
    _reviews.clear();
    _page = 0;
    await loadReviews();
  }

  Future<void> loadReviews() async {
    _isLoading = true;

    try {
      final response =
          await DioProvider().dio.get(API_REVIEW_URL, queryParameters: {
        "order": "-written_datetime",
        "offset": _page * 10,
        "limit": 10,
      });
      final rawReviews = response.data as List;
      _reviews.addAll(rawReviews.map((review) => Review.fromJson(review)));
      _page++;
      _isLoading = false;
      notifyListeners();
    } catch (exception) {
      print(exception);
      _isLoading = false;
    }
  }
}
