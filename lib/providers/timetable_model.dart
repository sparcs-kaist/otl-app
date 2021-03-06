import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/dio_provider.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/models/semester.dart';
import 'package:timeplanner_mobile/models/timetable.dart';
import 'package:timeplanner_mobile/models/user.dart';

class TimetableModel extends ChangeNotifier {
  User _user;
  User get user => _user;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  Semester _selectedSemester;
  Semester get selectedSemester => _selectedSemester;

  List<Timetable> _timetables;
  List<Timetable> get timetables => _timetables;

  Timetable get currentTimetable => _timetables[_selectedIndex];

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<bool> loadTimetable({User user, Semester semester}) async {
    try {
      if (user != null) _user = user;
      if (semester != null) _selectedSemester = semester;

      final response = await DioProvider().dio.get(
          API_TIMETABLE_URL.replaceFirst("{user_id}", _user.id.toString()),
          queryParameters: {
            "year": _selectedSemester.year,
            "semester": _selectedSemester.semester
          });

      final rawTimetables = response.data as List;

      _timetables = rawTimetables
          .map((timetable) => Timetable.fromJson(timetable))
          .toList();
      _selectedIndex = 0;
      _isLoaded = true;
      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;
  }

  Future<bool> createTimetable({List<Lecture> lectures}) async {
    try {
      final response = await DioProvider().dio.post(
          API_TIMETABLE_URL.replaceFirst("{user_id}", user.id.toString()),
          data: {
            "year": _selectedSemester.year,
            "semester": _selectedSemester.semester,
            "lectures": (lectures == null)
                ? []
                : lectures.map((lecture) => lecture.id).toList(),
          });
      final timetable = Timetable.fromJson(response.data);
      _timetables.add(timetable);
      _selectedIndex = _timetables.length - 1;
      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;
  }

  Future<bool> addLecture(
      {@required Lecture lecture,
      FutureOr<bool> Function(Iterable<Lecture>) onOverlap}) async {
    try {
      final overlappedLectures = currentTimetable.lectures.where(
          (timetableLecture) => lecture.classtimes.any((thisClasstime) =>
              timetableLecture.classtimes.any((classtime) =>
                  (classtime.day == thisClasstime.day) &&
                  (classtime.begin < thisClasstime.end) &&
                  (classtime.end > thisClasstime.begin))));

      if (overlappedLectures.length > 0) {
        if (!await onOverlap(overlappedLectures)) return false;

        for (final lecture in overlappedLectures) {
          await DioProvider().dio.post(
              API_TIMETABLE_REMOVE_LECTURE_URL
                  .replaceFirst("{user_id}", user.id.toString())
                  .replaceFirst(
                      "{timetable_id}", currentTimetable.id.toString()),
              data: {"lecture": lecture.id});
        }
        currentTimetable.lectures.removeWhere(overlappedLectures.contains);
      }

      final response = await DioProvider().dio.post(
          API_TIMETABLE_ADD_LECTURE_URL
              .replaceFirst("{user_id}", user.id.toString())
              .replaceFirst("{timetable_id}", currentTimetable.id.toString()),
          data: {"lecture": lecture.id});
      final timetable = Timetable.fromJson(response.data);
      _timetables[_selectedIndex] = timetable;
      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;
  }

  Future<bool> removeLecture({@required Lecture lecture}) async {
    try {
      final response = await DioProvider().dio.post(
          API_TIMETABLE_REMOVE_LECTURE_URL
              .replaceFirst("{user_id}", user.id.toString())
              .replaceFirst("{timetable_id}", currentTimetable.id.toString()),
          data: {"lecture": lecture.id});
      final timetable = Timetable.fromJson(response.data);
      _timetables[_selectedIndex] = timetable;
      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;
  }

  Future<bool> deleteTimetable() async {
    try {
      if (_timetables.length <= 1) return false;

      await DioProvider().dio.delete(
          API_TIMETABLE_URL.replaceFirst("{user_id}", user.id.toString()) +
              "/" +
              currentTimetable.id.toString(),
          data: {});

      _timetables.remove(currentTimetable);
      if (_selectedIndex > 0) _selectedIndex--;
      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;
  }
}
