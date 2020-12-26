import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/dio_provider.dart';
import 'package:timeplanner_mobile/models/timetable.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';
import 'package:timeplanner_mobile/widgets/timetable_block.dart';
import 'package:timeplanner_mobile/widgets/today_timetable.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final infoModel = context.watch<InfoModel>();
    final semester = infoModel.semesters.firstWhere(
      (semester) =>
          semester.beginning.isBefore(now) && semester.end.isAfter(now),
      orElse: () => infoModel.semesters.last,
    );
    int days, hours, minutes;

    if (infoModel.currentSchedule != null) {
      final timeDiff =
          (infoModel.currentSchedule["time"] as DateTime).difference(now);
      days = timeDiff.inDays;
      hours = timeDiff.inHours - timeDiff.inDays * 24;
      minutes = timeDiff.inMinutes - timeDiff.inHours * 60;
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: <Widget>[
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
                  height: 90,
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: TodayTimetable(
                      lectures: snapshot.hasData ? timetable.lectures : [],
                      now: now,
                      builder: (lecture) => TimetableBlock(lecture: lecture),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Divider(
                color: DIVIDER_COLOR,
                height: 1.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 4.0),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13.0,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: infoModel.currentSchedule == null
                              ? "정보 없음"
                              : "D-$days일 $hours시간 $minutes분",
                          style: const TextStyle(fontSize: 20.0),
                        ),
                        const TextSpan(text: "\n"),
                        TextSpan(
                          text: infoModel.currentSchedule == null
                              ? "-"
                              : infoModel.currentSchedule["title"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const TextSpan(text: " "),
                        TextSpan(
                          text: infoModel.currentSchedule == null
                              ? ""
                              : infoModel.currentSchedule["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: " "),
                        TextSpan(
                          text: infoModel.currentSchedule == null
                              ? ""
                              : DateFormat("yyyy.MM.dd").format(
                                  infoModel.currentSchedule["time"].toLocal()),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          launch("https://cais.kaist.ac.kr");
                        },
                        child: const Text(
                          "학사시스템 바로가기",
                          style: TextStyle(
                            color: PRIMARY_COLOR,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: const Divider(
                color: DIVIDER_COLOR,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
