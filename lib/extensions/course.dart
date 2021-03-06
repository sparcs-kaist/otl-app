import 'package:timeplanner_mobile/models/course.dart';
import 'package:timeplanner_mobile/models/professor.dart';

final scores = [
  "?",
  "F",
  "F",
  "F",
  "D-",
  "D",
  "D+",
  "C-",
  "C",
  "C+",
  "B-",
  "B",
  "B+",
  "A-",
  "A",
  "A+",
];

extension CourseExtension on Course {
  String get gradeLetter => (reviewNum == 0) ? "?" : scores[grade.round()];
  String get loadLetter => (reviewNum == 0) ? "?" : scores[load.round()];
  String get speechLetter => (reviewNum == 0) ? "?" : scores[speech.round()];
  String get professorsStr {
    final professors = List<Professor>.from(this.professors)
      ..sort((a, b) => a.name.compareTo(b.name));
    return professors.map((professor) => professor.name).join(", ");
  }
}
