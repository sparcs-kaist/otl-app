class Departments {
  String nameEn;
  String code;
  int id;
  String name;

  Departments({this.nameEn, this.code, this.id, this.name});

  Departments.fromJson(Map<String, dynamic> json) {
    nameEn = json['name_en'];
    code = json['code'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name_en'] = this.nameEn;
    data['code'] = this.code;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
