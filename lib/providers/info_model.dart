import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/dio_provider.dart';
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

  Future<void> getInfo() async {
    try {
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
    final response = await DioProvider().dio.get(API_SEMESTER_URL);
    final rawSemesters = response.data as List;
    return rawSemesters.map((semester) => Semester.fromJson(semester)).toList();
  }

  Future<User> getUser() async {
    final response = await DioProvider().dio.get(SESSION_INFO_URL);
    return User.fromJson(response.data);
  }
}
