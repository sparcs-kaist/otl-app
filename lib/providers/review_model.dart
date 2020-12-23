import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/dio_provider.dart';
import 'package:timeplanner_mobile/models/review.dart';

enum ReviewState {
  progress,
  error,
  done,
}

class ReviewModel extends ChangeNotifier {
  ReviewState _state = ReviewState.done;
  ReviewState get state => _state;

  int _page = 0;
  int get page => _page;

  List<Review> _reviews = <Review>[];
  List<Review> get reviews {
    if (_reviews.length == 0 && _state != ReviewState.progress) loadReviews();
    return _reviews;
  }

  Future<void> clear() async {
    _reviews.clear();
    _page = 0;
    await loadReviews();
  }

  Future<void> loadReviews() async {
    _state = ReviewState.progress;

    try {
      final response =
          await DioProvider().dio.get(API_REVIEW_LATEST_URL + _page.toString());

      final rawReviews = response.data as List;
      _reviews.addAll(rawReviews.map((review) => Review.fromJson(review)));
      _page++;
      _state = ReviewState.done;
    } catch (exception) {
      _state = ReviewState.error;
    }
    notifyListeners();
  }
}
