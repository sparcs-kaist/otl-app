import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeplanner_mobile/models/course.dart';
import 'package:timeplanner_mobile/models/department.dart';
import 'package:timeplanner_mobile/models/professor.dart';
import 'package:timeplanner_mobile/widgets/course_block.dart';

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
