import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/models/department.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/models/planner.dart';
import 'package:otlplus/models/semester.dart';
import 'package:otlplus/models/user.dart';
import 'package:otlplus/utils/export_file.dart';

class PlannerModel extends ChangeNotifier {
  late User _user = User(
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
  User get user => _user;

  late List<Planner> _planners = [
    Planner(
      id: 0,
      start_year: 0,
      end_year: 0,
      arrange_order: 0,
      general_track: GeneralTrack(),
      major_track: MajorTrack(
          department: Department(id: 0, name: "", nameEn: "", code: "")),
      additional_tracks: [],
      taken_items: [],
      future_items: [],
      arbitrary_items: [],
    ),
  ];

  Planner myPlanner = Planner(
    id: 0,
    start_year: 0,
    end_year: 0,
    arrange_order: 0,
    general_track: GeneralTrack(),
    major_track: MajorTrack(
        department: Department(id: 0, name: "", nameEn: "", code: "")),
    additional_tracks: [],
    taken_items: [],
    future_items: [],
    arbitrary_items: [],
  );

  List<Planner> get planners => _planners;

  // late int _selectedSemesterIndex;
  // Semester get selectedSemester => _semesters[_selectedSemesterIndex];
  //
  // late List<Planner> _timetables;
  // List<Planner> get timetables => _timetables;
  //
  // Lecture? _tempLecture;
  // Lecture? get tempLecture => _tempLecture;

  // void setTempLecture(Lecture? lecture) {
  //   _tempLecture = lecture;
  //   notifyListeners();
  // }

  int _selectedPlannerIndex = 0;
  int get selectedIndex => _selectedPlannerIndex;

  String _selectedPlannerSemesterKey = "";
  String get selectedSemesterKey => _selectedPlannerSemesterKey;

  // Planner get currentTimetable => _timetables[_selectedTimetableIndex];
  //
  // int _selectedModeIndex = 0;
  // int get selectedMode => _selectedModeIndex;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Map _lectures = {};
  Map get lectures => _lectures;

  Map _lectures_excluded = {};
  Map get lectures_excluded => _lectures_excluded;

  Map _lectures_future = {};
  Map get lectures_future => _lectures_future;

  Map _lectures_future_excluded = {};
  Map get lectures_future_excluded => _lectures_future_excluded;

  int _taken_lectures = 0;
  int get taken_lectures => _taken_lectures;

  int _taken_au = 0;
  int get taken_au => _taken_au;

  Map _category_map = {
    "기초필수": 0,
    "기초선택": 0,
    "전공필수": 0,
    "전공선택": 0,
    "교양필수": 0,
    "인문사회선택": 0,
    "자유선택": 0,
    "졸업연구": 0,
    "개별연구": 0,
    "기타": 0, //논문연구, 선택(석/박사), 세미나
  };
  Map get category_map => _category_map;

  Map _category_map_required = {
    "기초필수": 0,
    "기초선택": 0,
    "전공필수": 0,
    "전공선택": 0,
    "교양필수": 0,
    "인문사회선택": 0,
    "자유선택": 0,
    "졸업연구": 0,
    "개별연구": 0,
    "기타": 0, //논문연구, 선택(석/박사), 세미나
  };
  Map get category_map_required => _category_map_required;

  PlannerModel({bool forTest = false}) {
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
      _planners = [
        Planner(
          id: 0,
          start_year: 0,
          end_year: 0,
          arrange_order: 0,
          general_track: GeneralTrack(),
          major_track: MajorTrack(
              department: Department(id: 0, name: "", nameEn: "", code: "")),
          additional_tracks: [],
          taken_items: [],
          future_items: [],
          arbitrary_items: [],
        ),
      ];
    }
  }

  void initializeLectures() {
    _lectures = {};
    _lectures_excluded = {};
    _lectures_future = {};
    _lectures_future_excluded = {};
    _taken_lectures = 0;
    _taken_au = 0;
    _selectedPlannerSemesterKey = "";
    _category_map = {
      "기초필수": 0,
      "기초선택": 0,
      "전공필수": 0,
      "전공선택": 0,
      "교양필수": 0,
      "인문사회선택": 0,
      "자유선택": 0,
      "졸업연구": 0,
      "개별연구": 0,
      "기타": 0, //논문연구, 선택(석/박사), 세미나
    };
    _category_map_required = {
      "기초필수": 0,
      "기초선택": 0,
      "전공필수": 0,
      "전공선택": 0,
      "교양필수": 0,
      "인문사회선택": 0,
      "자유선택": 0,
      "졸업연구": 0,
      "개별연구": 0,
      "기타": 0, //논문연구, 선택(석/박사), 세미나
    };
  }

  //
  void loadPlanner({required User user}) {
    _user = user;
    _selectedPlannerIndex = 0;

    notifyListeners();
    _loadPlanner();
    // setLectures();
    // notifyListeners();
  }

  void selectPlanner(int index) {
    _selectedPlannerIndex = index;
    setLectures();
    notifyListeners();
  }

  void setPLannerSemester(String index) {
    _selectedPlannerSemesterKey = index;
    notifyListeners();
  }

