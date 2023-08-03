import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/widgets/lecture_group_block_row.dart';

class LectureGroupBlock extends StatelessWidget {
  final List<Lecture> lectures;
  final void Function(Lecture) onLongPress;

  LectureGroupBlock({required this.lectures, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    if (lectures.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 6.0),
        padding: const EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: OTLColor.grayE,
        ),
        child: const Text("There is no lecture."),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: ColoredBox(
        color: const Color(0xFFEEEEEE),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            lectures.first.commonTitle,
                            style: const TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            lectures.first.oldCode,
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
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
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: SizedBox(
                    height: 1,
                    child: ColoredBox(
                      color: Color(0xFFDADADA),
                    ),
                  ),
                ),
                ...lectures.map((lecture) => LectureGroupBlockRow(
                      lecture: lecture,
                      onLongPress: () => onLongPress(lecture),
                    )),
              ]),
        ),
      ),
    );
  }
}
