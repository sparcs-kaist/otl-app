import 'dart:convert';
import 'dart:io';

import 'package:otlplus/models/lecture.dart';
import 'package:test/test.dart';

void main() {
  group('check typeIdx', () {
    test('BR type index should be 0', () {
      final lectures =
          json.decode(File('test_samples/lecture/BR.json').readAsStringSync());
      for (Map<String, dynamic> l in lectures) {
        final Lecture lecture = Lecture.fromJson(l);
        expect(lecture.typeIdx, 0);
      }
    });
    test('BE type index should be 1', () {
      final lectures =
          json.decode(File('test_samples/lecture/BE.json').readAsStringSync());
      for (Map<String, dynamic> l in lectures) {
        final Lecture lecture = Lecture.fromJson(l);
        expect(lecture.typeIdx, 1);
      }
    });
    test('MR type index should be 2', () {
      final lectures =
          json.decode(File('test_samples/lecture/MR.json').readAsStringSync());
      for (Map<String, dynamic> l in lectures) {
        final Lecture lecture = Lecture.fromJson(l);
        expect(lecture.typeIdx, 2);
      }
    });
    test('ME type index should be 3', () {
      final lectures =
          json.decode(File('test_samples/lecture/ME.json').readAsStringSync());
      for (Map<String, dynamic> l in lectures) {
        final Lecture lecture = Lecture.fromJson(l);
        expect(lecture.typeIdx, 3);
      }
    });
    test('HSE type index should be 4', () {
      final lectures =
          json.decode(File('test_samples/lecture/HSE.json').readAsStringSync());
      for (Map<String, dynamic> l in lectures) {
        final Lecture lecture = Lecture.fromJson(l);
        expect(lecture.typeIdx, 4);
      }
    });
  });
}
