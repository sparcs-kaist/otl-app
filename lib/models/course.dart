import 'package:otlplus/models/department.dart';
import 'package:otlplus/models/professor.dart';

class Course {
  int id;
  String oldCode;
  Department department;
  String type;
  String typeEn;
  String title;
  String titleEn;
  String summary;
  int reviewNum;
  List<Professor> professors;
  double grade;
  double load;
  double speech;
  bool userspecificIsRead;

  Course(
      {this.id,
      this.oldCode,
      this.department,
      this.type,
      this.typeEn,
      this.title,
      this.titleEn,
      this.summary,
      this.reviewNum,
      this.professors,
      this.grade,
      this.load,
      this.speech,
      this.userspecificIsRead});

  bool operator ==(Object other) =>
      identical(this, other) || (other is Course && other.id == id);

  int get hashCode => id.hashCode;

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    oldCode = json['old_code'];
    department = json['department'] != null
        ? Department.fromJson(json['department'])
        : null;
    type = json['type'];
    typeEn = json['type_en'];
    title = json['title'];
    titleEn = json['title_en'];
    summary = json['summary'];
    reviewNum = json['review_num'];
    if (json['professors'] != null) {
      professors = [];
      json['professors'].forEach((v) {
        professors.add(Professor.fromJson(v));
      });
    }
    grade = json['grade']?.toDouble();
    load = json['load']?.toDouble();
    speech = json['speech']?.toDouble();
    userspecificIsRead = json['userspecific_is_read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['old_code'] = this.oldCode;
    if (this.department != null) {
      data['department'] = this.department.toJson();
    }
    data['type'] = this.type;
    data['type_en'] = this.typeEn;
    data['title'] = this.title;
    data['title_en'] = this.titleEn;
    data['summary'] = this.summary;
    data['review_num'] = this.reviewNum;
    if (this.professors != null) {
      data['professors'] = this.professors.map((v) => v.toJson()).toList();
    }
    data['grade'] = this.grade;
    data['load'] = this.load;
    data['speech'] = this.speech;
    data['userspecific_is_read'] = this.userspecificIsRead;
    return data;
  }
}
