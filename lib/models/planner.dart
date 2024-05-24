import 'package:otlplus/models/course.dart';
import 'package:otlplus/models/department.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/models/planner_course.dart';

class Planner {
  final int id;
  final int start_year;
  final int end_year;
  final int arrange_order;
  final GeneralTrack general_track;
  final MajorTrack major_track;
  final List<AdditionalTrack> additional_tracks;
  final List<TakenItem> taken_items;
  final List<FutureItem> future_items;
  final List<ArbitraryItem> arbitrary_items;

  Planner({
    required this.id,
    required this.start_year,
    required this.end_year,
    required this.arrange_order,
    required this.general_track,
    required this.major_track,
    required this.additional_tracks,
    required this.taken_items,
    required this.future_items,
    required this.arbitrary_items,
  });

  factory Planner.fromJson(Map<String, dynamic> json) {
    return Planner(
        id: json['id'],
        start_year: json['start_year'],
        end_year: json['end_year'],
        arrange_order: json['arrange_order'],
        general_track: GeneralTrack.fromJson(json['general_track']),
        major_track: MajorTrack.fromJson(json['major_track']),
        additional_tracks: (json['additional_tracks'] as List)
            .map((tracks) => AdditionalTrack.fromJson(tracks))
            .toList(),
        taken_items: (json['taken_items'] as List)
            .map((item) => TakenItem.fromJson(item))
            .toList(),
        future_items: (json['future_items'] as List)
            .map((item) => FutureItem.fromJson(item))
            .toList(),
        arbitrary_items: (json['arbitrary_items'] as List)
            .map((item) => ArbitraryItem.fromJson(item))
            .toList());
  }
}

// class Planner {
//   final int id;
//
//   Planner({required this.id});
//
//   bool operator ==(Object other) =>
//       identical(this, other) || (other is Planner && other.id == id);
//
//   int get hashCode => id.hashCode;
//
//   Planner.fromJson(Map<String, dynamic> json) : id = json['id'] {
//     if (json['lectures'] != null) {
//       lectures = [];
//       json['lectures'].forEach((v) {
//         lectures.add(Lecture.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['id'] = this.id;
//     data['lectures'] = this.lectures.map((v) => v.toJson()).toList();
//     return data;
//   }
// }

class GeneralTrack {
  late int id = 0;
  late int start_year = 0;
  late int end_year = 0;
  late bool is_foreign = false;
  late int total_credit = 0;
  late int total_au = 0;
  late int basic_required = 0;
  late int basic_elective = 0;
  late int thesis_study = 0;
  late int thesis_study_doublemajor = 0;
  late int general_required_credit = 0;
  late int general_required_au = 0;
  late int humanities = 0;
  late int humanities_doublemajor = 0;

  GeneralTrack({
    this.id = 0,
    this.start_year = 0,
    this.end_year = 0,
    this.is_foreign = false,
    this.total_credit = 0,
    this.total_au = 0,
    this.basic_required = 0,
    this.basic_elective = 0,
    this.thesis_study = 0,
    this.thesis_study_doublemajor = 0,
    this.general_required_au = 0,
    this.general_required_credit = 0,
    this.humanities = 0,
    this.humanities_doublemajor = 0,
  });

  factory GeneralTrack.fromJson(Map<String, dynamic> json) {
    return GeneralTrack(
      id: json['id'],
      start_year: json['start_year'],
      end_year: json['end_year'],
      is_foreign: json['is_foreign'],
      total_credit: json['total_credit'],
      total_au: json['total_au'],
      basic_required: json['basic_required'],
      basic_elective: json['basic_elective'],
      thesis_study: json['thesis_study'],
      thesis_study_doublemajor: json['thesis_study_doublemajor'],
      general_required_credit: json['general_required_credit'],
      general_required_au: json['general_required_au'],
      humanities: json['humanities'],
      humanities_doublemajor: json['humanities_doublemajor'],
    );
  }
}

class MajorTrack {
  late int id = 0;
  late int start_year = 0;
  late int end_year = 0;
  late int basic_elective_doublemajor = 0;
  late int major_required = 0;
  late int major_elective = 0;
  late Department department =
      Department(id: 0, name: "", nameEn: "", code: "");

