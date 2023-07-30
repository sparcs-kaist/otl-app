import 'package:easy_localization/easy_localization.dart';
import 'package:otlplus/models/semester.dart';

final semesterNames = ["spring", "summer", "fall", "winter"];

extension SemesterExtension on Semester {
  String get title => "$year ${'semester.${semesterNames[semester - 1]}'.tr()}";
}
