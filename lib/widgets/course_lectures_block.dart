import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/models/lecture.dart';

class CourseLecturesBlock extends StatelessWidget {
  final Lecture lecture;
  final VoidCallback onTap;

  CourseLecturesBlock({@required this.lecture, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 6, 10, 6),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: lecture.classTitle,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: " "),
                TextSpan(text: lecture.professorsStrShort),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
