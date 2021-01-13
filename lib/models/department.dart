class Department {
  int id;
  String name;
  String nameEn;
  String code;

  Department({this.id, this.name, this.nameEn, this.code});

  bool operator ==(Object other) =>
      identical(this, other) || (other is Department && other.id == id);

  int get hashCode => id.hashCode;

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['code'] = this.code;
    return data;
  }
}
