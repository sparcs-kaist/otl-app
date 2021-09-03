import 'package:otlplus/models/time.dart';

class Classtime extends Time {
  final String buildingCode;
  final String classroom;
  final String classroomEn;
  final String classroomShort;
  final String classroomShortEn;
  final String roomName;

  Classtime(
      {required this.buildingCode,
      required this.classroom,
      required this.classroomEn,
      required this.classroomShort,
      required this.classroomShortEn,
      required this.roomName,
      day,
      begin,
      end})
      : super(day: day, begin: begin, end: end);

  @override
  List<Object> get props =>
      super.props..addAll([buildingCode, classroom, roomName]);

  factory Classtime.fromJson(Map<String, dynamic> json) {
    return Classtime(
        buildingCode: json['building_code'],
        classroom: json['classroom'],
        classroomEn: json['classroom_en'],
        classroomShort: json['classroom_short'],
        classroomShortEn: json['classroom_short_en'],
        roomName: json['room_name'],
        day: json['day'],
        begin: json['begin'],
        end: json['end']);
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
