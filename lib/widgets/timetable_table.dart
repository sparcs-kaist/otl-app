import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/widgets/timetable_block.dart';

class TimetableTable extends StatelessWidget {
  final _daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"];
  final List<TimetableBlock> lectureBlocks;
  final double fontSize;
  final double dividerGap;
  final int daysCount;

  TimetableTable(
      {this.lectureBlocks,
      this.fontSize = 11.0,
      this.dividerGap = 7.0,
      this.daysCount = 5});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          children: <Widget>[_buildHeaders(context)] +
              List.generate(daysCount, (i) => _buildCells(i)),
        ),
      ],
    );
  }

  Widget _buildHeader(int i) {
    if (i == 800 || i % 600 == 0) {
      return SizedBox(
        height: dividerGap * 2 + 1,
        child: Text(
          (((i / 100 - 1) % 12) + 1).toStringAsFixed(0),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
      );
    }

    if (i % 100 == 0) {
      return SizedBox(
        height: dividerGap * 2 + 1,
        child: Text(
          (((i / 100 - 1) % 12) + 1).toStringAsFixed(0),
          style: TextStyle(fontSize: fontSize),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: dividerGap),
      child: Container(color: BORDER_COLOR, height: 1),
    );
  }

  Widget _buildHeaders(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
              SizedBox(
                width: 0,
                child: Text(
                  "요일",
                  maxLines: 1,
                  style: TextStyle(fontSize: fontSize),
                ),
              )
            ] +
            List<Widget>.generate(((2400 - 800) / 50 + 1).toInt(), (i) {
              return _buildHeader(i * 50 + 800);
            }),
      ),
    );
  }

  Widget _buildCell(int i) {
    if (i == 800 || i % 600 == 0) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: dividerGap),
        child: Container(color: BORDER_BOLD_COLOR, height: 1),
      );
    }

    if (i % 100 == 0) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: dividerGap),
        child: Container(color: BORDER_COLOR, height: 1),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: dividerGap),
      child: Row(
        children: List.generate(
          20,
          (i) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: Container(color: BORDER_COLOR, height: 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCells(int index) {
    return Expanded(
      child: Column(
        children: <Widget>[
              Text(
                "${_daysOfWeek[index]}요일",
                style: TextStyle(fontSize: fontSize),
              )
            ] +
            List.generate(((2400 - 800) / 50 + 1).toInt(),
                (i) => _buildCell(i * 50 + 800)),
      ),
    );
  }
}
