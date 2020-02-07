import 'package:timeplanner_mobile/models/classtimes.dart';
import 'package:timeplanner_mobile/models/examtimes.dart';
import 'package:timeplanner_mobile/models/professors.dart';

class ReviewWritableLectures {
  double load;
  String code;
  double grade;
  List<Professors> professors;
  int creditAu;
  int semester;
  bool isEnglish;
  String room;
  String classTitleEn;
  int year;
  List<Classtimes> classtimes;
  int limit;
  String classroomShort;
  String professorsStrShortEn;
  String commonTitle;
  String classNo;
  String title;
  String speechLetter;
  String oldCode;
  int id;
  double speech;
  int department;
  String classroomEn;
  String type;
  List<Examtimes> examtimes;
  String building;
  String exam;
  String classTitle;
  String titleEn;
  String gradeLetter;
  int course;
  String departmentCode;
  String professorsStrShort;
  String loadLetter;
  String classroom;
  String classroomShortEn;
  bool hasReview;
  String departmentName;
  int credit;
  String departmentNameEn;
  String typeEn;
  String examEn;
  int numPeople;
  String commonTitleEn;

  ReviewWritableLectures(
      {this.load,
      this.code,
      this.grade,
      this.professors,
      this.creditAu,
      this.semester,
      this.isEnglish,
      this.room,
      this.classTitleEn,
      this.year,
      this.classtimes,
      this.limit,
      this.classroomShort,
      this.professorsStrShortEn,
      this.commonTitle,
      this.classNo,
      this.title,
      this.speechLetter,
      this.oldCode,
      this.id,
      this.speech,
      this.department,
      this.classroomEn,
      this.type,
      this.examtimes,
      this.building,
      this.exam,
      this.classTitle,
      this.titleEn,
      this.gradeLetter,
      this.course,
      this.departmentCode,
      this.professorsStrShort,
      this.loadLetter,
      this.classroom,
      this.classroomShortEn,
      this.hasReview,
      this.departmentName,
      this.credit,
      this.departmentNameEn,
      this.typeEn,
      this.examEn,
      this.numPeople,
      this.commonTitleEn});

  ReviewWritableLectures.fromJson(Map<String, dynamic> json) {
    load = json['load'].toDouble();
    code = json['code'];
    grade = json['grade'].toDouble();
    if (json['professors'] != null) {
      professors = List<Professors>();
      json['professors'].forEach((v) {
        professors.add(Professors.fromJson(v));
      });
    }
    creditAu = json['credit_au'];
    semester = json['semester'];
    isEnglish = json['is_english'];
    room = json['room'];
    classTitleEn = json['class_title_en'];
    year = json['year'];
    if (json['classtimes'] != null) {
      classtimes = List<Classtimes>();
      json['classtimes'].forEach((v) {
        classtimes.add(Classtimes.fromJson(v));
      });
    }
    limit = json['limit'];
    classroomShort = json['classroom_short'];
    professorsStrShortEn = json['professors_str_short_en'];
    commonTitle = json['common_title'];
    classNo = json['class_no'];
    title = json['title'];
    speechLetter = json['speech_letter'];
    oldCode = json['old_code'];
    id = json['id'];
    speech = json['speech'].toDouble();
    department = json['department'];
    classroomEn = json['classroom_en'];
    type = json['type'];
    if (json['examtimes'] != null) {
      examtimes = List<Examtimes>();
      json['examtimes'].forEach((v) {
        examtimes.add(Examtimes.fromJson(v));
      });
    }
    building = json['building'];
    exam = json['exam'];
    classTitle = json['class_title'];
    titleEn = json['title_en'];
    gradeLetter = json['grade_letter'];
    course = json['course'];
    departmentCode = json['department_code'];
    professorsStrShort = json['professors_str_short'];
    loadLetter = json['load_letter'];
    classroom = json['classroom'];
    classroomShortEn = json['classroom_short_en'];
    hasReview = json['has_review'];
    departmentName = json['department_name'];
    credit = json['credit'];
    departmentNameEn = json['department_name_en'];
    typeEn = json['type_en'];
    examEn = json['exam_en'];
    numPeople = json['num_people'];
    commonTitleEn = json['common_title_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['load'] = this.load;
    data['code'] = this.code;
    data['grade'] = this.grade;
    if (this.professors != null) {
      data['professors'] = this.professors.map((v) => v.toJson()).toList();
    }
    data['credit_au'] = this.creditAu;
    data['semester'] = this.semester;
    data['is_english'] = this.isEnglish;
    data['room'] = this.room;
    data['class_title_en'] = this.classTitleEn;
    data['year'] = this.year;
    if (this.classtimes != null) {
      data['classtimes'] = this.classtimes.map((v) => v.toJson()).toList();
    }
    data['limit'] = this.limit;
    data['classroom_short'] = this.classroomShort;
    data['professors_str_short_en'] = this.professorsStrShortEn;
    data['common_title'] = this.commonTitle;
    data['class_no'] = this.classNo;
    data['title'] = this.title;
    data['speech_letter'] = this.speechLetter;
    data['old_code'] = this.oldCode;
    data['id'] = this.id;
    data['speech'] = this.speech;
    data['department'] = this.department;
    data['classroom_en'] = this.classroomEn;
    data['type'] = this.type;
    if (this.examtimes != null) {
      data['examtimes'] = this.examtimes.map((v) => v.toJson()).toList();
    }
    data['building'] = this.building;
    data['exam'] = this.exam;
    data['class_title'] = this.classTitle;
    data['title_en'] = this.titleEn;
    data['grade_letter'] = this.gradeLetter;
    data['course'] = this.course;
    data['department_code'] = this.departmentCode;
    data['professors_str_short'] = this.professorsStrShort;
    data['load_letter'] = this.loadLetter;
    data['classroom'] = this.classroom;
    data['classroom_short_en'] = this.classroomShortEn;
    data['has_review'] = this.hasReview;
    data['department_name'] = this.departmentName;
    data['credit'] = this.credit;
    data['department_name_en'] = this.departmentNameEn;
    data['type_en'] = this.typeEn;
    data['exam_en'] = this.examEn;
    data['num_people'] = this.numPeople;
    data['common_title_en'] = this.commonTitleEn;
    return data;
  }
}
