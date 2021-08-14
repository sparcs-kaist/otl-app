import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/models/professor.dart';

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

extension LectureExtension on Lecture {
  String get gradeLetter => (reviewNum == 0) ? "?" : scores[grade.round()];
  String get loadLetter => (reviewNum == 0) ? "?" : scores[load.round()];
  String get speechLetter => (reviewNum == 0) ? "?" : scores[speech.round()];
  String get professorsStrShort {
    final professors = List<Professor>.from(this.professors)
      ..sort((a, b) => a.name.compareTo(b.name));
    final professorNames = professors.map((professor) => professor.name);
    if (professorNames.length <= 2) return professorNames.join(', ');
    return "${professorNames.first} 외 ${professorNames.length - 1}명";
  }
}
