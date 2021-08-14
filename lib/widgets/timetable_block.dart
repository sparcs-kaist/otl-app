import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/extensions/lecture.dart';
import 'package:otlplus/models/lecture.dart';

class TimetableBlock extends StatelessWidget {
  final Lecture lecture;
  final int classTimeIndex;
  final double fontSize;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isTemp;
  final bool showTitle;
  final bool showProfessor;
  final bool showClassroom;

  TimetableBlock(
      {Key key,
      @required this.lecture,
      this.classTimeIndex = 0,
      this.fontSize = 9.0,
      this.onTap,
      this.onLongPress,
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
          color: CONTENT_COLOR,
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
      contents
          .add(TextSpan(text: lecture.classtimes[classTimeIndex].classroom));
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
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text.rich(
              TextSpan(
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
