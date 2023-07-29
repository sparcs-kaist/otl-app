import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/lecture.dart';

class LectureSimpleBlock extends StatelessWidget {
  final Lecture lecture;
  final bool hasReview;
  final VoidCallback? onTap;

  LectureSimpleBlock(
      {required this.lecture, this.hasReview = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6.0, bottom: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: OTLColor.grayE,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 8.0,
            ),
            child: Center(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                      color: hasReview
                          ? OTLColor.gray3.withOpacity(0.4)
                          : OTLColor.gray3,
                      fontSize: 12.0),
                  children: <TextSpan>[
                    TextSpan(
                      text: lecture.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: "\n"),
                    TextSpan(text: lecture.oldCode),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
