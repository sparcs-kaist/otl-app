import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:otlplus/models/lecture.dart';
import 'package:test/test.dart';

void main() {
  const semestersUrl =
      'https://otl.sparcs.org/api/semesters?order=year&order=semester';
  String lecturesUrl =
      'https://otl.sparcs.org/api/lectures?year={year}&semester={semester}&keyword=&type={type}&department=ALL&level=ALL&&order=old_code&limit=1';

  group('check typeIdx', () {
    setUp(() async {
      final response = await http.get(Uri.parse(semestersUrl));
      final body = json.decode(response.body);
      final year = body[body.length - 1]['year'];
      final semester = body[body.length - 1]['semester'];
      lecturesUrl = lecturesUrl
          .replaceFirst('{year}', year.toString())
          .replaceFirst('{semester}', semester.toString());
    });

    test('BR type index should be 0', () async {
      final url = lecturesUrl.replaceFirst('{type}', 'BR');
      final response = await http.get(Uri.parse(url));
      final lectures = json.decode(response.body);
      for (Map<String, dynamic> l in lectures) {
        final Lecture lecture = Lecture.fromJson(l);
        expect(lecture.typeIdx, 0);
      }
    });

    test('BE type index should be 1', () async {
      final url = lecturesUrl.replaceFirst('{type}', 'BE');
      final response = await http.get(Uri.parse(url));
      final lectures = json.decode(response.body);
      for (Map<String, dynamic> l in lectures) {
        final Lecture lecture = Lecture.fromJson(l);
        expect(lecture.typeIdx, 1);
      }
    });

    test('MR type index should be 2', () async {
      final url = lecturesUrl.replaceFirst('{type}', 'MR');
      final response = await http.get(Uri.parse(url));
      final lectures = json.decode(response.body);
      for (Map<String, dynamic> l in lectures) {
        final Lecture lecture = Lecture.fromJson(l);
        expect(lecture.typeIdx, 2);
      }
    });

    test('ME type index should be 3', () async {
      final url = lecturesUrl.replaceFirst('{type}', 'ME');
      final response = await http.get(Uri.parse(url));
      final lectures = json.decode(response.body);
      for (Map<String, dynamic> l in lectures) {
        final Lecture lecture = Lecture.fromJson(l);
        expect(lecture.typeIdx, 3);
      }
    });

    test('HSE type index should be 4', () async {
      final url = lecturesUrl.replaceFirst('{type}', 'HSE');
      final response = await http.get(Uri.parse(url));
      final lectures = json.decode(response.body);
      for (Map<String, dynamic> l in lectures) {
        final Lecture lecture = Lecture.fromJson(l);
        expect(lecture.typeIdx, 4);
      }
    });
  });
}
