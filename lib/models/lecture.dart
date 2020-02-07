import 'package:timeplanner_mobile/models/professors.dart';

class Lecture {
  String code;
  List<Professors> professors;
  int creditAu;
  int semester;
  bool isEnglish;
  String classTitleEn;
  int year;
  int limit;
  int id;
  String professorsStrShortEn;
  String commonTitle;
  String classNo;
  String title;
  String oldCode;
  int department;
  String departmentCode;
  String type;
  String classTitle;
  String titleEn;
  int numPeople;
  String professorsStrShort;
  int course;
  String departmentName;
  int credit;
  String departmentNameEn;
  String typeEn;
  String commonTitleEn;

  Lecture(
      {this.code,
      this.professors,
      this.creditAu,
      this.semester,
      this.isEnglish,
      this.classTitleEn,
      this.year,
      this.limit,
      this.id,
      this.professorsStrShortEn,
      this.commonTitle,
      this.classNo,
      this.title,
      this.oldCode,
      this.department,
      this.departmentCode,
      this.type,
      this.classTitle,
      this.titleEn,
      this.numPeople,
      this.professorsStrShort,
      this.course,
      this.departmentName,
      this.credit,
      this.departmentNameEn,
      this.typeEn,
      this.commonTitleEn});

  Lecture.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['professors'] != null) {
      professors = List<Professors>();
      json['professors'].forEach((v) {
        professors.add(Professors.fromJson(v));
      });
    }
    creditAu = json['credit_au'];
    semester = json['semester'];
    isEnglish = json['is_english'];
    classTitleEn = json['class_title_en'];
    year = json['year'];
    limit = json['limit'];
    id = json['id'];
    professorsStrShortEn = json['professors_str_short_en'];
    commonTitle = json['common_title'];
    classNo = json['class_no'];
    title = json['title'];
    oldCode = json['old_code'];
    department = json['department'];
    departmentCode = json['department_code'];
    type = json['type'];
    classTitle = json['class_title'];
    titleEn = json['title_en'];
    numPeople = json['num_people'];
    professorsStrShort = json['professors_str_short'];
    course = json['course'];
    departmentName = json['department_name'];
    credit = json['credit'];
    departmentNameEn = json['department_name_en'];
    typeEn = json['type_en'];
    commonTitleEn = json['common_title_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    if (this.professors != null) {
      data['professors'] = this.professors.map((v) => v.toJson()).toList();
    }
    data['credit_au'] = this.creditAu;
    data['semester'] = this.semester;
    data['is_english'] = this.isEnglish;
    data['class_title_en'] = this.classTitleEn;
    data['year'] = this.year;
    data['limit'] = this.limit;
    data['id'] = this.id;
    data['professors_str_short_en'] = this.professorsStrShortEn;
    data['common_title'] = this.commonTitle;
    data['class_no'] = this.classNo;
    data['title'] = this.title;
    data['old_code'] = this.oldCode;
    data['department'] = this.department;
    data['department_code'] = this.departmentCode;
    data['type'] = this.type;
    data['class_title'] = this.classTitle;
    data['title_en'] = this.titleEn;
    data['num_people'] = this.numPeople;
    data['professors_str_short'] = this.professorsStrShort;
    data['course'] = this.course;
    data['department_name'] = this.departmentName;
    data['credit'] = this.credit;
    data['department_name_en'] = this.departmentNameEn;
    data['type_en'] = this.typeEn;
    data['common_title_en'] = this.commonTitleEn;
    return data;
  }
}
