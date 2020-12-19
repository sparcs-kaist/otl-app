import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/dio_provider.dart';
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

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<bool> loadTimetable({Semester semester}) async {
    try {
      if (semester != null) _selectedSemester = semester;

      final response = await DioProvider().dio.post(API_TIMETABLE_LOAD_URL,
          data: {
            "year": _selectedSemester.year,
            "semester": _selectedSemester.semester
          });

      final rawTimetables = response.data as List;

      _timetables = rawTimetables
          .map((timetable) => Timetable.fromJson(timetable))
          .toList();
      _selectedIndex = 0;
      _state = TimetableState.done;
      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
      _state = TimetableState.error;
      notifyListeners();
    }
    return false;
  }

  Future<bool> createTimetable({List<Lecture> lectures}) async {
    try {
      final response =
          await DioProvider().dio.post(API_TIMETABLE_CREATE_URL, data: {
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
        return true;
      }
    } catch (exception) {
      print(exception);
    }
    return false;
  }

  Future<bool> updateTimetable(
      {@required Lecture lecture,
      bool delete = false,
      FutureOr<bool> Function(Iterable<Lecture>) onOverlap}) async {
    try {
      if (!delete) {
        final overlappedLectures = currentTimetable.lectures.where(
            (timetableLecture) => lecture.classtimes.any((thisClasstime) =>
                timetableLecture.classtimes.any((classtime) =>
                    (classtime.day == thisClasstime.day) &&
                    (classtime.begin < thisClasstime.end) &&
                    (classtime.end > thisClasstime.begin))));

        if (overlappedLectures.length > 0) {
          if (!await onOverlap(overlappedLectures)) return false;

          for (final lecture in overlappedLectures) {
            final response =
                await DioProvider().dio.post(API_TIMETABLE_UPDATE_URL, data: {
              "table_id": currentTimetable.id,
              "lecture_id": lecture.id,
              "delete": true,
            });

            if (!response.data["success"]) {
              notifyListeners();
              return false;
            }
            currentTimetable.lectures.remove(lecture);
          }
        }
      }

      final response =
          await DioProvider().dio.post(API_TIMETABLE_UPDATE_URL, data: {
        "table_id": currentTimetable.id,
        "lecture_id": lecture.id,
        "delete": delete,
      });

      if (response.data["success"]) {
        if (delete)
          currentTimetable.lectures.remove(lecture);
        else
          currentTimetable.lectures.add(lecture);
        notifyListeners();
        return true;
      }
    } catch (exception) {
      print(exception);
    }
    return false;
  }

  Future<bool> deleteTimetable() async {
    try {
      if (_timetables.length <= 1) return false;

      final response =
          await DioProvider().dio.post(API_TIMETABLE_DELETE_URL, data: {
        "table_id": currentTimetable.id,
        "year": _selectedSemester.year,
        "semester": _selectedSemester.semester,
      });

      if (response.data["scucess"]) {
        _timetables.remove(currentTimetable);
        if (_selectedIndex > 0) _selectedIndex--;
        notifyListeners();
        return true;
      }
    } catch (exception) {
      print(exception);
    }
    return false;
  }
}
