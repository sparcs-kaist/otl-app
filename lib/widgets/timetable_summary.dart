import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/models/lecture.dart';

const TYPES = [
  "Basic Required",
  "Basic Elective",
  "Major Required",
  "Major Elective",
  "Humanities & Social Elective",
];
const LETTERS = [
  "?",
  "F",
  "F",
  "F",
  "D-",
  "D",
  "D+",
  "C-",
  "C",
  "C+",
  "B-",
  "B",
  "B+",
  "A-",
  "A",
  "A+",
];

class TimetableSummary extends StatelessWidget {
  final List<Lecture> lectures;

  TimetableSummary(this.lectures);

  int _indexOfType(String type) {
    final index = TYPES.indexOf(type);
    return index == -1 ? 5 : index;
  }

  @override
  Widget build(BuildContext context) {
    final currentTypeCredit = List.generate(
        6,
        (i) => lectures
            .where((lecture) => _indexOfType(lecture.typeEn) == i)
            .fold<int>(
                0, (acc, lecture) => acc + lecture.credit + lecture.creditAu));
    final allCreditCredit =
        lectures.fold<int>(0, (acc, lecture) => acc + lecture.credit);
    final allAuCredit =
        lectures.fold<int>(0, (acc, lecture) => acc + lecture.creditAu);
    final targetNum = lectures.fold<int>(
        0,
        (acc, lecture) =>
            acc +
            (lecture.hasReview ? (lecture.credit + lecture.creditAu) : 0));
    final grade = lectures.fold<double>(
        0,
        (acc, lecture) =>
            acc +
            (lecture.hasReview
                ? (lecture.grade * (lecture.credit + lecture.creditAu))
                : 0));
    final load = lectures.fold<double>(
        0,
        (acc, lecture) =>
            acc +
            (lecture.hasReview
                ? (lecture.load * (lecture.credit + lecture.creditAu))
                : 0));
    final speech = lectures.fold<double>(
        0,
        (acc, lecture) =>
            acc +
            (lecture.hasReview
                ? (lecture.speech * (lecture.credit + lecture.creditAu))
                : 0));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildAttributes(
            ["기필", "기선"], [currentTypeCredit[0], currentTypeCredit[1]]),
        _buildAttributes(
            ["전필", "전선"], [currentTypeCredit[2], currentTypeCredit[3]]),
        _buildAttributes(
            ["인선", "기타"], [currentTypeCredit[4], currentTypeCredit[5]]),
        _buildScore("학점", allCreditCredit.toString()),
        _buildScore("AU", allAuCredit.toString()),
        _buildScore(
            "성적", targetNum > 0 ? LETTERS[(grade / targetNum).round()] : "?"),
        _buildScore(
            "널널", targetNum > 0 ? LETTERS[(load / targetNum).round()] : "?"),
        _buildScore(
            "강의", targetNum > 0 ? LETTERS[(speech / targetNum).round()] : "?"),
      ],
    );
  }

  Widget _buildScore(String title, String content) {
    return SizedBox(
      width: 32,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 11.0,
          ),
          children: <TextSpan>[
            TextSpan(
              text: content,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            TextSpan(text: "\n$title"),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributes(List<String> titles, List<int> values) {
    return SizedBox(
      width: 48,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black87,
            height: 1.5,
            fontSize: 13.0,
          ),
          children: <TextSpan>[
            TextSpan(
              text: "${titles[0]} ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: values[0].toString()),
            TextSpan(text: "\n"),
            TextSpan(
              text: "${titles[1]} ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: values[1].toString()),
          ],
        ),
      ),
    );
  }
}
