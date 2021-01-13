import 'package:timeplanner_mobile/models/lecture.dart';

class Timetable {
  int id;
  List<Lecture> lectures;

  Timetable({this.id, this.lectures});

  bool operator ==(Object other) =>
      identical(this, other) || (other is Timetable && other.id == id);

  int get hashCode => id.hashCode;

  Timetable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['lectures'] != null) {
      lectures = List<Lecture>();
      json['lectures'].forEach((v) {
        lectures.add(Lecture.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    if (this.lectures != null) {
      data['lectures'] = this.lectures.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
