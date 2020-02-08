class Examtime {
  int begin;
  int end;
  int day;
  String str;
  String strEn;

  Examtime({this.begin, this.end, this.day, this.str, this.strEn});

  Examtime.fromJson(Map<String, dynamic> json) {
    begin = json['begin'];
    end = json['end'];
    day = json['day'];
    str = json['str'];
    strEn = json['str_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['begin'] = this.begin;
    data['end'] = this.end;
    data['day'] = this.day;
    data['str'] = this.str;
    data['str_en'] = this.strEn;
    return data;
  }
}
