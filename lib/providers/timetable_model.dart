import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:timeplanner_mobile/extensions/cookies.dart';
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

  Dio _dio = Dio();

  TimetableModel({List<Cookie> cookies}) {
    cookies?.insertToDio(_dio);
  }

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> getTimetable({Semester semester, List<Cookie> cookies}) async {
    try {
      if (semester != null) _selectedSemester = semester;
      cookies?.insertToDio(_dio);

      final response = await _dio
          .post("https://otl.kaist.ac.kr/api/timetable/table_load", data: {
        "year": _selectedSemester.year,
        "semester": _selectedSemester.semester
      });

      final rawTimetables = response.data as List;

      _timetables = rawTimetables
          .map((timetable) => Timetable.fromJson(timetable))
          .toList();
      _state = TimetableState.done;
    } catch (exception) {
      print(exception);
      _state = TimetableState.error;
    }

    notifyListeners();
  }
}
