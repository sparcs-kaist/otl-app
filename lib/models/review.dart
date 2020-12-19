import 'package:timeplanner_mobile/models/course.dart';
import 'package:timeplanner_mobile/models/lecture.dart';

class Review {
  int load;
  int isDeleted;
  int like;
  int grade;
  String content;
  Course course;
  String speechLetter;
  int speech;
  String loadLetter;
  Lecture lecture;
  int id;
  String gradeLetter;

  Review(
      {this.load,
      this.isDeleted,
      this.like,
      this.grade,
      this.content,
      this.course,
      this.speechLetter,
      this.speech,
      this.loadLetter,
      this.lecture,
      this.id,
      this.gradeLetter});

  bool operator ==(Object other) =>
      identical(this, other) || (other is Review && other.id == id);

  int get hashCode => id.hashCode;

  Review.fromJson(Map<String, dynamic> json) {
    load = json['load'];
    isDeleted = json['is_deleted'];
    like = json['like'];
    grade = json['grade'];
    content = json['content'];
    course = json['course'] != null ? Course.fromJson(json['course']) : null;
    speechLetter = json['speech_letter'];
    speech = json['speech'];
    loadLetter = json['load_letter'];
    lecture =
        json['lecture'] != null ? Lecture.fromJson(json['lecture']) : null;
    id = json['id'];
    gradeLetter = json['grade_letter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['load'] = this.load;
    data['is_deleted'] = this.isDeleted;
    data['like'] = this.like;
    data['grade'] = this.grade;
    data['content'] = this.content;
    if (this.course != null) {
      data['course'] = this.course.toJson();
    }
    data['speech_letter'] = this.speechLetter;
    data['speech'] = this.speech;
    data['load_letter'] = this.loadLetter;
    if (this.lecture != null) {
      data['lecture'] = this.lecture.toJson();
    }
    data['id'] = this.id;
    data['grade_letter'] = this.gradeLetter;
    return data;
  }
}
