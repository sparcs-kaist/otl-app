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
        borderRadius: BorderRadius.circular(4.0),
        color: BLOCK_COLOR,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: ListTile.divideTiles(
          context: context,
          color: BORDER_BOLD_COLOR,
          tiles: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 6.0),
              child: Text.rich(
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
            ),
            ...lectures.map((lecture) => LectureGroupBlockRow(
                  lecture: lecture,
                  isSelected: selectedLecture == lecture,
                  borderRadius: (lectures.last == lecture)
                      ? const BorderRadius.vertical(
                          bottom: Radius.circular(4.0))
                      : null,
                  onTap: () => onTap(lecture),
                  onLongPress: () => onLongPress(lecture),
                )),
          ],
        ).toList(),
      ),
    );
  }
}
