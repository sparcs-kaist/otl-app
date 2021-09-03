import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/extensions/lecture.dart';
import 'package:otlplus/models/lecture.dart';

class LectureGroupBlockRow extends StatelessWidget {
  final Lecture lecture;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final bool? isSelected;

  LectureGroupBlockRow(
      {required this.lecture,
      required this.onTap,
      this.onLongPress,
      this.borderRadius,
      this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: borderRadius,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ?? false ? SELECTED_COLOR : null,
            borderRadius: borderRadius,
          ),
          padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
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
