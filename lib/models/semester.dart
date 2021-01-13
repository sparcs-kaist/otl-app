class Semester {
  int year;
  int semester;
  DateTime beginning;
  DateTime end;
  DateTime courseDesciptionSubmission;
  DateTime courseRegistrationPeriodStart;
  DateTime courseRegistrationPeriodEnd;
  DateTime courseAddDropPeriodEnd;
  DateTime courseDropDeadline;
  DateTime courseEvaluationDeadline;
  DateTime gradePosting;

  Semester(
      {this.year,
      this.semester,
      this.beginning,
      this.end,
      this.courseDesciptionSubmission,
      this.courseRegistrationPeriodStart,
      this.courseRegistrationPeriodEnd,
      this.courseAddDropPeriodEnd,
      this.courseDropDeadline,
      this.courseEvaluationDeadline,
      this.gradePosting});

  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Semester && other.year == year && other.semester == semester);

  int get hashCode => year.hashCode ^ semester.hashCode;

  Semester.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    semester = json['semester'];
    beginning = DateTime.tryParse(json['beginning'] ?? "");
    end = DateTime.tryParse(json['end'] ?? "");
    courseDesciptionSubmission =
        DateTime.tryParse(json['courseDesciptionSubmission'] ?? "");
    courseRegistrationPeriodStart =
        DateTime.tryParse(json['courseRegistrationPeriodStart'] ?? "");
    courseRegistrationPeriodEnd =
        DateTime.tryParse(json['courseRegistrationPeriodEnd'] ?? "");
    courseAddDropPeriodEnd =
        DateTime.tryParse(json['courseAddDropPeriodEnd'] ?? "");
    courseDropDeadline = DateTime.tryParse(json['courseDropDeadline'] ?? "");
    courseEvaluationDeadline =
        DateTime.tryParse(json['courseEvaluationDeadline'] ?? "");
    gradePosting = DateTime.tryParse(json['gradePosting'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['year'] = this.year;
    data['semester'] = this.semester;
    data['beginning'] = this.beginning;
    data['end'] = this.end;
    data['courseDesciptionSubmission'] = this.courseDesciptionSubmission;
    data['courseRegistrationPeriodStart'] = this.courseRegistrationPeriodStart;
    data['courseRegistrationPeriodEnd'] = this.courseRegistrationPeriodEnd;
    data['courseAddDropPeriodEnd'] = this.courseAddDropPeriodEnd;
    data['courseDropDeadline'] = this.courseDropDeadline;
    data['courseEvaluationDeadline'] = this.courseEvaluationDeadline;
    data['gradePosting'] = this.gradePosting;
    return data;
  }
}
