import 'package:timeplanner_mobile/models/department.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/models/review.dart';

class User {
  List<Lecture> myTimetableLectures;
  List<Department> favoriteDepartments;
  int id;
  List<Department> majors;
  String firstName;
  List<Lecture> reviewWritableLectures;
  String lastName;
  List<Department> departments;
  List<Review> reviews;
  String studentId;
  String email;

  User(
      {this.myTimetableLectures,
      this.favoriteDepartments,
      this.id,
      this.majors,
      this.firstName,
      this.reviewWritableLectures,
      this.lastName,
      this.departments,
      this.reviews,
      this.studentId,
      this.email});

  bool operator ==(Object other) =>
      identical(this, other) || (other is User && other.id == id);

  int get hashCode => id.hashCode;

  User.fromJson(Map<String, dynamic> json) {
    if (json['my_timetable_lectures'] != null) {
      myTimetableLectures = List<Lecture>();
      json['my_timetable_lectures'].forEach((v) {
        myTimetableLectures.add(Lecture.fromJson(v));
      });
    }
    if (json['favorite_departments'] != null) {
      favoriteDepartments = List<Department>();
      json['favorite_departments'].forEach((v) {
        favoriteDepartments.add(Department.fromJson(v));
      });
    }
    id = json['id'];
    if (json['majors'] != null) {
      majors = List<Department>();
      json['majors'].forEach((v) {
        majors.add(Department.fromJson(v));
      });
    }
    firstName = json['firstName'];
    if (json['review_writable_lectures'] != null) {
      reviewWritableLectures = List<Lecture>();
      json['review_writable_lectures'].forEach((v) {
        reviewWritableLectures.add(Lecture.fromJson(v));
      });
    }
    lastName = json['lastName'];
    if (json['departments'] != null) {
      departments = List<Department>();
      json['departments'].forEach((v) {
        departments.add(Department.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = List<Review>();
      json['reviews'].forEach((v) {
        reviews.add(Review.fromJson(v));
      });
    }
    studentId = json['student_id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.myTimetableLectures != null) {
      data['my_timetable_lectures'] =
          this.myTimetableLectures.map((v) => v.toJson()).toList();
    }
    if (this.favoriteDepartments != null) {
      data['favorite_departments'] =
          this.favoriteDepartments.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    if (this.majors != null) {
      data['majors'] = this.majors.map((v) => v.toJson()).toList();
    }
    data['firstName'] = this.firstName;
    if (this.reviewWritableLectures != null) {
      data['review_writable_lectures'] =
          this.reviewWritableLectures.map((v) => v.toJson()).toList();
    }
    data['lastName'] = this.lastName;
    if (this.departments != null) {
      data['departments'] = this.departments.map((v) => v.toJson()).toList();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    data['student_id'] = this.studentId;
    data['email'] = this.email;
    return data;
  }
}
