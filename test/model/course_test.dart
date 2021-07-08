import 'package:test/test.dart';
import 'package:timeplanner_mobile/models/course.dart';

void main() {
  group('Course', () {
    test('==', () {
      var course = Course();
      var object = Object();
      expect(course == object, false);
    });

    test('==', () {
      var course1 = Course(id: 1);
      var course2 = Course(id: 2);
      expect(course1 == course2, false);
    });

    test('==', () {
      var course1 = Course(id: 1, oldCode: '1');
      var course2 = Course(id: 1, oldCode: '2');
      expect(course1 == course2, true);
    });
  });
}