  void setLectures() {
    initializeLectures();

    _category_map_required["기초필수"] =
        _planners[_selectedPlannerIndex].general_track.basic_required;
    _category_map_required["기초선택"] =
        _planners[_selectedPlannerIndex].general_track.basic_elective;
    _category_map_required["졸업연구"] =
        _planners[_selectedPlannerIndex].general_track.thesis_study;
    _category_map_required["인문사회선택"] =
        _planners[_selectedPlannerIndex].general_track.humanities;
    _category_map_required["교양필수"] =
        _planners[_selectedPlannerIndex].general_track.general_required_credit +
            _planners[_selectedPlannerIndex]
                .general_track
                .general_required_au; //교양필수 7학점 + 8AU
    _category_map_required["전공필수"] =
        _planners[_selectedPlannerIndex].major_track.major_required;
    _category_map_required["전공선택"] =
        _planners[_selectedPlannerIndex].major_track.major_elective;

    for (int i = 0;
        i < _planners[_selectedPlannerIndex].additional_tracks.length;
        i++) {
      _category_map_required["전공필수"] +=
          _planners[_selectedPlannerIndex].additional_tracks[i].major_required;
      _category_map_required["전공선택"] +=
          _planners[_selectedPlannerIndex].additional_tracks[i].major_elective;
    }

    for (int i = 0;
        i < _planners[_selectedPlannerIndex].taken_items.length;
        i++) {
      if (!_planners[_selectedPlannerIndex].taken_items[i].is_excluded) {
        if (_category_map.containsKey(_planners[_selectedPlannerIndex]
            .taken_items[i]
            .course
            .type
            .split('(')[0])) {
          _category_map[_planners[_selectedPlannerIndex]
                  .taken_items[i]
                  .course
                  .type
                  .split('(')[0]] +=
              _planners[_selectedPlannerIndex].taken_items[i].course.credit;
        }

        _taken_lectures +=
            _planners[_selectedPlannerIndex].taken_items[i].course.credit;
        _taken_au +=
            _planners[_selectedPlannerIndex].taken_items[i].course.credit_au;

        String year_semester = _planners[_selectedPlannerIndex]
                .taken_items[i]
                .lecture
                .year
                .toString() +
            ' ' +
            _planners[_selectedPlannerIndex]
                .taken_items[i]
                .lecture
                .semester
                .toString();
        if (_lectures.containsKey(year_semester)) {
          _lectures[year_semester]
              .add(_planners[_selectedPlannerIndex].taken_items[i]);
        } else {
          _lectures[year_semester] = [
            _planners[_selectedPlannerIndex].taken_items[i]
          ];
        }
      } else {
        String year_semester = _planners[_selectedPlannerIndex]
                .taken_items[i]
                .lecture
                .year
                .toString() +
            ' ' +
            _planners[_selectedPlannerIndex]
                .taken_items[i]
                .lecture
                .semester
                .toString();

        if (_lectures_excluded.containsKey(year_semester)) {
          _lectures_excluded[year_semester]
              .add(_planners[_selectedPlannerIndex].taken_items[i]);
        } else {
          _lectures_excluded[year_semester] = [
            _planners[_selectedPlannerIndex].taken_items[i]
          ];
        }
      }
    }

    for (int i = 0;
        i < _planners[_selectedPlannerIndex].future_items.length;
        i++) {
      if (!_planners[_selectedPlannerIndex].future_items[i].is_excluded) {
        if (_category_map.containsKey(
            _planners[_selectedPlannerIndex].future_items[i].course.type)) {
          _category_map[_planners[_selectedPlannerIndex]
                  .future_items[i]
                  .course
                  .type] +=
              _planners[_selectedPlannerIndex].future_items[i].course.credit;
        }

        _taken_lectures +=
            _planners[_selectedPlannerIndex].future_items[i].course.credit;
        _taken_au +=
            _planners[_selectedPlannerIndex].future_items[i].course.credit_au;

        String year_semester =
            _planners[_selectedPlannerIndex].future_items[i].year.toString() +
                ' ' +
                _planners[_selectedPlannerIndex]
                    .future_items[i]
                    .semester
                    .toString();

        if (_lectures_future.containsKey(year_semester)) {
          _lectures_future[year_semester]
              .add(_planners[_selectedPlannerIndex].future_items[i]);
        } else {
          _lectures_future[year_semester] = [
            _planners[_selectedPlannerIndex].future_items[i]
          ];
        }
      } else {
        String year_semester =
            _planners[_selectedPlannerIndex].future_items[i].year.toString() +
                ' ' +
                _planners[_selectedPlannerIndex]
                    .future_items[i]
                    .semester
                    .toString();

        if (_lectures_future_excluded.containsKey(year_semester)) {
          _lectures_future_excluded[year_semester]
              .add(_planners[_selectedPlannerIndex].future_items[i]);
        } else {
          _lectures_future_excluded[year_semester] = [
            _planners[_selectedPlannerIndex].future_items[i]
          ];
        }
      }
    }
  }
  //
  // get canGoPreviousSemester => _selectedSemesterIndex > 0;

