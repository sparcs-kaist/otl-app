import 'package:dio/dio.dart';
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

  ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  Semester? _semester;
  Semester? get semeseter => _semester;
  void setSemester(Semester? semester) {
    _semester = semester;

    // 1. Animate Immediately But Error Prone
    // _scrollController.animateTo(
    //   0,
    //   duration: Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
  }

  int _selectedMode = 0;
  int get selectedMode => _selectedMode;
  void setMode(int mode) {
    _selectedMode = mode;
    notifyListeners();
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  List<Review> _hallOfFames = <Review>[];
  List<Review> hallOfFames() {
    if (_hallOfFames.length == 0 && !_isLoading) loadHallOfFames();
    return _hallOfFames;
  }

  Future<void> clear() async {
    _hallOfFames.clear();
    _page = 0;
    await loadHallOfFames();

    // 2. Animate Slowly But Safe
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> loadHallOfFames() async {
    _isLoading = true;

    try {
      Response response;
      if (_semester == null) {
        response =
            await DioProvider().dio.get(API_REVIEW_URL, queryParameters: {
          "order": "-like",
          "offset": _page * 10,
          "limit": 10,
        });
      } else {
        response =
            await DioProvider().dio.get(API_REVIEW_URL, queryParameters: {
          "lecture_year": _semester?.year,
          "lecture_semester": _semester?.semester,
          "order": "-like",
          "offset": _page * 10,
          "limit": 10,
        });
      }
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
