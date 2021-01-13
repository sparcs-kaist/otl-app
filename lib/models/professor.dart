class Professor {
  String name;
  String nameEn;
  int professorId;
  int reviewNum;

  Professor({this.name, this.nameEn, this.professorId, this.reviewNum});

  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Professor && other.professorId == professorId);

  int get hashCode => professorId.hashCode;

  Professor.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nameEn = json['name_en'];
    professorId = json['professor_id'];
    reviewNum = json['review_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['professor_id'] = this.professorId;
    data['review_num'] = this.reviewNum;
    return data;
  }
}
