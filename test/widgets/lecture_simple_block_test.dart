import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/widgets/lecture_simple_block.dart';

void main() {
  testWidgets('pump', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: LectureSimpleBlock(lecture: Lecture())));
  });
}