  MajorTrack({
    this.id = 0,
    this.start_year = 0,
    this.end_year = 0,
    this.basic_elective_doublemajor = 0,
    this.major_required = 0,
    this.major_elective = 0,
    required this.department,
  });

  factory MajorTrack.fromJson(Map<String, dynamic> json) {
    return MajorTrack(
        id: json['id'],
        start_year: json['start_year'],
        end_year: json['end_year'],
        basic_elective_doublemajor: json['basic_elective_doublemajor'],
        major_required: json['major_required'],
        major_elective: json['major_elective'],
        department: Department.fromJson(json['department']));
  }
}

class AdditionalTrack {
  late int id = 0;
  late int start_year = 0;
  late int end_year = 0;
  late String type = "";
  late int major_required = 0;
  late int major_elective = 0;
  late Department department =
      Department(id: 0, name: "", nameEn: "", code: "");

  AdditionalTrack({
    this.id = 0,
    this.start_year = 0,
    this.end_year = 0,
    this.type = "",
    this.major_required = 0,
    this.major_elective = 0,
    required this.department,
  });

  factory AdditionalTrack.fromJson(Map<String, dynamic> json) {
    return AdditionalTrack(
        id: json['id'],
        start_year: json['start_year'],
        end_year: json['end_year'],
        type: json['type'],
        major_required: json['major_required'],
        major_elective: json['major_elective'],
        department: json['department'] == null
            ? Department(id: 0, name: "", nameEn: "", code: "")
            : Department.fromJson(json['department']));
  }
}

class TakenItem {
  late int id = 0;
  late String item_type = "";
  late bool is_excluded = false;
  late Lecture lecture;
  late PlannerCourse course;

  TakenItem({
    this.id = 0,
    this.item_type = "",
    this.is_excluded = false,
    required this.lecture,
    required this.course,
  });

  factory TakenItem.fromJson(Map<String, dynamic> json) {
    return TakenItem(
      id: json['id'],
      item_type: json['item_type'],
      is_excluded: json['is_excluded'],
      lecture: Lecture.fromJson(json['lecture']),
      course: PlannerCourse.fromJson(json['course']),
    );
  }
}

class FutureItem {
  late int id = 0;
  late String item_type = "";
  late bool is_excluded = false;
  late int year = 0;
  late int semester = 0;
  late PlannerCourse course;

  FutureItem({
    this.id = 0,
    this.item_type = "",
    this.is_excluded = false,
    this.year = 0,
    this.semester = 0,
    required this.course,
  });

  factory FutureItem.fromJson(Map<String, dynamic> json) {
    return FutureItem(
      id: json['id'],
      item_type: json['item_type'],
      is_excluded: json['is_excluded'],
      year: json['year'],
      semester: json['semester'],
      course: PlannerCourse.fromJson(json['course']),
    );
  }
}

class ArbitraryItem {
  late int id = 0;
  late bool isArbitrary = false;
  late String type = "";
  late String type_en = "";
  late int credit = 0;
  late int credit_au = 0;
  late String title = "";
  late String title_en = "";
  late String old_code = "";
  late Department department =
      Department(id: 0, name: "", nameEn: "", code: "");

  ArbitraryItem({
    this.id = 0,
    this.isArbitrary = false,
    this.type = "",
    this.type_en = "",
    this.credit = 0,
    this.credit_au = 0,
    this.title = "",
    this.title_en = "",
    this.old_code = "",
    required this.department,
  });

  factory ArbitraryItem.fromJson(Map<String, dynamic> json) {
    return ArbitraryItem(
        id: json['id'],
        isArbitrary: json['isArbitrary'],
        type: json['type'],
        type_en: json['type_en'],
        credit: json['credit'],
        credit_au: json['credit_au'],
        title: json['title'],
        title_en: json['title_en'],
        old_code: json['old_code'].toString(),
        department: json['department'] == null
            ? Department(id: 0, name: "", nameEn: "", code: "")
            : Department.fromJson(json['department']));
  }
}
