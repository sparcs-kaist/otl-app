import 'package:timeplanner_mobile/models/department.dart';
import 'package:timeplanner_mobile/models/professor.dart';

class Course {
  double load;
  double grade;
  String titleEn;
  List<Professor> professors;
  bool hasReview;
  Department department;
  int id;
  String professorsStr;
  String title;
  String speechLetter;
  String typeEn;
  bool userspecificIsRead;
  String summary;
  String professorsStrEn;
  double speech;
  String oldCode;
  String loadLetter;
  String gradeLetter;
  String type;
  int reviewNum;

  Course(
      {this.load,
      this.grade,
      this.titleEn,
      this.professors,
      this.hasReview,
      this.department,
      this.id,
      this.professorsStr,
      this.title,
      this.speechLetter,
      this.typeEn,
      this.userspecificIsRead,
      this.summary,
      this.professorsStrEn,
      this.speech,
      this.oldCode,
      this.loadLetter,
      this.gradeLetter,
      this.type,
      this.reviewNum});

  bool operator ==(Object other) =>
      identical(this, other) || (other is Course && other.id == id);

  int get hashCode => id.hashCode;

  Course.fromJson(Map<String, dynamic> json) {
    load = json['load']?.toDouble();
    grade = json['grade']?.toDouble();
    titleEn = json['title_en'];
    if (json['professors'] != null) {
      professors = List<Professor>();
      json['professors'].forEach((v) {
        professors.add(Professor.fromJson(v));
      });
    }
    hasReview = json['has_review'];
    department = json['department'] != null
        ? Department.fromJson(json['department'])
        : null;
    id = json['id'];
    professorsStr = json['professors_str'];
    title = json['title'];
    speechLetter = json['speech_letter'];
    typeEn = json['type_en'];
    userspecificIsRead = json['userspecific_is_read'];
    summary = json['summary'];
    professorsStrEn = json['professors_str_en'];
    speech = json['speech']?.toDouble();
    oldCode = json['old_code'];
    loadLetter = json['load_letter'];
    gradeLetter = json['grade_letter'];
    type = json['type'];
    reviewNum = json['review_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['load'] = this.load;
    data['grade'] = this.grade;
    data['title_en'] = this.titleEn;
    if (this.professors != null) {
      data['professors'] = this.professors.map((v) => v.toJson()).toList();
    }
    data['has_review'] = this.hasReview;
    if (this.department != null) {
      data['department'] = this.department.toJson();
    }
    data['id'] = this.id;
    data['professors_str'] = this.professorsStr;
    data['title'] = this.title;
    data['speech_letter'] = this.speechLetter;
    data['type_en'] = this.typeEn;
    data['userspecific_is_read'] = this.userspecificIsRead;
    data['summary'] = this.summary;
    data['professors_str_en'] = this.professorsStrEn;
    data['speech'] = this.speech;
    data['old_code'] = this.oldCode;
    data['load_letter'] = this.loadLetter;
    data['grade_letter'] = this.gradeLetter;
    data['type'] = this.type;
    data['review_num'] = this.reviewNum;
    return data;
  }
}
