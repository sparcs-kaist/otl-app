import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/classtime.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/widgets/timetable_block.dart';

class Timetable extends StatelessWidget {
  get _dividerHeight => dividerPadding.vertical + 1;

  final _daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"];
  final _lectures = List.generate(7, (i) => Map<Classtime, Lecture>());

  final TimetableBlock Function(Lecture) builder;
  final double fontSize;
  final EdgeInsetsGeometry dividerPadding;
  final int daysCount;

  Timetable(
      {List<Lecture> lectures,
      @required this.builder,
      this.fontSize = 9.0,
      this.dividerPadding =
          const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
      this.daysCount = 5}) {
    lectures.forEach((lecture) => lecture.classtimes
        .forEach((classtime) => _lectures[classtime.day][classtime] = lecture));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(daysCount + 1,
          (i) => (i == 0) ? _buildHeaders(context) : _buildColumn(i - 1)),
    );
  }

  Widget _buildHeader(int i) {
    if (i % 600 == 0) {
      return SizedBox(
        height: _dividerHeight,
        child: Text(
          (((i / 100 - 1) % 12) + 1).toStringAsFixed(0),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          ),
        ),
      );
    }

    if (i % 100 == 0) {
      return SizedBox(
        height: _dividerHeight,
        child: Text(
          (((i / 100 - 1) % 12) + 1).toStringAsFixed(0),
          style: TextStyle(fontSize: fontSize),
        ),
      );
    }

    return Padding(
      padding: dividerPadding,
      child: Container(color: BORDER_COLOR, height: 1),
    );
  }

  Widget _buildHeaders(BuildContext context) {
    final topPaddingWidget = SizedBox(
      width: 0,
      child: Text(
        "요일",
        maxLines: 1,
        style: TextStyle(fontSize: fontSize),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
            ((2400 - 900) / 50 + 2).toInt(),
            (i) =>
                (i == 0) ? topPaddingWidget : _buildHeader((i - 1) * 50 + 900)),
      ),
    );
  }

  Widget _buildLectureBlock(
      {@required Lecture lecture, @required Classtime classtime}) {
    final begin = classtime.begin / 30 - 16;
    final end = classtime.end / 30 - 16;

    return Positioned(
      top: _dividerHeight * (begin - 1.5) + 1,
      left: 0,
      right: 0,
      height: _dividerHeight * (end - begin) - 2,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: dividerPadding.horizontal / 3),
        child: builder(lecture),
      ),
    );
  }

  Widget _buildCell(int i) {
    if (i % 600 == 0) return Container(color: BORDER_BOLD_COLOR, height: 1);
    if (i % 100 == 0) return Container(color: BORDER_COLOR, height: 1);
    return Row(
      children: List.generate(
        20,
        (i) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Container(color: BORDER_COLOR, height: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildCells(int index) {
    return Column(
      children: List.generate(
          ((2400 - 900) / 50 + 1).toInt(),
          (i) => Padding(
                padding: dividerPadding,
                child: _buildCell(i * 50 + 900),
              )),
    );
  }

  Widget _buildColumn(int i) {
    final lectureBlocks = _lectures[i]
        .entries
        .map((e) => _buildLectureBlock(lecture: e.value, classtime: e.key))
        .toList();

    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            "${_daysOfWeek[i]}요일",
            style: TextStyle(fontSize: fontSize),
          ),
          Stack(children: [_buildCells(i)] + lectureBlocks),
        ],
      ),
    );
  }
}
