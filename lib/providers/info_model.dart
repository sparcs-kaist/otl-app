import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/extensions/cookies.dart';
import 'package:timeplanner_mobile/models/semester.dart';
import 'package:timeplanner_mobile/models/user.dart';

enum InfoState {
  progress,
  error,
  done,
}

class InfoModel extends ChangeNotifier {
  List<Semester> _semesters;
  List<Semester> get semesters => _semesters;

  User _user;
  User get user => _user;

  InfoState _state = InfoState.progress;
  InfoState get state => _state;

  final _dio = Dio();

  InfoModel({List<Cookie> cookies}) {
    cookies?.pushToDio(_dio);
  }

  Future<void> updateInfo({List<Cookie> cookies}) async {
    try {
      cookies?.pushToDio(_dio);

      _semesters = await getSemesters();
      _user = await getUser();
      _state = InfoState.done;
    } catch (exception) {
      print(exception);
      _state = InfoState.error;
    }

    notifyListeners();
  }

  Future<List<Semester>> getSemesters() async {
    final response = await _dio.get(API_SEMESTER_URL);
    final rawSemesters = response.data as List;

    return rawSemesters.map((semester) => Semester.fromJson(semester)).toList();
  }

  Future<User> getUser() async {
    final response = await _dio.get(SESSION_INFO_URL);

    return User.fromJson(response.data);
  }
}
