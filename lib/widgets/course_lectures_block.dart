import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/models/lecture.dart';

class CourseLecturesBlock extends StatelessWidget {
  final Lecture lecture;
  final VoidCallback onTap;
  final bool isSelected;

  CourseLecturesBlock({@required this.lecture, this.onTap, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: isSelected ? const Color(0xFFDDDDDD) : null,
          padding: const EdgeInsets.fromLTRB(18, 6, 10, 6),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: lecture.classTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: " "),
                TextSpan(text: lecture.professorsStrShort),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
