import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/classtime.dart';
import 'package:otlplus/providers/timetable_model.dart';
import 'package:otlplus/widgets/planner_block.dart';
import 'package:otlplus/widgets/timetable_block.dart';
import 'package:provider/provider.dart';

import '../models/lecture.dart';
import '../models/time.dart';

const TYPES_SHORT = [
  "br",
  "be",
  "mr",
  "me",
  "hse",
  "etc",
];

class PlannerTable extends StatefulWidget {
  const PlannerTable({Key? key}) : super(key: key);

  @override
  State<PlannerTable> createState() => _PlannerTableState();
}

class _PlannerTableState extends State<PlannerTable> {
  List<String> semester = [
    '2021 봄',
    '2021 가을',
    '2022 봄',
    '2022 가을',
    '2023 봄',
    '2023 가을',
    '2024 봄',
  ];

  List<dynamic> lectures_all = [
    [{'title':'일반물리학1', 'typeIdx':0, 'credit': 3}, {'title':'일반화학', 'typeIdx':1, 'credit': 3}, {'title':'일반물리학', 'typeIdx':2, 'credit': 3},{'title':'일반물리학', 'typeIdx':4, 'credit': 3}, {'title':'일반물리학', 'typeIdx':5, 'credit': 3},],
    [],
    [{'title':'일반물리학', 'typeIdx':2, 'credit': 3}, {'title':'일반물리학', 'typeIdx':3, 'credit': 3}, {'title':'일반물리학', 'typeIdx':4, 'credit': 1}, {'title':'일반물리학', 'typeIdx':0, 'credit': 2}],
    [{'title':'일반물리학', 'typeIdx':0, 'credit': 3}, {'title':'일반물리학', 'typeIdx':0, 'credit': 3}],
    [{'title':'일반물리학', 'typeIdx':0, 'credit': 3}],
    [],
    [{'title':'일반물리학', 'typeIdx':0, 'credit': 3}],
  ];

  double get _dividerHeight => dividerPadding.vertical + 1;

  final _lectures = List.generate(7, (i) => Map<Time, Lecture>());
  // final TimetableBlock Function(Lecture, int, double) builder;

  final double fontSize = 10;
  final EdgeInsetsGeometry dividerPadding = const EdgeInsets.fromLTRB(0, 6, 0, 7);
  final int daysCount = 7;

  final _selectedKey = GlobalKey();
  final _paintKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    final lectures = context.select<TimetableModel, List<Lecture>>(
            (model) => model.currentTimetable.lectures);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 600,
        child: Row(
          children: List.generate(daysCount + 1, (i) => (i == 0) ? _buildHeaders() : _buildColumn(i - 1),),
        ),
      ),
    );
  }

  Widget _buildHeader(int i) {
    // if (i == 0){
    //   return SizedBox(
    //     height: _dividerHeight,
    //     child: Text(
    //       "0",
    //       textAlign: TextAlign.end,
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         fontSize: fontSize,
    //       ),
    //     ),
    //   );
    // }
    // if (i % 600 == 0) {
    //   return SizedBox(
    //     height: _dividerHeight,
    //     child: Text(
    //       "6",
    //       textAlign: TextAlign.end,
    //       style: TextStyle(
    //         fontWeight: FontWeight.bold,
    //         fontSize: fontSize,
    //       ),
    //     ),
    //   );
    // }

    if (i % 100 == 0) {
      return SizedBox(
        height: _dividerHeight,
        child: Text(
          "${(1700-i)~/100*3}",
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
        children: List.generate(((1700 - 900) / 50+2).toInt() , (i) {
          return _buildHeader(i * 50 + 900);
        }),
      ),
    );
  }

  // Widget _buildLectureBlock({required String title, required double idx, required int lectureType}) {
  //   return Positioned(
  //     top: idx,
  //     left: 0,
  //     right: 0,
  //     height: idx+10,
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(
  //         horizontal: dividerPadding.horizontal / 3,
  //       ),
  //       // child: builder(
  //       //   lecture,
  //       //   (time is Classtime) ? lecture.classtimes.indexOf(time) : 0,
  //       //   bottom - top,
  //       // ),
  //       child: PlannerBlock(
  //         lectureTitle: title,
  //         lectureType: lectureType
  //       )
  //     ),
  //   );
  // }

  Widget _buildCell(int i) {
    if (i % 100 == 0)
      return Container(color: OTLColor.gray0.withOpacity(0.25), height: 1);
    if (i % 50 == 0)
      return Row(
        children: List.generate(
          20,
              (i) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child:
              Container(color: OTLColor.gray0.withOpacity(0.25), height: 1),
            ),
          ),
        ),
      );
    return SizedBox();
  }

  Widget _buildCells() {
    return Column(
      children: List.generate(
          ((1700 - 900) / 25 + 1).toInt(),
              (i) => Padding(
            padding: dividerPadding,
            child: _buildCell(i * 25 + 900),
          )),
    );
  }

  Widget _buildColumn(int i) {
    int _index = 0;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 3),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                _buildCells(),

                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: lectures_all[i].length,
                    itemBuilder: (context, index) {
                      // return _buildLectureBlock(title: lectures_all[i][index]['title'], idx: index/1);
                      return PlannerBlock(
                        lectureTitle: lectures_all[i][index]['title'],
                        lectureType: lectures_all[i][index]['typeIdx'],
                        lectureCredit: lectures_all[i][index]['credit'],
                      );
                    }
                  ),
                )
                // ...lectures_all[i].map(
                //         (e) => _buildLectureBlock(title: e['title'], idx: _index)),
              ],
            ),
            Container(
              height: 20,
              // padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                semester[i],
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}