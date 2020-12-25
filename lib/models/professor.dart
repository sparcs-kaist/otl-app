class Professor {
  int professorId;
  String nameEn;
  String name;

  Professor({this.professorId, this.nameEn, this.name});

  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Professor && other.professorId == professorId);

  int get hashCode => professorId.hashCode;

  Professor.fromJson(Map<String, dynamic> json) {
    professorId = json['professor_id'];
    nameEn = json['name_en'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['professor_id'] = this.professorId;
    data['name_en'] = this.nameEn;
    data['name'] = this.name;
    return data;
  }
}
