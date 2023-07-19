import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/extensions/semester.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/models/semester.dart';
import 'package:otlplus/models/user.dart';
import 'package:otlplus/providers/info_model.dart';
import 'package:otlplus/providers/lecture_detail_model.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:otlplus/widgets/lecture_simple_block.dart';
import 'package:provider/provider.dart';

class MyReviewPage extends StatelessWidget {
  static String route = 'my_review_page';

  const MyReviewPage({Key? key}) : super(key: key);

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
      ..sort((a, b) =>
          ((a.year != b.year) ? (b.year - a.year) : (b.semester - a.semester)));

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
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
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Theme(
        data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme(
          color: BACKGROUND_COLOR,
          elevation: 0.0,
          actionsIconTheme: IconThemeData(
            color: CONTENT_COLOR,
          ),
        )),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '내가 들은 과목',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          centerTitle: true,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Container(
                  color: PRIMARY_COLOR,
                  height: 5,
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
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

  Widget _buildLectureBlock(BuildContext context, User user, Lecture lecture) {
    return LectureSimpleBlock(
      lecture: lecture,
      hasReview: user.reviews.any((review) => review.lecture.id == lecture.id),
      onTap: () {
        context.read<LectureDetailModel>().loadLecture(lecture.id, false);
        Navigator.push(context, buildLectureDetailPageRoute());
      },
    );
  }
}
