import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/dio_provider.dart';
import 'package:timeplanner_mobile/extensions/semester.dart';
import 'package:timeplanner_mobile/models/semester.dart';
import 'package:timeplanner_mobile/models/user.dart';

const USED_SCHEDULE_FIELDS = [
  "beginning",
  "end",
  "courseRegistrationPeriodStart",
  "courseRegistrationPeriodEnd",
  "courseAddDropPeriodEnd",
  "courseDropDeadline",
  "courseEvaluationDeadline",
  "gradePosting",
];

const SCHEDULE_NAME = {
  "beginning": "개강",
  "end": "종강",
  "courseRegistrationPeriodStart": "수강신청기간 시작",
  "courseRegistrationPeriodEnd": "수강신청기간 종료",
  "courseAddDropPeriodEnd": "수강변경기간 종료",
  "courseDropDeadline": "수강취소 마감",
  "courseEvaluationDeadline": "강의평가 마감",
  "gradePosting": "성적게시"
};

class InfoModel extends ChangeNotifier {
  Set<int> _years;
  Set<int> get years => _years;

  List<Semester> _semesters;
  List<Semester> get semesters => _semesters;

  User _user;
  User get user => _user;

  Map<String, dynamic> _currentSchedule;
  Map<String, dynamic> get currentSchedule => _currentSchedule;

  bool _hasData = false;
  bool get hasData => _hasData;

  Future<void> getInfo() async {
    try {
      _semesters = await getSemesters();
      _years = _semesters.map((semester) => semester.year).toSet();
      _user = await getUser();
      _currentSchedule = getCurrentSchedule();
      _hasData = true;
      notifyListeners();
    } catch (exception) {
      print(exception);
    }
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

  Map<String, dynamic> getCurrentSchedule() {
    final now = DateTime.now();
    final schedules = _semesters
        .map((semester) => USED_SCHEDULE_FIELDS.map((field) {
              final time = semester.toJson()[field];
              if (time == null) return null;
              return <String, dynamic>{
                "title": semester.title,
                "name": SCHEDULE_NAME[field],
                "time": time,
              };
            }))
        .fold<Iterable<Map<String, dynamic>>>(
            <Map<String, dynamic>>[], (acc, val) => [...acc, ...val])
        .where((e) => e != null)
        .toList();
    schedules.sort((a, b) => a["time"].compareTo(b["time"]));
    return schedules.firstWhere((e) => e["time"].isAfter(now),
        orElse: () => null);
  }
}
