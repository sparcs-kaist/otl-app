import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
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
  final Lecture? tempLecture;

  TimetableSummary({required this.lectures, this.tempLecture});

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
        (tempLecture == null) ? 6 : _indexOfType(tempLecture!.typeEn);
    final titles = ['기필', '기선', '전필', '전선', '인선', '기타'];

    if (tempLecture != null) {
      currentTypeCredit[tempType] +=
          (tempLecture!.credit + tempLecture!.creditAu);
      allCreditCredit += tempLecture!.credit;
      allAuCredit += tempLecture!.creditAu;
      targetNum += ((tempLecture!.reviewTotalWeight > 0)
          ? (tempLecture!.credit + tempLecture!.creditAu)
          : 0);
      grade += ((tempLecture!.reviewTotalWeight > 0)
          ? (tempLecture!.grade * (tempLecture!.credit + tempLecture!.creditAu))
          : 0);
      load += ((tempLecture!.reviewTotalWeight > 0)
          ? (tempLecture!.load * (tempLecture!.credit + tempLecture!.creditAu))
          : 0);
      speech += ((tempLecture!.reviewTotalWeight > 0)
          ? (tempLecture!.speech *
              (tempLecture!.credit + tempLecture!.creditAu))
          : 0);
    }

    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: pinksLight)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 164,
            height: 38,
            child: GridView.builder(
              itemCount: 6,
              padding: const EdgeInsets.only(right: 6),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 16,
                mainAxisExtent: 17,
              ),
              itemBuilder: (_, index) => _buildAttribute(
                  titles[index], currentTypeCredit[index], tempType == index),
            ),
          ),
          const SizedBox(width: 11),
          _buildScore("학점", allCreditCredit.toString(),
              tempLecture != null && tempLecture!.credit > 0),
          _buildScore("AU", allAuCredit.toString(),
              tempLecture != null && tempLecture!.creditAu > 0),
          const SizedBox(width: 11),
          _buildScore(
              "성적",
              targetNum > 0 ? LETTERS[(grade / targetNum).round()] : "?",
              tempLecture != null && tempLecture!.grade > 0),
          _buildScore(
              "널널",
              targetNum > 0 ? LETTERS[(load / targetNum).round()] : "?",
              tempLecture != null && tempLecture!.load > 0),
          _buildScore(
              "강의",
              targetNum > 0 ? LETTERS[(speech / targetNum).round()] : "?",
              tempLecture != null && tempLecture!.speech > 0),
        ],
      ),
    );
  }

  Widget _buildScore(String title, String content, bool highlight) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: SizedBox(
        width: 28,
        child: Column(
          children: [
            Expanded(
              child: Text(
                content,
                style: titleBold,
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              title,
              style: labelRegular,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttribute(String title, int value, bool highlight) {
    return Row(
      children: [
        SizedBox(
          width: 28,
          child: Text(
            title,
            style: labelBold.copyWith(color: highlight ? pinksMain : gray0),
          ),
        ),
        SizedBox(
          width: 14,
          child: Text(
            value.toString(),
            style: labelRegular.copyWith(color: highlight ? pinksMain : gray0),
          ),
        ),
      ],
    );
  }
}
