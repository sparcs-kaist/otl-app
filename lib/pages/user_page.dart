import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/extensions/semester.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/models/semester.dart';
import 'package:otlplus/models/user.dart';
import 'package:otlplus/providers/info_model.dart';
import 'package:otlplus/providers/lecture_detail_model.dart';
import 'package:otlplus/widgets/backdrop.dart';
import 'package:otlplus/widgets/lecture_simple_block.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<InfoModel>().user;
    final targetSemesters = user.reviewWritableLectures
        .map((lecture) => Semester(
            year: lecture.year,
            semester: lecture.semester,
            beginning: DateTime.now(),
            end: DateTime.now()))
        .toSet()
        .toList()
          ..sort((a, b) => ((a.year != b.year)
              ? (b.year - a.year)
              : (b.semester - a.semester)));

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTitle("내 정보"),
                _buildContent("이름 ", "${user.firstName} ${user.lastName}"),
                _buildContent("메일 ", user.email),
                const Divider(color: DIVIDER_COLOR),
                const SizedBox(height: 4.0),
                _buildTitle("학사 정보"),
                _buildContent("학번 ", user.studentId),
                _buildContent(
                    "전공 ",
                    user.majors
                        .map((department) => department.name)
                        .join(", ")),
                const Divider(color: DIVIDER_COLOR),
                const SizedBox(height: 4.0),
                _buildTitle("내가 들은 과목"),
                ...targetSemesters
                    .map((semester) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Text(
                                semester.title,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ..._buildLectureBlocks(
                                context,
                                user,
                                user.reviewWritableLectures
                                    .where((lecture) =>
                                        lecture.year == semester.year &&
                                        lecture.semester == semester.semester)
                                    .toList()),
                            const SizedBox(height: 8.0),
                          ],
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLectureBlock(BuildContext context, User user, Lecture lecture) {
    return LectureSimpleBlock(
      lecture: lecture,
      hasReview: user.reviews.any((review) => review.lecture == lecture),
      onTap: () {
        context.read<LectureDetailModel>().loadLecture(lecture.id, false);
        Backdrop.of(context).show(2);
      },
    );
  }

  List<Widget> _buildLectureBlocks(
      BuildContext context, User user, List<Lecture> lectures) {
    final blocks = <Widget>[];
    for (int i = 0; i < lectures.length ~/ 2; i++) {
      blocks.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: _buildLectureBlock(context, user, lectures[i * 2]),
            ),
            Expanded(
              child: _buildLectureBlock(context, user, lectures[i * 2 + 1]),
            ),
          ],
        ),
      ));
    }

    if (blocks.length * 2 < lectures.length) {
      blocks.add(Row(
        children: <Widget>[
          Expanded(
            child: _buildLectureBlock(context, user, lectures.last),
          ),
          Expanded(child: const SizedBox()),
        ],
      ));
    }

    return blocks;
  }

  Widget _buildContent(String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 12.0),
          children: <TextSpan>[
            TextSpan(
              text: name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
