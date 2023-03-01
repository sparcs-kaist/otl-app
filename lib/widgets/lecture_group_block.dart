import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/widgets/lecture_group_block_row.dart';

class LectureGroupBlock extends StatelessWidget {
  final List<Lecture> lectures;
  final Lecture? selectedLecture;
  final void Function(Lecture) onTap;
  final void Function(Lecture) onLongPress;

  LectureGroupBlock(
      {required this.lectures,
      this.selectedLecture,
      required this.onTap,
      required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    if (lectures.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 6.0),
        padding: const EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: BLOCK_COLOR,
        ),
        child: Text("There is no lecture."),
      );
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      padding: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    style: const TextStyle(fontSize: 12.0),
                    children: <TextSpan>[
                      TextSpan(
                        text: lectures.first.commonTitle,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: " "),
                      TextSpan(text: lectures.first.oldCode),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 10.0,
                      color: Color(0xFF999999),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: lectures.first.departmentCode,
                      ),
                      const TextSpan(text: " / "),
                      TextSpan(text: lectures.first.type),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                height: 1,
                child: ColoredBox(
                  color: Color(0xFFDADADA),
                ),
              ),
            ),
            ...lectures.map((lecture) => LectureGroupBlockRow(
              lecture: lecture,
              isSelected: selectedLecture == lecture,
              onTap: () => onTap(lecture),
              onLongPress: () => onLongPress(lecture),
            )),
          ]
        ),
      ),
    );
  }
}
