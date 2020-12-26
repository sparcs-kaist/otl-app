import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/course.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/models/professor.dart';
import 'package:timeplanner_mobile/providers/course_detail_model.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';
import 'package:timeplanner_mobile/widgets/filter.dart';
import 'package:timeplanner_mobile/widgets/review_block.dart';

class CourseDetailLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: context.select<CourseDetailModel, bool>((model) => model.hasData)
          ? _buildBody(context)
          : Center(
              child: const CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final course =
        context.select<CourseDetailModel, Course>((model) => model.course);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Text(
            course.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            course.oldCode,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.0),
          ),
          const SizedBox(height: 8.0),
          Expanded(child: _buildListView(context, course)),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context, Course course) {
    return ListView(
      children: <Widget>[
        _buildAttribute(course),
        _buildScores(course),
        const Divider(color: DIVIDER_COLOR),
        Text(
          "개설 이력",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            height: 1.3,
          ),
        ),
        _buildHistory(context),
        const Divider(color: DIVIDER_COLOR),
        Text(
          "과목 후기",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            height: 1.3,
          ),
        ),
        _buildReviews(context, course),
      ],
    );
  }

  Widget _buildScores(Course course) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildStatus("성적", course.gradeLetter),
          _buildStatus("널널", course.loadLetter),
          _buildStatus("강의", course.speechLetter),
        ],
      ),
    );
  }

  Column _buildAttribute(Course course) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "분류 ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                height: 1.1,
              ),
            ),
            Expanded(
              child: Text(
                "${course.department.name}, ${course.type}",
                style: const TextStyle(
                  fontSize: 12.0,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "설명 ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                height: 1.1,
              ),
            ),
            Expanded(
              child: Text(
                course.summary,
                style: const TextStyle(
                  fontSize: 12.0,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistory(BuildContext context) {
    final years = context.select<InfoModel, Set<int>>((model) => model.years);
    final lectures = context
        .select<CourseDetailModel, List<Lecture>>((model) => model.lectures);
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        reverse: true,
        child: Column(
          children: <Widget>[
            _buildHistoryRow(lectures, years, 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: years
                    .map((year) => Container(
                          width: 110.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            year.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            _buildHistoryRow(lectures, years, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryRow(
      List<Lecture> lectures, Set<int> years, int semester) {
    return IntrinsicHeight(
      child: Row(
        children: years.map(
          (year) {
            final currentLectures = lectures.where((lecture) =>
                lecture.year == year && lecture.semester == semester);
            if (currentLectures.length == 0)
              return Container(
                width: 110.0,
                margin: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 8.0,
                ),
                child: const Text(
                  "미개설",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 12.0,
                  ),
                ),
              );
            return Column(
              children: <Widget>[
                semester == 1 ? const Spacer() : const SizedBox.shrink(),
                Container(
                  width: 110.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: BLOCK_COLOR,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: ListTile.divideTiles(
                      color: BORDER_BOLD_COLOR,
                      tiles: currentLectures.map((lecture) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13.0,
                                  height: 1.3,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: lecture.classTitle,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(text: " "),
                                  TextSpan(text: lecture.professorsStrShort),
                                ],
                              ),
                            ),
                          )),
                    ).toList(),
                  ),
                ),
                semester == 3 ? const Spacer() : const SizedBox.shrink(),
              ],
            );
          },
        ).toList(),
      ),
    );
  }

  Widget _buildReviews(BuildContext context, Course course) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Filter(
              property: "교수",
              items: {
                "ALL": "전체",
                for (final professor
                    in context.select<CourseDetailModel, List<Professor>>(
                        (model) => model.reviewProfessors))
                  professor.professorId.toString(): professor.name
              },
              onChanged: (value) {
                context.read<CourseDetailModel>().setFilter(value);
              },
            ),
          ),
          ...context.select<CourseDetailModel, List<Widget>>((model) => model
              .reviews
              .map((review) => ReviewBlock(review: review))
              .toList()),
        ],
      ),
    );
  }

  Widget _buildStatus(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: <Widget>[
          Text(
            content,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
