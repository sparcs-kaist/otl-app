import 'package:timeplanner_mobile/models/semester.dart';

final semesterNames = ["봄", "여름", "가을", "겨울"];

extension SemesterParsing on Semester {
  String get title => "$year ${semesterNames[semester - 1]}";
}
