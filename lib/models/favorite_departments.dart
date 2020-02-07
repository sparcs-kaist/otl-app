class FavoriteDepartments {
  String nameEn;
  String code;
  int id;
  String name;

  FavoriteDepartments({this.nameEn, this.code, this.id, this.name});

  FavoriteDepartments.fromJson(Map<String, dynamic> json) {
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
