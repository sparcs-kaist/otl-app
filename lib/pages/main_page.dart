import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/dio_provider.dart';
import 'package:timeplanner_mobile/models/semester.dart';
import 'package:timeplanner_mobile/models/timetable.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';
import 'package:timeplanner_mobile/widgets/timetable_block.dart';
import 'package:timeplanner_mobile/widgets/today_timetable.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final semester = context
        .select<InfoModel, Semester>((model) => model.semesters.firstWhere(
              (semester) =>
                  semester.beginning.isBefore(now) && semester.end.isAfter(now),
              orElse: () => model.semesters.last,
            ));

    return Container(
      transform: Matrix4.translationValues(0, -51, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset("assets/bg.4556cdee.jpg"),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: SHADOW_COLOR,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(12.0),
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    style: const TextStyle(fontSize: 14.0),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(),
                      isDense: true,
                      hintText: "검색",
                      hintStyle: TextStyle(
                        color: PRIMARY_COLOR,
                        fontSize: 14.0,
                      ),
                      icon: Icon(
                        Icons.search,
                        color: PRIMARY_COLOR,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder<Response>(
              future: semester == null
                  ? null
                  : DioProvider().dio.post(API_TIMETABLE_LOAD_URL, data: {
                      "year": semester.year,
                      "semester": semester.semester,
                    }),
              builder: (context, snapshot) {
                Timetable timetable;

                if (snapshot.hasData) {
                  final rawTimetables = snapshot.data.data as List;
                  timetable = Timetable.fromJson(rawTimetables.first);
                }

                return Container(
                  height: 110,
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: TodayTimetable(
                          lectures: snapshot.hasData ? timetable.lectures : [],
                          now: now,
                          builder: (lecture) =>
                              TimetableBlock(lecture: lecture),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
