import 'package:easy_localization/easy_localization.dart';
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
const TYPES_SHORT = [
  "br",
  "be",
  "mr",
  "me",
  "hse",
  "etc",
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
    final titles = List.generate(
        6, (index) => 'timetable.summary.${TYPES_SHORT[index]}'.tr());

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
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.symmetric(
            horizontal: BorderSide(color: OTLColor.pinksLight)),
      ),
      child: Row(
        children: [
          Container(
            width: 150,
            padding: const EdgeInsets.only(right: 3),
            child: GridView.builder(
              itemCount: 6,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 6,
                mainAxisExtent: 45,
              ),
              itemBuilder: (_, index) => _buildAttribute(
                  titles[index], currentTypeCredit[index], tempType == index),
            ),
          ),
          _buildScore(
              'timetable.summary.credit'.tr(),
              allCreditCredit.toString(),
              tempLecture != null && tempLecture!.credit > 0),
          _buildScore("AU", allAuCredit.toString(),
              tempLecture != null && tempLecture!.creditAu > 0),
          _buildScore(
              'timetable.summary.grade'.tr(),
              targetNum > 0 ? LETTERS[(grade / targetNum).round()] : "?",
              tempLecture != null && tempLecture!.grade > 0),
          _buildScore(
              'timetable.summary.load'.tr(),
              targetNum > 0 ? LETTERS[(load / targetNum).round()] : "?",
              tempLecture != null && tempLecture!.load > 0),
          _buildScore(
              'timetable.summary.speech'.tr(),
              targetNum > 0 ? LETTERS[(speech / targetNum).round()] : "?",
              tempLecture != null && tempLecture!.speech > 0),
        ],
      ),
    );
  }

  Widget _buildScore(String title, String content, bool highlight) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 26,
            child: Text(
              content,
              style: titleBold.copyWith(
                  color: highlight ? OTLColor.pinksMain : OTLColor.gray0),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 17,
            child: Text(
              title,
              style: labelRegular.copyWith(
                  color: highlight ? OTLColor.pinksMain : OTLColor.gray0),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
            style: labelBold.copyWith(
                color: highlight ? OTLColor.pinksMain : OTLColor.gray0),
          ),
        ),
        SizedBox(
          width: 17,
          child: Text(
            value.toString(),
            style: labelRegular.copyWith(
                color: highlight ? OTLColor.pinksMain : OTLColor.gray0),
          ),
        ),
      ],
    );
  }
}
