class Semester {
  DateTime end;
  DateTime gradePosting;
  int year;
  DateTime courseDropDeadline;
  DateTime courseRegistrationPeriodEnd;
  int semester;
  DateTime courseAddDropPeriodEnd;
  DateTime courseEvaluationDeadline;
  DateTime courseRegistrationPeriodStart;
  DateTime beginning;
  DateTime courseDesciptionSubmission;

  Semester(
      {this.end,
      this.gradePosting,
      this.year,
      this.courseDropDeadline,
      this.courseRegistrationPeriodEnd,
      this.semester,
      this.courseAddDropPeriodEnd,
      this.courseEvaluationDeadline,
      this.courseRegistrationPeriodStart,
      this.beginning,
      this.courseDesciptionSubmission});

  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Semester && other.year == year && other.semester == semester);

  int get hashCode => year.hashCode ^ semester.hashCode;

  Semester.fromJson(Map<String, dynamic> json) {
    end = DateTime.tryParse(json['end'] ?? "");
    gradePosting = DateTime.tryParse(json['gradePosting'] ?? "");
    year = json['year'];
    courseDropDeadline = DateTime.tryParse(json['courseDropDeadline'] ?? "");
    courseRegistrationPeriodEnd =
        DateTime.tryParse(json['courseRegistrationPeriodEnd'] ?? "");
    semester = json['semester'];
    courseAddDropPeriodEnd =
        DateTime.tryParse(json['courseAddDropPeriodEnd'] ?? "");
    courseEvaluationDeadline =
        DateTime.tryParse(json['courseEvaluationDeadline'] ?? "");
    courseRegistrationPeriodStart =
        DateTime.tryParse(json['courseRegistrationPeriodStart'] ?? "");
    beginning = DateTime.tryParse(json['beginning'] ?? "");
    courseDesciptionSubmission =
        DateTime.tryParse(json['courseDesciptionSubmission'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['end'] = this.end;
    data['gradePosting'] = this.gradePosting;
    data['year'] = this.year;
    data['courseDropDeadline'] = this.courseDropDeadline;
    data['courseRegistrationPeriodEnd'] = this.courseRegistrationPeriodEnd;
    data['semester'] = this.semester;
    data['courseAddDropPeriodEnd'] = this.courseAddDropPeriodEnd;
    data['courseEvaluationDeadline'] = this.courseEvaluationDeadline;
    data['courseRegistrationPeriodStart'] = this.courseRegistrationPeriodStart;
    data['beginning'] = this.beginning;
    data['courseDesciptionSubmission'] = this.courseDesciptionSubmission;
    return data;
  }
}
