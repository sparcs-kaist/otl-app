import 'package:timeplanner_mobile/models/time.dart';

class Classtime extends Time {
  String buildingCode;
  String classroom;
  String classroomEn;
  String classroomShort;
  String classroomShortEn;
  String roomName;

  Classtime(
      {this.buildingCode,
      this.classroom,
      this.classroomEn,
      this.classroomShort,
      this.classroomShortEn,
      this.roomName,
      int day,
      int begin,
      int end})
      : super(day: day, begin: begin, end: end);

  Classtime.fromJson(Map<String, dynamic> json) {
    buildingCode = json['building_code'];
    classroom = json['classroom'];
    classroomEn = json['classroom_en'];
    classroomShort = json['classroom_short'];
    classroomShortEn = json['classroom_short_en'];
    roomName = json['room_name'];
    day = json['day'];
    begin = json['begin'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['building_code'] = this.buildingCode;
    data['classroom'] = this.classroom;
    data['classroom_en'] = this.classroomEn;
    data['classroom_short'] = this.classroomShort;
    data['classroom_short_en'] = this.classroomShortEn;
    data['room_name'] = this.roomName;
    data['day'] = this.day;
    data['begin'] = this.begin;
    data['end'] = this.end;
    return data;
  }
}
