import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/review.dart';

class ReviewBlock extends StatelessWidget {
  final Review review;
  final int maxLines;
  final TextOverflow overflow;
  final bool isSimple;

  ReviewBlock(
      {@required this.review,
      this.maxLines,
      this.overflow,
      this.isSimple = false});

  @override
  Widget build(BuildContext context) {
    String content = isSimple
        ? review.content.replaceAll("\r\n", " ").replaceAll("\n", " ")
        : review.content;
    while (content.contains("  ")) content = content.replaceAll("  ", " ");

    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: BLOCK_COLOR,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          isSimple
              ? const SizedBox.shrink()
              : RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: review.lecture.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: " "),
                      TextSpan(text: review.lecture.professorsStrShort),
                      const TextSpan(text: " "),
                      TextSpan(text: review.lecture.year.toString()),
                      TextSpan(
                          text: [
                        " ",
                        " 봄",
                        " 여름",
                        " 가을",
                        " 겨울",
                      ][review.lecture.semester]),
                    ],
                  ),
                ),
          isSimple ? const SizedBox.shrink() : const SizedBox(height: 4.0),
          Text(
            content.trim(),
            maxLines: maxLines,
            overflow: overflow,
            style: const TextStyle(
              color: const Color(0xFF555555),
              height: 1.25,
              fontSize: 12.0,
            ),
          ),
          RichText(
            textAlign: isSimple ? TextAlign.end : TextAlign.start,
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black87,
                height: 1.8,
                fontSize: 13.0,
              ),
              children: <TextSpan>[
                TextSpan(text: "추천 "),
                TextSpan(
                  text: review.like.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: "  성적 "),
                TextSpan(
                  text: review.gradeLetter,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: "  널널 "),
                TextSpan(
                  text: review.loadLetter,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: "  강의 "),
                TextSpan(
                  text: review.speechLetter,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
