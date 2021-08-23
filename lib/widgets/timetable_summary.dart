import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/lecture.dart';

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
  final Lecture tempLecture;

  TimetableSummary({@required this.lectures, this.tempLecture});

  int _indexOfType(String type) {
    final index = TYPES.indexOf(type);
    return index == -1 ? 5 : index;
  }

  @override
  Widget build(BuildContext context) {
    List<int> currentTypeCredit = List.generate(
        6,
        (i) => lectures
            .where((lecture) => _indexOfType(lecture.typeEn) == i)
            .fold<int>(
                0, (acc, lecture) => acc + lecture.credit + lecture.creditAu));
    int allCreditCredit =
        lectures.fold<int>(0, (acc, lecture) => acc + lecture.credit);
    int allAuCredit =
        lectures.fold<int>(0, (acc, lecture) => acc + lecture.creditAu);
    int targetNum = lectures.fold(
        0,
        (acc, lecture) =>
            acc +
            ((lecture.reviewTotalWeight > 0)
                ? (lecture.credit + lecture.creditAu)
                : 0));
    double grade = lectures.fold(
        0,
        (acc, lecture) =>
            acc +
            ((lecture.reviewTotalWeight > 0)
                ? (lecture.grade * (lecture.credit + lecture.creditAu))
                : 0));
    double load = lectures.fold(
        0,
        (acc, lecture) =>
            acc +
            ((lecture.reviewTotalWeight > 0)
                ? (lecture.load * (lecture.credit + lecture.creditAu))
                : 0));
    double speech = lectures.fold(
        0,
        (acc, lecture) =>
            acc +
            ((lecture.reviewTotalWeight > 0)
                ? (lecture.speech * (lecture.credit + lecture.creditAu))
                : 0));
    final tempType =
        (tempLecture == null) ? 6 : _indexOfType(tempLecture.typeEn);

    if (tempLecture != null) {
      currentTypeCredit[tempType] +=
          (tempLecture.credit + tempLecture.creditAu);
      allCreditCredit += tempLecture.credit;
      allAuCredit += tempLecture.creditAu;
      targetNum += ((tempLecture.reviewTotalWeight > 0)
          ? (tempLecture.credit + tempLecture.creditAu)
          : 0);
      grade += ((tempLecture.reviewTotalWeight > 0)
          ? (tempLecture.grade * (tempLecture.credit + tempLecture.creditAu))
          : 0);
      load += ((tempLecture.reviewTotalWeight > 0)
          ? (tempLecture.load * (tempLecture.credit + tempLecture.creditAu))
          : 0);
      speech += ((tempLecture.reviewTotalWeight > 0)
          ? (tempLecture.speech * (tempLecture.credit + tempLecture.creditAu))
          : 0);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildAttributes(
            ["기필", "기선"],
            [currentTypeCredit[0], currentTypeCredit[1]],
            [tempType == 0, tempType == 1]),
        _buildAttributes(
            ["전필", "전선"],
            [currentTypeCredit[2], currentTypeCredit[3]],
            [tempType == 2, tempType == 3]),
        _buildAttributes(
            ["인선", "기타"],
            [currentTypeCredit[4], currentTypeCredit[5]],
            [tempType == 4, tempType == 5]),
        _buildScore("학점", allCreditCredit.toString(),
            tempLecture != null && tempLecture.credit > 0),
        _buildScore("AU", allAuCredit.toString(),
            tempLecture != null && tempLecture.creditAu > 0),
        _buildScore(
            "성적",
            targetNum > 0 ? LETTERS[(grade / targetNum).round()] : "?",
            tempLecture != null && tempLecture.grade > 0),
        _buildScore(
            "널널",
            targetNum > 0 ? LETTERS[(load / targetNum).round()] : "?",
            tempLecture != null && tempLecture.load > 0),
        _buildScore(
            "강의",
            targetNum > 0 ? LETTERS[(speech / targetNum).round()] : "?",
            tempLecture != null && tempLecture.speech > 0),
      ],
    );
  }

  Widget _buildScore(String title, String content, bool highlight) {
    return SizedBox(
      width: 32,
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            color: highlight
                ? const Color(0xFFE05469).withOpacity(0.9)
                : CONTENT_COLOR,
            fontSize: 10.0,
          ),
          children: <TextSpan>[
            TextSpan(
              text: content,
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            TextSpan(text: "\n$title"),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAttributes(
      List<String> titles, List<int> values, List<bool> highlights) {
    return SizedBox(
      width: 48,
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
            height: 1.5,
            fontSize: 12.0,
          ),
          children: <TextSpan>[
            TextSpan(
              text: "${titles[0]} ",
              style: TextStyle(
                  color: highlights[0]
                      ? const Color(0xFFE05469).withOpacity(0.9)
                      : CONTENT_COLOR,
                  fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: values[0].toString(),
              style: TextStyle(
                color: highlights[0]
                    ? const Color(0xFFE05469).withOpacity(0.9)
                    : CONTENT_COLOR,
              ),
            ),
            const TextSpan(text: "\n"),
            TextSpan(
              text: "${titles[1]} ",
              style: TextStyle(
                  color: highlights[1]
                      ? const Color(0xFFE05469).withOpacity(0.9)
                      : CONTENT_COLOR,
                  fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: values[1].toString(),
              style: TextStyle(
                color: highlights[1]
                    ? const Color(0xFFE05469).withOpacity(0.9)
                    : CONTENT_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
