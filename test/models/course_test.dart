import 'dart:convert';
import 'package:test/test.dart';
import 'package:timeplanner_mobile/models/course.dart';
import 'package:timeplanner_mobile/models/department.dart';
import 'package:timeplanner_mobile/models/professor.dart';

void main() {
  group('Course', () {
    test('==', () {
      final course = Course();
      final object = Object();
      expect(course == object, false);
    });

    test('==', () {
      final course1 = Course(id: 1);
      final course2 = Course(id: 2);
      expect(course1 == course2, false);
    });

    test('==', () {
      final course1 = Course(id: 1, oldCode: '1');
      final course2 = Course(id: 1, oldCode: '2');
      expect(course1 == course2, true);
    });

    const id = 1;
    const oldCode = '';
    final department = Department(id: 1, name: '', nameEn: '', code: '');
    const type = '';
    const typeEn = '';
    const title = '';
    const titleEn = '';
    const summary = '';
    const reviewNum = 1;
    final professors = [
      Professor(name: '', nameEn: '', professorId: 1, reviewNum: 1),
      Professor(name: '', nameEn: '', professorId: 2, reviewNum: 2)
    ];
    const grade = 4.3;
    const load = 4.3;
    const speech = 4.3;
    const userspecificIsRead = true;
    final json = """
    {
      "id": $id,
      "old_code": "$oldCode",
      "department": ${jsonEncode(department.toJson())},
      "type": "$type",
      "type_en": "$typeEn",
      "title": "$title",
      "title_en": "$titleEn",
      "summary": "$summary",
      "review_num": $reviewNum,
      "professors": [
        ${jsonEncode(professors[0])},
        ${jsonEncode(professors[1])}
      ],
      "grade": $grade,
      "load": $load,
      "speech": $speech,
      "userspecific_is_read": $userspecificIsRead
    }
    """;

    test('fromJson', () {
      final course = Course.fromJson(jsonDecode(json));
      expect(course.department, department);
      expect(course.professors, professors);
    });
  });
}
