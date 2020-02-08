import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/lecture.dart';

class TimetableBlock extends StatelessWidget {
  final Lecture lecture;

  TimetableBlock({@required this.lecture});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: TIMETABLE_BLOCK_COLORS[lecture.course % 16],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              lecture.title,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              lecture.professors.first.name,
              style: TextStyle(color: Colors.black54),
            ),
            Text(
              lecture.classroom,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
