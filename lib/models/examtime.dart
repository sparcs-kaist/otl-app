import 'package:timeplanner_mobile/models/time.dart';

class Examtime extends Time {
  String str;
  String strEn;

  Examtime({this.str, this.strEn, int day, int begin, int end})
      : super(day: day, begin: begin, end: end);

  Examtime.fromJson(Map<String, dynamic> json) {
    str = json['str'];
    strEn = json['str_en'];
    day = json['day'];
    begin = json['begin'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['str'] = this.str;
    data['str_en'] = this.strEn;
    data['day'] = this.day;
    data['begin'] = this.begin;
    data['end'] = this.end;
    return data;
  }
}