  // bool goPreviousSemester() {
  //   if (canGoPreviousSemester) {
  //     _selectedSemesterIndex--;
  //     notifyListeners();
  //     _loadPlanner();
  //     return true;
  //   }
  //   return false;
  // }
  //
  // get canGoNextSemester => _selectedSemesterIndex < _semesters.length - 1;

  // bool goNextSemester() {
  //   if (canGoNextSemester) {
  //     _selectedSemesterIndex++;
  //     notifyListeners();
  //     _loadPlanner();
  //     return true;
  //   }
  //   return false;
  // }
  //
  // void setIndex(int index) {
  //   _selectedTimetableIndex = index;
  //   notifyListeners();
  // }
  //
  // void setMode(int index) {
  //   _selectedModeIndex = index;
  //   notifyListeners();
  // }

  Future<bool> _loadPlanner() async {
    try {
      final response = await DioProvider().dio.get(
            API_PLANNER_URL.replaceFirst("{user_id}", _user.id.toString()),
          );

      List<dynamic> rawPlanners = response.data as List;

      if (rawPlanners.isEmpty) {
        _selectedPlannerIndex = 0;
        _planners = [myPlanner];
        // await createTimetable();
        await _loadPlanner();
        return true;
      }

      _planners =
          rawPlanners.map((planner) => Planner.fromJson(planner)).toList();

      _planners.insert(0, myPlanner);
      _selectedPlannerIndex = _planners.length >= 2 ? 1 : 0;
      _isLoaded = true;
      setLectures();
      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;
  }


  Future<bool> deletePlanner() async {
    try {
      if (_planners.length <= 2) return false;

      await DioProvider().dio.delete(
          API_PLANNER_URL.replaceFirst("{user_id}", user.id.toString()) +
              "/" +
              _planners[_selectedPlannerIndex].id.toString(),
          data: {});

      _planners.remove(_planners[_selectedPlannerIndex]);
      if (_selectedPlannerIndex > 1) _selectedPlannerIndex--;
      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;
  }



  int getPlannerStartYear(){
    int currentYear = DateTime.now().year;
    if(user.studentId == ""){
      return currentYear;
    }

    if ( user.studentId.length != 8 && user.studentId[4] == '0') {
      int userEntranceYear = int.parse(user.studentId.substring(0, 4));
      if (userEntranceYear >= 2000 && userEntranceYear <= currentYear) {
        return userEntranceYear;
      }
    }

    if (user.reviewWritableLectures.length > 0) {
      int firstTakenLectureYear = user.reviewWritableLectures.map((l) => l.year).toList().reduce(min);
      if (firstTakenLectureYear >= 2000 && firstTakenLectureYear <= currentYear) {
        return firstTakenLectureYear;
      }
    }

    return currentYear;
  }

  int createRandomPlannerID(){
    return (Random().nextDouble() * 100000000).floor();
  }

  Future<bool> createPlanner() async {
    try {
      final response = await DioProvider().dio.post(
          API_PLANNER_URL.replaceFirst("{user_id}", user.id.toString()),
          data: {
            "id": createRandomPlannerID(),
            "start_year": getPlannerStartYear(),
            "end_year": max(getPlannerStartYear() + 3,  DateTime.now().year),
            "general_track": {
              "id": 1,
              "start_year": 2023,
              "end_year": 2100,
              "is_foreign": false,
              "total_credit": 138,
              "total_au": 4,
              "basic_required": 23,
              "basic_elective": 9,
              "thesis_study": 3,
              "thesis_study_doublemajor": 0,
              "general_required_credit": 7,
              "general_required_au": 4,
              "humanities": 21,
              "humanities_doublemajor": 12
            },
            "major_track": {
              "id": 2,
              "start_year": 2016,
              "end_year": 2100,
              "department": user.departments[0].toJson(),
              "basic_elective_doublemajor": 6,
              "major_required": 21,
              "major_elective": 21
            },
            "additional_tracks": [],
            "taken_items": [],
            "future_items": [],
            "arbitrary_items": [],
            "arrange_order": _planners.length > 1 ? (_planners.map((t) => t.arrange_order).reduce(max)) + 1 : 0,
          });
      final planner = Planner.fromJson(response.data);
      print("werrrwe");
      _planners.add(planner);
      _selectedPlannerIndex = _planners.length - 1;
      notifyListeners();
      return true;
    } catch (exception) {
      print(exception);
    }
    return false;
  }

  // Future<bool> createTimetable({List<Lecture>? lectures}) async {
  //   try {
  //     final response = await DioProvider().dio.post(
  //         API_PLANNER_URL.replaceFirst("{user_id}", user.id.toString()),
  //         data: {
  //           "year": selectedSemester.year,
  //           "semester": selectedSemester.semester,
  //           "lectures": (lectures == null)
  //               ? []
  //               : lectures.map((lecture) => lecture.id).toList(),
  //         });
  //     final timetable = Planner.fromJson(response.data);
  //     _timetables.add(timetable);
  //     _selectedTimetableIndex = _timetables.length - 1;
  //     notifyListeners();
  //     return true;
  //   } catch (exception) {
  //     print(exception);
  //   }
  //   return false;
  // }
}
