import 'dart:convert';
import 'package:otlplus/models/course.dart';
import 'package:test/test.dart';

import '../samples.dart';

void main() {
  group('Course', () {
    test('constructor', () {
      expect(SampleCourse.shared is Course, true);
    });

    test('fromJson', () {
      final courseFromJson = Course.fromJson(jsonDecode(SampleCourse.json));
      expect(courseFromJson == SampleCourse.shared, true);
    });

    test('toJson', () {
      expect(SampleCourse.shared.toJson(), jsonDecode(SampleCourse.json));
    });
  });
}
