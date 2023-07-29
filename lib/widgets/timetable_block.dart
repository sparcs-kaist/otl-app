import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/extensions/lecture.dart';
import 'package:otlplus/models/lecture.dart';

class TimetableBlock extends StatelessWidget {
  final Lecture lecture;
  final int classTimeIndex;
  final double height;
  final double fontSize;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isTemp;
  final bool isExamTime;
  final bool showTitle;
  @Deprecated('There is no case to show the professor')
  final bool showProfessor;
  final bool showClassroom;

  TimetableBlock(
      {Key? key,
      required this.lecture,
      this.classTimeIndex = 0,
      this.height = 78,
      this.fontSize = 9.0,
      this.onTap,
      this.onLongPress,
      this.isTemp = false,
      this.isExamTime = false,
      this.showTitle = true,
      this.showProfessor = false,
      this.showClassroom = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contents = <Widget>[];
    final singleHeight = labelRegular.fontSize! * labelRegular.height!;

    if (showTitle) {
      contents.add(ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight:
                height - 16 - singleHeight),
        child: Text(
          lecture.title,
          style: labelRegular,
        ),
      ));
    }

    if (showProfessor) {
      contents.add(Text(lecture.professorsStrShort));
    }

    if (showClassroom) {
      final textPainter = TextPainter(
        text: TextSpan(text: lecture.title, style: labelRegular),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 54);
      final maxLines = (height - textPainter.size.height - 16) ~/ singleHeight;

      contents.add(Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            lecture.classtimes[classTimeIndex].classroomShort,
            style: labelRegular.copyWith(
              color: gray6,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: maxLines > 1 ? maxLines : 1,
          ),
        ),
      ));
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: isTemp
            ? pinksMain
            : isExamTime
                ? grayE
                : TIMETABLE_BLOCK_COLORS[lecture.course % 16],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(2.0),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: contents,
            ),
          ),
        ),
      ),
    );
  }
}
