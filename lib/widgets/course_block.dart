import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/extensions/course.dart';
import 'package:otlplus/models/course.dart';

class CourseBlock extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  CourseBlock({required this.course, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: BLOCK_COLOR,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 12.0),
                    children: <TextSpan>[
                      TextSpan(
                        text: course.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: " "),
                      TextSpan(text: course.oldCode),
                    ],
                  ),
                ),
                const Divider(color: BORDER_BOLD_COLOR, height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "분류 ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        height: 1.1,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${course.department?.name}, ${course.type}",
                        style: const TextStyle(
                          fontSize: 12.0,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "교수 ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        height: 1.1,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        course.professorsStr,
                        style: const TextStyle(
                          fontSize: 12.0,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "설명 ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        height: 1.1,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        course.summary,
                        style: const TextStyle(
                          fontSize: 12.0,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
