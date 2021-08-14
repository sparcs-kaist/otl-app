import 'package:otlplus/models/semester.dart';

final semesterNames = ["봄", "여름", "가을", "겨울"];

extension SemesterExtension on Semester {
  String get title => "$year ${semesterNames[semester - 1]}";
}
