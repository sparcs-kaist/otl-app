import 'package:timeplanner_mobile/models/course.dart';
import 'package:timeplanner_mobile/models/lecture.dart';

class Review {
  int id;
  Course course;
  Lecture lecture;
  String content;
  int like;
  int isDeleted;
  int grade;
  int load;
  int speech;
  bool userspecificIsLiked;

  Review(
      {this.id,
      this.course,
      this.lecture,
      this.content,
      this.like,
      this.isDeleted,
      this.grade,
      this.load,
      this.speech});

  bool operator ==(Object other) =>
      identical(this, other) || (other is Review && other.id == id);

  int get hashCode => id.hashCode;

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    course = json['course'] != null ? Course.fromJson(json['course']) : null;
    lecture =
        json['lecture'] != null ? Lecture.fromJson(json['lecture']) : null;
    content = json['content'];
    like = json['like'];
    isDeleted = json['is_deleted'];
    grade = json['grade'];
    load = json['load'];
    speech = json['speech'];
    userspecificIsLiked = json['userspecific_is_liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    if (this.course != null) {
      data['course'] = this.course.toJson();
    }
    if (this.lecture != null) {
      data['lecture'] = this.lecture.toJson();
    }
    data['content'] = this.content;
    data['like'] = this.like;
    data['is_deleted'] = this.isDeleted;
    data['grade'] = this.grade;
    data['load'] = this.load;
    data['speech'] = this.speech;
    data['userspecific_is_liked'] = this.userspecificIsLiked;
    return data;
  }
}
