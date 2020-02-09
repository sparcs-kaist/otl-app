import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/lecture.dart';

class TimetableBlock extends StatelessWidget {
  final Lecture lecture;
  final double fontSize;
  final VoidCallback onTap;

  TimetableBlock(
      {@required this.lecture, this.fontSize = 11.0, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: TIMETABLE_BLOCK_COLORS[lecture.course % 16],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(2.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            child: Center(
              child: Text(
                lecture.title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
