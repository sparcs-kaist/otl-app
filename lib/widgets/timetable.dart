import 'package:easy_localization/easy_localization.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/classtime.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/models/time.dart';
import 'package:otlplus/widgets/timetable_block.dart';
import 'package:otlplus/models/custom_block.dart';
import 'package:otlplus/widgets/custom_block_tile.dart';

const DAYSOFWEEK = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

class Timetable extends StatelessWidget {
  double get _dividerHeight => dividerPadding.vertical + 1;

  final _lectures = List.generate(7, (i) => Map<Time, Lecture>());

  final TimetableBlock Function(Lecture, int, double) builder;
  final double fontSize;
  final EdgeInsetsGeometry dividerPadding;
  final int daysCount;
  final List<CustomBlock> customBlocks;
  final void Function(CustomBlock)? onCustomBlockTap;
  int get _startHour =>
      customBlocks.fold(9, (hour, block) => math.min(hour, block.begin ~/ 60));

  Timetable({
    required List<Lecture> lectures,
    required this.builder,
    bool isExamTime = false,
    this.fontSize = 10.0,
    this.dividerPadding = const EdgeInsets.fromLTRB(0, 6, 0, 7),
    int daysCount = 5,
    List<CustomBlock> customBlocks = const [],
    this.onCustomBlockTap,
  }) : customBlocks = isExamTime ? const [] : customBlocks,
       daysCount = isExamTime
           ? daysCount
           : customBlocks.fold(
               daysCount,
               (days, block) => math.max(days, block.day + 1),
             ) {
    if (isExamTime) {
      lectures.forEach(
        (lecture) => lecture.examtimes.forEach(
          (examtime) => _lectures[examtime.day.code][examtime] = lecture,
        ),
      );
    } else {
      lectures.forEach(
        (lecture) => lecture.classtimes.forEach(
          (classtime) => _lectures[classtime.day.code][classtime] = lecture,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        daysCount + 1,
        (i) => (i == 0) ? _buildHeaders() : _buildColumn(i - 1),
      ),
    );
  }

  Widget _buildHeader(int i) {
    if (i % 600 == 0) {
      return SizedBox(
        height: _dividerHeight,
        child: Text(
          (((i / 100 - 1) % 12) + 1).toStringAsFixed(0),
          textAlign: TextAlign.end,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
      );
    }

    if (i % 100 == 0) {
      return SizedBox(
        height: _dividerHeight,
        child: Text(
          (((i / 100 - 1) % 12) + 1).toStringAsFixed(0),
          textAlign: TextAlign.end,
          style: TextStyle(fontSize: fontSize),
        ),
      );
    }

    return SizedBox(height: _dividerHeight * 3 - 2);
  }

  Widget _buildHeaders() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 4, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          ((2400 - _startHour * 100) / 50 + 2).toInt() - 1,
          (i) {
            return _buildHeader(i * 50 + _startHour * 100);
          },
        ),
      ),
    );
  }

  Widget _buildLectureBlock({required Lecture lecture, required Time time}) {
    final begin = time.begin / 30 - _startHour * 2;
    final end = time.end / 30 - _startHour * 2;
    final top = _dividerHeight * (2 * begin + 0.5) + 1 - begin;
    final bottom = _dividerHeight * (2 * end + 0.5) + 1 - end - 3;

    return Positioned(
      top: top,
      left: 0,
      right: 0,
      height: bottom - top,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dividerPadding.horizontal / 3,
        ),
        child: builder(
          lecture,
          (time is Classtime) ? lecture.classtimes.indexOf(time) : 0,
          bottom - top,
        ),
      ),
    );
  }

  Widget _buildCell(int i) {
    if (i % 100 == 0) return Container(color: OTLColor.divider, height: 1);
    if (i % 50 == 0)
      return Row(
        children: List.generate(
          20,
          (i) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: Container(color: OTLColor.divider, height: 1),
            ),
          ),
        ),
      );
    return SizedBox();
  }

  Widget _buildCustomBlock(CustomBlock block) {
    final begin = block.begin / 30 - _startHour * 2;
    final end = block.end / 30 - _startHour * 2;
    return Positioned(
      top: _dividerHeight * (2 * begin + 0.5) + 1 - begin,
      left: 0,
      right: 0,
      height: math.max(1, (end - begin) * (_dividerHeight * 2 - 1) - 3),
      child: CustomBlockTile(
        block: block,
        onTap: onCustomBlockTap == null ? null : () => onCustomBlockTap!(block),
      ),
    );
  }

  Widget _buildCells() {
    return Column(
      children: List.generate(
        ((2400 - _startHour * 100) / 25 + 1).toInt(),
        (i) => Padding(
          padding: dividerPadding,
          child: _buildCell(i * 25 + _startHour * 100),
        ),
      ),
    );
  }

  Widget _buildColumn(int i) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 3),
        child: Column(
          children: <Widget>[
            Container(
              height: 20,
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                'timetable.days.${DAYSOFWEEK[i]}'.tr(),
                style: TextStyle(fontSize: 12),
              ),
            ),
            Stack(
              children: <Widget>[
                _buildCells(),
                ..._lectures[i].entries.map(
                  (e) => _buildLectureBlock(lecture: e.value, time: e.key),
                ),
                ...customBlocks
                    .where((block) => block.day == i)
                    .map(_buildCustomBlock),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
