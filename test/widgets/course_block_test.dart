import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otlplus/models/course.dart';
import 'package:otlplus/models/department.dart';
import 'package:otlplus/models/professor.dart';
import 'package:otlplus/widgets/course_block.dart';

void main() {
  testWidgets('pump', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: CourseBlock(
            course: Course(
              id: 1,
              oldCode: '',
              department: Department(),
              summary: '',
              reviewNum: 0,
              professors: [Professor()],
            ),
            onTap: () => {})));
  });
}
