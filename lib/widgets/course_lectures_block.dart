import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/lecture.dart';

class CourseLecturesBlock extends StatelessWidget {
  final Lecture lecture;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isSelected;

  CourseLecturesBlock(
      {@required this.lecture, this.onTap, this.onLongPress, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          color: isSelected ? SELECTED_COLOR : null,
          padding: const EdgeInsets.fromLTRB(18, 6, 10, 6),
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 12.0),
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
