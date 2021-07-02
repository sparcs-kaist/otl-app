import 'package:timeplanner_mobile/models/department.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/models/review.dart';

class User {
  int id;
  String email;
  String studentId;
  String firstName;
  String lastName;
  List<Department> majors;
  List<Department> departments;
  List<Lecture> myTimetableLectures;
  List<Department> favoriteDepartments;
  List<Lecture> reviewWritableLectures;
  List<Review> reviews;

  User(
      {this.id,
      this.email,
      this.studentId,
      this.firstName,
      this.lastName,
      this.majors,
      this.departments,
      this.myTimetableLectures,
      this.favoriteDepartments,
      this.reviewWritableLectures,
      this.reviews});

  bool operator ==(Object other) =>
      identical(this, other) || (other is User && other.id == id);

  int get hashCode => id.hashCode;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    studentId = json['student_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    if (json['majors'] != null) {
      majors = [];
      json['majors'].forEach((v) {
        majors.add(Department.fromJson(v));
      });
    }
    if (json['departments'] != null) {
      departments = [];
      json['departments'].forEach((v) {
        departments.add(Department.fromJson(v));
      });
    }
    if (json['favorite_departments'] != null) {
      favoriteDepartments = [];
      json['favorite_departments'].forEach((v) {
        favoriteDepartments.add(Department.fromJson(v));
      });
    }
    if (json['review_writable_lectures'] != null) {
      reviewWritableLectures = [];
      json['review_writable_lectures'].forEach((v) {
        reviewWritableLectures.add(Lecture.fromJson(v));
      });
    }
    if (json['my_timetable_lectures'] != null) {
      myTimetableLectures = [];
      json['my_timetable_lectures'].forEach((v) {
        myTimetableLectures.add(Lecture.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = [];
      json['reviews'].forEach((v) {
        reviews.add(Review.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['student_id'] = this.studentId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    if (this.majors != null) {
      data['majors'] = this.majors.map((v) => v.toJson()).toList();
    }
    if (this.departments != null) {
      data['departments'] = this.departments.map((v) => v.toJson()).toList();
    }
    if (this.favoriteDepartments != null) {
      data['favorite_departments'] =
          this.favoriteDepartments.map((v) => v.toJson()).toList();
    }
    if (this.reviewWritableLectures != null) {
      data['review_writable_lectures'] =
          this.reviewWritableLectures.map((v) => v.toJson()).toList();
    }
    if (this.myTimetableLectures != null) {
      data['my_timetable_lectures'] =
          this.myTimetableLectures.map((v) => v.toJson()).toList();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
