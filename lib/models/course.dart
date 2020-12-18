import 'package:timeplanner_mobile/models/department.dart';

class Course {
  String title;
  String typeEn;
  String titleEn;
  String summary;
  String oldCode;
  Department department;
  String type;
  int id;
  int reviewNum;

  Course(
      {this.title,
      this.typeEn,
      this.titleEn,
      this.summary,
      this.oldCode,
      this.department,
      this.type,
      this.id,
      this.reviewNum});

  Course.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    typeEn = json['type_en'];
    titleEn = json['title_en'];
    summary = json['summary'];
    oldCode = json['old_code'];
    department = json['department'] != null
        ? Department.fromJson(json['department'])
        : null;
    type = json['type'];
    id = json['id'];
    reviewNum = json['review_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['type_en'] = this.typeEn;
    data['title_en'] = this.titleEn;
    data['summary'] = this.summary;
    data['old_code'] = this.oldCode;
    if (this.department != null) {
      data['department'] = this.department.toJson();
    }
    data['type'] = this.type;
    data['id'] = this.id;
    data['review_num'] = this.reviewNum;
    return data;
  }
}
