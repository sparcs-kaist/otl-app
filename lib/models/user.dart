import 'package:timeplanner_mobile/models/departments.dart';
import 'package:timeplanner_mobile/models/favorite_departments.dart';
import 'package:timeplanner_mobile/models/my_timetable_lectures.dart';
import 'package:timeplanner_mobile/models/review_writable_lectures.dart';
import 'package:timeplanner_mobile/models/reviews.dart';

class User {
  List<MyTimetableLectures> myTimetableLectures;
  List<FavoriteDepartments> favoriteDepartments;
  int id;
  List<Departments> majors;
  String firstName;
  List<ReviewWritableLectures> reviewWritableLectures;
  String lastName;
  List<Departments> departments;
  List<Reviews> reviews;
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

  User.fromJson(Map<String, dynamic> json) {
    if (json['my_timetable_lectures'] != null) {
      myTimetableLectures = List<MyTimetableLectures>();
      json['my_timetable_lectures'].forEach((v) {
        myTimetableLectures.add(MyTimetableLectures.fromJson(v));
      });
    }
    if (json['favorite_departments'] != null) {
      favoriteDepartments = List<FavoriteDepartments>();
      json['favorite_departments'].forEach((v) {
        favoriteDepartments.add(FavoriteDepartments.fromJson(v));
      });
    }
    id = json['id'];
    if (json['majors'] != null) {
      majors = List<Departments>();
      json['majors'].forEach((v) {
        majors.add(Departments.fromJson(v));
      });
    }
    firstName = json['firstName'];
    if (json['review_writable_lectures'] != null) {
      reviewWritableLectures = List<ReviewWritableLectures>();
      json['review_writable_lectures'].forEach((v) {
        reviewWritableLectures.add(ReviewWritableLectures.fromJson(v));
      });
    }
    lastName = json['lastName'];
    if (json['departments'] != null) {
      departments = List<Departments>();
      json['departments'].forEach((v) {
        departments.add(Departments.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = List<Reviews>();
      json['reviews'].forEach((v) {
        reviews.add(Reviews.fromJson(v));
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
