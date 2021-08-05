import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/classtime.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/models/time.dart';
import 'package:otlplus/widgets/timetable_block.dart';

const DAYSOFWEEK = [
  "월요일",
  "화요일",
  "수요일",
  "목요일",
  "금요일",
  "토요일",
  "일요일",
];

class Timetable extends StatelessWidget {
  double get _dividerHeight => dividerPadding.vertical + 1;

  final _lectures = List.generate(7, (i) => Map<Time, Lecture>());

  final TimetableBlock Function(Lecture, int) builder;
  final double fontSize;
  final EdgeInsetsGeometry dividerPadding;
  final int daysCount;

  Timetable(
      {@required List<Lecture> lectures,
      @required this.builder,
      bool isExamTime = false,
      this.fontSize = 10.0,
      this.dividerPadding = const EdgeInsets.symmetric(
        horizontal: 1.0,
        vertical: 10.0,
      ),
      this.daysCount = 5}) {
    if (isExamTime) {
      lectures.forEach((lecture) => lecture.examtimes
          .forEach((examtime) => _lectures[examtime.day][examtime] = lecture));
    } else {
      lectures.forEach((lecture) => lecture.classtimes.forEach(
          (classtime) => _lectures[classtime.day][classtime] = lecture));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(daysCount + 1,
          (i) => (i == 0) ? _buildHeaders() : _buildColumn(i - 1)),
    );
  }

  Widget _buildHeader(int i) {
    if (i % 600 == 0) {
      return SizedBox(
        height: _dividerHeight,
        child: Text(
          (((i / 100 - 1) % 12) + 1).toStringAsFixed(0),
          textAlign: TextAlign.center,
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
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize),
        ),
      );
    }

    return Padding(
      padding: dividerPadding,
      child: Container(color: BORDER_COLOR, height: 1),
    );
  }

  Widget _buildHeaders() {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(((2400 - 900) / 50 + 2).toInt(), (i) {
          if (i > 0) return _buildHeader((i - 1) * 50 + 900);
          return Padding(
            padding: EdgeInsets.only(bottom: dividerPadding.vertical / 2),
            child: SizedBox(
              width: 0,
              child: Text(
                "요일",
                maxLines: 1,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLectureBlock({@required Lecture lecture, @required Time time}) {
    final begin = time.begin / 30 - 18;
    final end = time.end / 30 - 18;

    return Positioned(
      top: _dividerHeight * (begin + 0.5) + 1,
      left: 0,
      right: 0,
      height: _dividerHeight * (end - begin) - 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dividerPadding.horizontal / 3,
        ),
        child: builder(lecture,
            (time is Classtime) ? lecture.classtimes.indexOf(time) : 0),
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

  Widget _buildCells() {
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
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            DAYSOFWEEK[i],
            style: TextStyle(fontSize: fontSize),
          ),
          Stack(
            children: <Widget>[
              _buildCells(),
              ..._lectures[i].entries.map(
                  (e) => _buildLectureBlock(lecture: e.value, time: e.key)),
            ],
          ),
        ],
      ),
    );
  }
}
