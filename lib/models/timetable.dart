import 'package:timeplanner_mobile/models/lecture.dart';

class Timetable {
  List<Lecture> lectures;
  int id;

  Timetable({this.lectures, this.id});

  bool operator ==(Object other) =>
      identical(this, other) || (other is Timetable && other.id == id);

  int get hashCode => id.hashCode;

  Timetable.fromJson(Map<String, dynamic> json) {
    if (json['lectures'] != null) {
      lectures = List<Lecture>();
      json['lectures'].forEach((v) {
        lectures.add(Lecture.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.lectures != null) {
      data['lectures'] = this.lectures.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}
