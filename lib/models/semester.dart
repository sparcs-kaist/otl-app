class Semester {
  String end;
  int year;
  int semester;
  String beginning;

  Semester({this.end, this.year, this.semester, this.beginning});

  Semester.fromJson(Map<String, dynamic> json) {
    end = json['end'];
    year = json['year'];
    semester = json['semester'];
    beginning = json['beginning'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['end'] = this.end;
    data['year'] = this.year;
    data['semester'] = this.semester;
    data['beginning'] = this.beginning;
    return data;
  }
}
