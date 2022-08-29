import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/models/semester.dart';
import 'package:otlplus/models/timetable.dart';
import 'package:otlplus/models/user.dart';
import 'package:otlplus/providers/info_model.dart';
import 'package:otlplus/widgets/timetable_block.dart';
import 'package:otlplus/widgets/today_timetable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/lecture.dart';

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

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTimetable(infoModel.user, semester, now),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Divider(color: DIVIDER_COLOR, height: 1.0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  child: _buildSchedule(now, infoModel.currentSchedule!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Divider(color: DIVIDER_COLOR, height: 1.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSchedule(DateTime now, Map<String, dynamic> currentSchedule) {
    late int days, hours, minutes;

    final timeDiff = currentSchedule["time"].difference(now) as Duration;
    days = timeDiff.inDays;
    hours = timeDiff.inHours - timeDiff.inDays * 24;
    minutes = timeDiff.inMinutes - timeDiff.inHours * 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 4.0),
        Text.rich(
          TextSpan(
            style: const TextStyle(fontSize: 12.0),
            children: <TextSpan>[
              TextSpan(
                // ignore: unnecessary_null_comparison
                text: (currentSchedule == null)
                    ? "정보 없음"
                    : "D-$days일 $hours시간 $minutes분",
                style: const TextStyle(fontSize: 18.0),
              ),
              const TextSpan(text: "\n"),
              TextSpan(
                text:
                    // ignore: unnecessary_null_comparison
                    (currentSchedule == null) ? "-" : currentSchedule["title"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const TextSpan(text: " "),
              TextSpan(
                // ignore: unnecessary_null_comparison
                text: (currentSchedule == null) ? "" : currentSchedule["name"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: " "),
              TextSpan(
                // ignore: unnecessary_null_comparison
                text: (currentSchedule == null)
                    ? ""
                    : DateFormat("yyyy.MM.dd")
                        .format(currentSchedule["time"].toLocal()),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: () => launchUrl(Uri.https("cais.kaist.ac.kr", "")),
              child: Text(
                "학사시스템 바로가기",
                style: const TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 11.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimetable(User user, Semester semester, DateTime now) {  
        List<Lecture> myLecturesList = user.myTimetableLectures
          .where((lecture) =>
              lecture.year == semester.year &&
              lecture.semester == semester.semester)
          .toList();
        Timetable timetable = Timetable(id: 0, lectures: myLecturesList);
        return Container(
          height: 90,
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TodayTimetable(
              lectures: timetable.lectures,
              now: now,
              builder: (lecture, classTimeIndex) => TimetableBlock(
                lecture: lecture,
                classTimeIndex: classTimeIndex,
              ),
            ),
          ),
        );
      }
}
