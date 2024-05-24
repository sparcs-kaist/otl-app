import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/providers/planner_model.dart';
import 'package:otlplus/providers/planner_model.dart';
import 'package:provider/provider.dart';

class PlannerSemester extends StatefulWidget {
  const PlannerSemester({Key? key}) : super(key: key);

  @override
  State<PlannerSemester> createState() => _PlannerSemesterState();
}

class _PlannerSemesterState extends State<PlannerSemester> {
  List name = ['전산학특강<안녕하세요>', '이산구조', '이산구조', '이산구조', '이산구조', '이산구조', '이산구조'];
  List category = ['전공필수', '전공필수', '전공필수', '전공필수', '전공필수', '전공필수', '전공필수'];
  List credit = [3, 3, 3, 3, 3, 3, 3];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final planners = Provider.of<PlannerModel>(context);

    if (planners.selectedSemesterKey == "") {
      return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: DataTable(
                dataTextStyle: labelRegular,
                headingTextStyle: labelBold,
                headingRowColor:
                    MaterialStateProperty.all<Color>(OTLColor.grayE),
                headingRowHeight: 40,
                dataRowMaxHeight: 40,
                dataRowMinHeight: 40,
                columnSpacing: 0,
                horizontalMargin: 0,
                columns: [
                  DataColumn(
                      label: Container(
                          width: width * .45,
                          child: Center(child: Text('과목명')))),
                  DataColumn(
                      label: Container(
                          width: width * .3, child: Center(child: Text('분류')))),
                  DataColumn(
                      label: Container(
                          width: width * .15,
                          child: Center(child: Text('학점')))),
                ],
                rows: []),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "학기를 선택하면\n해당학기에 수강/추가한\n과목을 볼 수 있습니다.",
                  style: labelRegular.copyWith(color: OTLColor.grayA),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "(수강 학점) ",
                      style: labelRegular.copyWith(color: OTLColor.grayA),
                    ),
                    Text(
                      "(미수강 학점)",
                      style: labelRegular.copyWith(color: OTLColor.pinksMain),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: DataTable(
          dataTextStyle: labelRegular,
          headingTextStyle: labelBold,
          headingRowColor: MaterialStateProperty.all<Color>(OTLColor.grayE),
          headingRowHeight: 40,
          dataRowMaxHeight: 40,
          dataRowMinHeight: 40,
          columnSpacing: 0,
          horizontalMargin: 0,
          columns: [
            DataColumn(
                label: Container(
                    width: width * .45, child: Center(child: Text('과목명')))),
            DataColumn(
                label: Container(
                    width: width * .3, child: Center(child: Text('분류')))),
            DataColumn(
                label: Container(
                    width: width * .15, child: Center(child: Text('학점')))),
          ],
          rows: makeLectureList(context)),
    );
  }

  List<DataRow> makeLectureList(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final planners = Provider.of<PlannerModel>(context);

    List<DataRow> lectureList = [];
    if (planners.lectures.containsKey(planners.selectedSemesterKey)) {
      for (int i = 0;
          i < planners.lectures[planners.selectedSemesterKey].length;
          i++) {
        lectureList.add(DataRow(cells: [
          DataCell(ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: width * .45), //SET max width
              child: Center(
                child: Text(
                  planners.lectures[planners.selectedSemesterKey][i].title,
                  overflow: TextOverflow.ellipsis,
                  style: labelRegular.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ))),
          DataCell(Center(
              child: Text(
                  planners.lectures[planners.selectedSemesterKey][i].type))),
          planners.lectures[planners.selectedSemesterKey][i].credit == 0
              ? DataCell(Center(
                  child: Text(planners
                          .lectures[planners.selectedSemesterKey][i].credit_au
                          .toString() +
                      'AU')))
              : DataCell(Center(
                  child: Text(planners
                      .lectures[planners.selectedSemesterKey][i].credit
                      .toString()))),
        ]));
      }
    }
    if (planners.lectures_excluded.containsKey(planners.selectedSemesterKey)) {
      for (int i = 0;
          i < planners.lectures_excluded[planners.selectedSemesterKey].length;
          i++) {
        lectureList.add(DataRow(cells: [
          DataCell(ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: width * .45), //SET max width
              child: Center(
                child: Text(
                  planners
                      .lectures_excluded[planners.selectedSemesterKey][i].title,
                  overflow: TextOverflow.ellipsis,
                  style: labelRegular.copyWith(
                      decoration: TextDecoration.underline,
                      color: OTLColor.grayA),
                ),
              ))),
          DataCell(Center(
              child: Text(planners
                  .lectures_excluded[planners.selectedSemesterKey][i].type))),
          planners.lectures_excluded[planners.selectedSemesterKey][i].credit ==
                  0
              ? DataCell(Center(
                  child: Text(planners
                          .lectures_excluded[planners.selectedSemesterKey][i]
                          .credit_au
                          .toString() +
                      'AU')))
              : DataCell(Center(
                  child: Text(planners
                      .lectures_excluded[planners.selectedSemesterKey][i].credit
                      .toString()))),
        ]));
      }
    }

    // lectureList.add(
    //   DataRow(
    //     cells:[
    //       DataCell(Text('합계')),
    //       DataCell(Text('합계')),
    //     ]
    //   )
    // );

    return lectureList;
  }
}
