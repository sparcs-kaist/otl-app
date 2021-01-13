import 'package:timeplanner_mobile/models/classtime.dart';
import 'package:timeplanner_mobile/models/examtime.dart';
import 'package:timeplanner_mobile/models/professor.dart';

class Lecture {
  int id;
  String title;
  String titleEn;
  int course;
  String oldCode;
  String classNo;
  int year;
  int semester;
  String code;
  int department;
  String departmentCode;
  String departmentName;
  String departmentNameEn;
  String type;
  String typeEn;
  int limit;
  int numPeople;
  bool isEnglish;
  int credit;
  int creditAu;
  String commonTitle;
  String commonTitleEn;
  String classTitle;
  String classTitleEn;
  int reviewNum;
  List<Professor> professors;
  double grade;
  double load;
  double speech;
  List<Classtime> classtimes;
  List<Examtime> examtimes;

  Lecture(
      {this.id,
      this.title,
      this.titleEn,
      this.course,
      this.oldCode,
      this.classNo,
      this.year,
      this.semester,
      this.code,
      this.department,
      this.departmentCode,
      this.departmentName,
      this.departmentNameEn,
      this.type,
      this.typeEn,
      this.limit,
      this.numPeople,
      this.isEnglish,
      this.credit,
      this.creditAu,
      this.commonTitle,
      this.commonTitleEn,
      this.classTitle,
      this.classTitleEn,
      this.reviewNum,
      this.professors,
      this.grade,
      this.load,
      this.speech,
      this.classtimes,
      this.examtimes});

  bool operator ==(Object other) =>
      identical(this, other) || (other is Lecture && other.id == id);

  int get hashCode => id.hashCode;

  Lecture.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    titleEn = json['title_en'];
    course = json['course'];
    oldCode = json['old_code'];
    classNo = json['class_no'];
    year = json['year'];
    semester = json['semester'];
    code = json['code'];
    department = json['department'];
    departmentCode = json['department_code'];
    departmentName = json['department_name'];
    departmentNameEn = json['department_name_en'];
    type = json['type'];
    typeEn = json['type_en'];
    limit = json['limit'];
    numPeople = json['num_people'];
    isEnglish = json['is_english'];
    credit = json['credit'];
    creditAu = json['credit_au'];
    commonTitle = json['common_title'];
    commonTitleEn = json['common_title_en'];
    classTitle = json['class_title'];
    classTitleEn = json['class_title_en'];
    reviewNum = json['review_num'];
    if (json['professors'] != null) {
      professors = List<Professor>();
      json['professors'].forEach((v) {
        professors.add(Professor.fromJson(v));
      });
    }
    grade = json['grade']?.toDouble();
    load = json['load']?.toDouble();
    speech = json['speech']?.toDouble();
    if (json['classtimes'] != null) {
      classtimes = List<Classtime>();
      json['classtimes'].forEach((v) {
        classtimes.add(Classtime.fromJson(v));
      });
    }
    if (json['examtimes'] != null) {
      examtimes = List<Examtime>();
      json['examtimes'].forEach((v) {
        examtimes.add(Examtime.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['title_en'] = this.titleEn;
    data['course'] = this.course;
    data['old_code'] = this.oldCode;
    data['class_no'] = this.classNo;
    data['year'] = this.year;
    data['semester'] = this.semester;
    data['code'] = this.code;
    data['department'] = this.department;
    data['department_code'] = this.departmentCode;
    data['department_name'] = this.departmentName;
    data['department_name_en'] = this.departmentNameEn;
    data['type'] = this.type;
    data['type_en'] = this.typeEn;
    data['limit'] = this.limit;
    data['num_people'] = this.numPeople;
    data['is_english'] = this.isEnglish;
    data['credit'] = this.credit;
    data['credit_au'] = this.creditAu;
    data['common_title'] = this.commonTitle;
    data['common_title_en'] = this.commonTitleEn;
    data['class_title'] = this.classTitle;
    data['class_title_en'] = this.classTitleEn;
    data['review_num'] = this.reviewNum;
    if (this.professors != null) {
      data['professors'] = this.professors.map((v) => v.toJson()).toList();
    }
    data['grade'] = this.grade;
    data['load'] = this.load;
    data['speech'] = this.speech;
    if (this.classtimes != null) {
      data['classtimes'] = this.classtimes.map((v) => v.toJson()).toList();
    }
    if (this.examtimes != null) {
      data['examtimes'] = this.examtimes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
