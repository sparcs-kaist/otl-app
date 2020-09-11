import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/lecture.dart';

class TimetableBlock extends StatelessWidget {
  final Lecture lecture;
  final double fontSize;
  final VoidCallback onTap;
  final bool isTemp;
  final bool showTitle;
  final bool showProfessor;
  final bool showClassroom;

  TimetableBlock(
      {Key key,
      @required this.lecture,
      this.fontSize = 10.0,
      this.onTap,
      this.isTemp = false,
      this.showTitle = true,
      this.showProfessor = false,
      this.showClassroom = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contents = <InlineSpan>[];

    if (showTitle) {
      contents.add(TextSpan(
        text: lecture.title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: fontSize,
        ),
      ));
      contents.add(const TextSpan(text: "\n"));
      contents.add(const WidgetSpan(child: SizedBox(height: 12)));
    }

    if (showProfessor) {
      contents.add(TextSpan(text: lecture.professorsStrShort));
      contents.add(const TextSpan(text: "\n"));
    }

    if (showClassroom) {
      contents.add(TextSpan(text: lecture.classroom));
      contents.add(const TextSpan(text: "\n"));
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: isTemp
            ? const Color(0xFFE05469).withOpacity(0.9)
            : TIMETABLE_BLOCK_COLORS[lecture.course % 16],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(2.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: fontSize - 1,
                ),
                children: contents,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
