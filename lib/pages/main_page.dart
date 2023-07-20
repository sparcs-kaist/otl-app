import 'package:flutter/material.dart';
import 'package:otlplus/constants/text_styles.dart';
<<<<<<< HEAD
import 'package:otlplus/utils/build_page_route.dart';
=======
>>>>>>> e08b898 (add colorstyles, textstyles and refactor main_page.dart)
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/semester.dart';
import 'package:otlplus/models/timetable.dart';
import 'package:otlplus/models/user.dart';
import 'package:otlplus/providers/info_model.dart';
import 'package:otlplus/widgets/timetable_block.dart';
import 'package:otlplus/widgets/today_timetable.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/lecture.dart';

class MainPage extends StatelessWidget {
  static String route = 'main_page';

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
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: <Widget>[
                  _buildTimetable(infoModel.user, semester, now),
                  const SizedBox(height: 24.0),
<<<<<<< HEAD
                  _buildDivider(),
                  const SizedBox(height: 24.0),
                  _buildSchedule(now, infoModel.currentSchedule!),
                  const SizedBox(height: 24.0),
                  _buildDivider(),
=======
                  const Divider(color: grayD, height: 1.0),
                  const SizedBox(height: 24.0),
                  _buildSchedule(now, infoModel.currentSchedule!),
                  const SizedBox(height: 24.0),
                  const Divider(color: grayD, height: 1.0),
>>>>>>> e08b898 (add colorstyles, textstyles and refactor main_page.dart)
                ],
              ),
              Column(
                children: <Widget>[
<<<<<<< HEAD
                  _buildLogo(),
                  const SizedBox(height: 4.0),
                  _buildCopyRight(),
                  _buildTextButtons(context),
=======
                  _buildTextButtons(),
                  // const SizedBox(height: 8.0),
                  _buildLogo(),
                  const SizedBox(height: 8.0),
                  _buildCopyRight(),
>>>>>>> e08b898 (add colorstyles, textstyles and refactor main_page.dart)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: gray0.withOpacity(0.25));
  }

  Widget _buildTextButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(context, buildPrivacyPageRoute());
          },
          child: Text(
            '개인정보취급방침',
            style: labelRegular.copyWith(color: gray75),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context, buildPeoplePageRoute());
          },
          child: Text(
            '만든 사람들',
            style: labelRegular.copyWith(color: gray75),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      "assets/sparcs.png",
      height: 27,
    );
  }

  Widget _buildCopyRight() {
    return Text(
      '© 2016-2023 SPARCS OTL Team',
      style: labelRegular.copyWith(color: gray75),
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
        Text.rich(
          TextSpan(
            style: bodyRegular,
            children: <TextSpan>[
              TextSpan(
                style: titleRegular,
                // ignore: unnecessary_null_comparison
                text: (currentSchedule == null)
                    ? "main.no_info".tr()
                    : "main.remained_datetime".tr(args: [
                        days.toString(),
                        hours.toString(),
                        minutes.toString()
                      ]),
              ),
              const TextSpan(text: "\n"),
              TextSpan(
                style: bodyBold,
                text:
                    // ignore: unnecessary_null_comparison
                    (currentSchedule == null) ? "-" : currentSchedule["title"],
              ),
              const TextSpan(text: " "),
              TextSpan(
                style: bodyBold,
                // ignore: unnecessary_null_comparison
                text: (currentSchedule == null) ? "" : currentSchedule["name"],
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
<<<<<<< HEAD
=======
        // const SizedBox(height: 4.0),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: <Widget>[
        //     TextButton(
        //       onPressed: () => launchUrl(Uri.https("cais.kaist.ac.kr", "")),
        //       child: Text(
        //         "main.goto_cais".tr(),
        //         style: labelRegular.copyWith(color: pinksMain),
        //       ),
        //     ),
        //   ],
        // ),
>>>>>>> e08b898 (add colorstyles, textstyles and refactor main_page.dart)
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
      height: 76,
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
