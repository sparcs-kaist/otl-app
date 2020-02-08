class Classtime {
  String building;
  String classroom;
  int begin;
  int end;
  String room;
  String classroomShortEn;
  int day;
  String classroomEn;
  String classroomShort;

  Classtime(
      {this.building,
      this.classroom,
      this.begin,
      this.end,
      this.room,
      this.classroomShortEn,
      this.day,
      this.classroomEn,
      this.classroomShort});

  Classtime.fromJson(Map<String, dynamic> json) {
    building = json['building'];
    classroom = json['classroom'];
    begin = json['begin'];
    end = json['end'];
    room = json['room'];
    classroomShortEn = json['classroom_short_en'];
    day = json['day'];
    classroomEn = json['classroom_en'];
    classroomShort = json['classroom_short'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['building'] = this.building;
    data['classroom'] = this.classroom;
    data['begin'] = this.begin;
    data['end'] = this.end;
    data['room'] = this.room;
    data['classroom_short_en'] = this.classroomShortEn;
    data['day'] = this.day;
    data['classroom_en'] = this.classroomEn;
    data['classroom_short'] = this.classroomShort;
    return data;
  }
}
