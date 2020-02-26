import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/review.dart';

class ReviewBlock extends StatelessWidget {
  final Review review;

  ReviewBlock(this.review);

  @override
  Widget build(BuildContext context) {
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
          Text(
            review.content.replaceAll("\n", "").trim(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              height: 1.3,
              fontSize: 11.0,
            ),
          ),
          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black87,
                height: 1.5,
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
