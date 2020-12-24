import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/course.dart';

class CourseBlock extends StatelessWidget {
  final Course course;

  CourseBlock(this.course);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: BLOCK_COLOR,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13.0,
                height: 1.1,
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: course.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
                const TextSpan(text: " "),
                TextSpan(text: course.oldCode),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Container(color: BORDER_BOLD_COLOR, height: 1),
                  ),
                ),
                TextSpan(
                  text: "분류 ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: course.department.name),
                TextSpan(text: ", "),
                TextSpan(text: course.type),
                const TextSpan(text: "\n"),
                TextSpan(
                  text: "교수 ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                TextSpan(text: course.professorsStr),
                const TextSpan(text: "\n"),
                TextSpan(
                  text: "설명 ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                TextSpan(text: course.summary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
