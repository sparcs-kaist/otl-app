import 'package:flutter/material.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/extensions/semester.dart';
import 'package:otlplus/models/semester.dart';
import 'package:otlplus/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

const SCHEDULE_NAME_EN = {
  "beginning": "Beginning",
  "end": "End",
  "courseRegistrationPeriodStart": "Start of Course Registration Period",
  "courseRegistrationPeriodEnd": "End of Course Registration Period",
  "courseAddDropPeriodEnd": "End of Course Add & Drop Period",
  "courseDropDeadline": "Deadline to Course Drop",
  "courseEvaluationDeadline": "Deadline to Course Evaluation",
  "gradePosting": "Grade Posting",
};

class InfoModel extends ChangeNotifier {
  late Set<int> _years;
  Set<int> get years => _years;

  late List<Semester> _semesters;
  List<Semester> get semesters => _semesters;

  late User _user;
  User get user => _user;

  late Map<String, dynamic>? _currentSchedule;
  Map<String, dynamic>? get currentSchedule => _currentSchedule;

  bool _hasData = false;
  bool get hasData => _hasData;

  InfoModel({bool forTest = false}) {
    if (forTest) {
      _user = User(
          id: 0,
          email: "email",
          studentId: "studentId",
          firstName: "firstName",
          lastName: "lastName",
          majors: [],
          departments: [],
          myTimetableLectures: [],
          reviewWritableLectures: [],
          reviews: []);
      _semesters = [];
    }
  }

  void logout() {
    _hasData = false;
    notifyListeners();
  }

  Future<void> getInfo() async {
    if ((await SharedPreferences.getInstance()).getBool('hasAccount') ??
            true) {
      _semesters = await getSemesters();
      _years = _semesters.map((semester) => semester.year).toSet();
      _user = await getUser();
      _currentSchedule = getCurrentSchedule();
      _hasData = true;
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

  Map<String, dynamic>? getCurrentSchedule() {
    final now = DateTime.now();
    final schedules = _semesters
        .map((semester) => USED_SCHEDULE_FIELDS.map((field) {
              final time = semester.toJson()[field];
              if (time == null) return null;
              return <String, dynamic>{
                "title": semester.title,
                "name": SCHEDULE_NAME[field],
                "nameEn": SCHEDULE_NAME_EN[field],
                "time": time,
              };
            }))
        .expand((e) => e)
        .where((e) => e != null)
        .toList();
    schedules.sort((a, b) => a!["time"].compareTo(b!["time"]));
    return schedules.firstWhere((e) => e!["time"].isAfter(now),
        orElse: () => null);
  }

  Future<void> deleteAccount() async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool('hasAccount', false);
    _hasData = false;
    notifyListeners();
  }
}
