import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/extensions/cookies.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/models/semester.dart';
import 'package:timeplanner_mobile/models/timetable.dart';

enum TimetableState {
  progress,
  error,
  done,
}

class TimetableModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  Semester _selectedSemester;
  Semester get selectedSemester => _selectedSemester;

  List<Timetable> _timetables;
  List<Timetable> get timetables => _timetables;

  Timetable get currentTimetable => _timetables[_selectedIndex];

  TimetableState _state = TimetableState.progress;
  TimetableState get state => _state;

  final _dio = Dio();

  TimetableModel({List<Cookie> cookies}) {
    cookies?.pushToDio(_dio);
  }

  void updateCookies(List<Cookie> cookies) {
    cookies.pushToDio(_dio);
  }

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> loadTimetable({Semester semester}) async {
    try {
      if (semester != null) _selectedSemester = semester;

      final response = await _dio.post(API_TIMETABLE_LOAD_URL, data: {
        "year": _selectedSemester.year,
        "semester": _selectedSemester.semester
      });

      final rawTimetables = response.data as List;

      _timetables = rawTimetables
          .map((timetable) => Timetable.fromJson(timetable))
          .toList();
      _selectedIndex = 0;
      _state = TimetableState.done;
    } catch (exception) {
      print(exception);
      _state = TimetableState.error;
    }

    notifyListeners();
  }

  Future<void> createTimetable(
      {Semester semester, List<Lecture> lectures}) async {
    try {
      if (semester != null) _selectedSemester = semester;

      final response = await _dio.post(API_TIMETABLE_CREATE_URL, data: {
        "year": _selectedSemester.year,
        "semester": _selectedSemester.semester,
        "lectures": lectures == null
            ? []
            : lectures.map((lecture) => lecture.id).toList(),
      });

      if (response.data["scucess"]) {
        _timetables.add(Timetable(
          id: response.data["id"],
          lectures: lectures ?? [],
        ));
        _selectedIndex = _timetables.length - 1;
        notifyListeners();
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> deleteTimetable({Timetable timetable, Semester semester}) async {
    try {
      if (semester != null) _selectedSemester = semester;

      final response = await _dio.post(API_TIMETABLE_DELETE_URL, data: {
        "table_id": (timetable ?? currentTimetable).id,
        "year": _selectedSemester.year,
        "semester": _selectedSemester.semester,
      });

      if (response.data["scucess"]) {
        _timetables.remove(timetable ?? currentTimetable);
        _selectedIndex--;
        notifyListeners();
      }
    } catch (exception) {
      print(exception);
    }
  }
}
