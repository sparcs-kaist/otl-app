import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/classtime.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/models/time.dart';
import 'package:otlplus/widgets/timetable_block.dart';

class TodayTimetable extends StatelessWidget {
  double get _dividerWidth => dividerPadding.horizontal + 1;

  final _timebarKey = GlobalKey();
  final _lectures = Map<Time, Lecture>();

  final TimetableBlock Function(Lecture, int) builder;
  final DateTime now;
  final double fontSize;
  final EdgeInsetsGeometry dividerPadding;
  final int? daysCount;

  TodayTimetable(
      {required List<Lecture> lectures,
      required this.builder,
      required this.now,
      this.fontSize = 10.0,
      this.dividerPadding = const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 1.0,
      ),
      this.daysCount}) {
    lectures.forEach((lecture) => lecture.classtimes.forEach((classtime) {
          if (classtime.day == now.weekday - 1) _lectures[classtime] = lecture;
        }));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_timebarKey.currentContext != null)
        Scrollable.ensureVisible(_timebarKey.currentContext!);
    });

    return Column(
      children: <Widget>[
        _buildHeaders(),
        _buildRow(),
      ],
    );
  }

  Widget _buildHeader(int i) {
    if (i % 600 == 0) {
      return SizedBox(
        width: _dividerWidth,
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
        width: _dividerWidth,
        child: Text(
          (((i / 100 - 1) % 12) + 1).toStringAsFixed(0),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize),
        ),
      );
    }

    return Padding(
      padding: dividerPadding,
      child: Container(color: BORDER_COLOR, width: 1),
    );
  }

  Widget _buildHeaders() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
            ((2400 - 900) / 50 + 1).toInt(), (i) => _buildHeader(i * 50 + 900)),
      ),
    );
  }

  Widget _buildLectureBlock({required Lecture lecture, required Time time}) {
    final begin = time.begin / 30 - 18;
    final end = time.end / 30 - 18;

    return Positioned(
      top: 0,
      left: _dividerWidth * (begin + 0.5) + 1,
      bottom: 0,
      width: _dividerWidth * (end - begin) - 2,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: dividerPadding.vertical / 3,
        ),
        child: builder(lecture,
            (time is Classtime) ? lecture.classtimes.indexOf(time) : 0),
      ),
    );
  }

  Widget _buildCell(int i) {
    if (i % 600 == 0) return Container(color: BORDER_BOLD_COLOR, width: 1);
    if (i % 100 == 0) return Container(color: BORDER_COLOR, width: 1);
    return Column(
      children: List.generate(
        15,
        (i) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Container(color: BORDER_COLOR, width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildCells() {
    return Row(
      children: List.generate(
          ((2400 - 900) / 50 + 1).toInt(),
          (i) => Padding(
                padding: dividerPadding,
                child: _buildCell(i * 50 + 900),
              )),
    );
  }

  Widget _buildRow() {
    return Expanded(
      child: Stack(
        children: <Widget>[
          _buildCells(),
          ..._lectures.entries
              .map((e) => _buildLectureBlock(lecture: e.value, time: e.key)),
          Positioned(
            top: 0,
            left: _dividerWidth * ((now.hour + now.minute / 60) * 2 - 17.5),
            bottom: 0,
            width: 1,
            child: Container(key: _timebarKey, color: PRIMARY_COLOR),
          ),
        ],
      ),
    );
  }
}
