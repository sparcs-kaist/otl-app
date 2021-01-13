import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/extensions/course.dart';
import 'package:timeplanner_mobile/extensions/lecture.dart';
import 'package:timeplanner_mobile/models/course.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/models/professor.dart';
import 'package:timeplanner_mobile/providers/course_detail_model.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';
import 'package:timeplanner_mobile/widgets/custom_header_delegate.dart';
import 'package:timeplanner_mobile/widgets/lecture_group_simple_block.dart';
import 'package:timeplanner_mobile/widgets/review_block.dart';
import 'package:timeplanner_mobile/widgets/review_write_block.dart';

class CourseDetailPage extends StatelessWidget {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
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
          Expanded(child: _buildScrollView(context, course)),
        ],
      ),
    );
  }

  CustomScrollView _buildScrollView(BuildContext context, Course course) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            _buildAttribute(course),
            _buildScores(context, course),
            const Divider(color: DIVIDER_COLOR),
            _buildProfessors(context, course),
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
          ]),
        ),
        _buildReviewHeader(),
        _buildReviews(context, course),
      ],
    );
  }

  SliverPersistentHeader _buildReviewHeader() {
    final headerKey = GlobalKey();
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomHeaderDelegate(
        height: 24.0,
        padding: const EdgeInsets.only(bottom: 4.0),
        onTap: (shrinkOffset) async {
          if (shrinkOffset > 0) {
            _scrollController.animateTo(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          } else {
            await Scrollable.ensureVisible(headerKey.currentContext,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
            _scrollController.jumpTo(_scrollController.offset + 2);
          }
        },
        builder: (shrinkOffset) => Row(
          key: headerKey,
          children: <Widget>[
            Text(
              "과목 후기",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
                height: 1.3,
              ),
            ),
            FittedBox(
              child: (shrinkOffset > 0)
                  ? const Icon(Icons.keyboard_arrow_up)
                  : const Icon(Icons.keyboard_arrow_down),
            ),
          ],
        ),
      ),
    );
  }

  ChoiceChip _buildChoiceChip(
      BuildContext context, String selectedFilter, Professor professor) {
    return ChoiceChip(
      label: (professor == null) ? const Text("전체") : Text(professor.name),
      selected: (professor == null)
          ? (selectedFilter == "ALL")
          : (selectedFilter == professor.professorId.toString()),
      onSelected: (isSelected) {
        context.read<CourseDetailModel>().setFilter(
            (professor != null && isSelected)
                ? professor.professorId.toString()
                : "ALL");
      },
    );
  }

  Widget _buildProfessors(BuildContext context, Course course) {
    final courseDetailModel = context.watch<CourseDetailModel>();

    return Row(
      children: <Widget>[
        Text(
          "교수 ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
            height: 1.1,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: _buildChoiceChip(
                      context, courseDetailModel.selectedFilter, null),
                ),
                ...courseDetailModel.professors
                    .map((professor) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: _buildChoiceChip(context,
                              courseDetailModel.selectedFilter, professor),
                        ))
                    .toList(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildScores(BuildContext context, Course course) {
    final lecture = context
        .select<CourseDetailModel, Lecture>((model) => model.selectedLecture);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildStatus("성적",
              (lecture == null) ? course.gradeLetter : lecture.gradeLetter),
          _buildStatus(
              "널널", (lecture == null) ? course.loadLetter : lecture.loadLetter),
          _buildStatus("강의",
              (lecture == null) ? course.speechLetter : lecture.speechLetter),
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
    final courseDetailModel = context.watch<CourseDetailModel>();

    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        reverse: true,
        child: Column(
          children: <Widget>[
            _buildHistoryRow(courseDetailModel.lectures, years, 1,
                courseDetailModel.selectedFilter),
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
            _buildHistoryRow(courseDetailModel.lectures, years, 3,
                courseDetailModel.selectedFilter),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryRow(List<Lecture> lectures, Set<int> years, int semester,
      String selectedFilter) {
    return IntrinsicHeight(
      child: Row(
        children: years.map(
          (year) {
            final filteredLectures = lectures
                .where((lecture) =>
                    lecture.year == year && lecture.semester == semester)
                .toList();
            if (filteredLectures.length == 0)
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
            return LectureGroupSimpleBlock(
              lectures: filteredLectures,
              semester: semester,
              filter: selectedFilter,
            );
          },
        ).toList(),
      ),
    );
  }

  Widget _buildReviews(BuildContext context, Course course) {
    final user = context.watch<InfoModel>().user;
    final selectedFilter = context
        .select<CourseDetailModel, String>((model) => model.selectedFilter);

    return SliverList(
      delegate: SliverChildListDelegate([
        ...user.reviewWritableLectures
            .where((lecture) =>
                lecture.course == course.id &&
                (selectedFilter == "ALL" ||
                    lecture.professors.any((professor) =>
                        professor.professorId.toString() == selectedFilter)))
            .map((lecture) => ReviewWriteBlock(
                  lecture: lecture,
                  existingReview: user.reviews.firstWhere(
                      (review) => review.lecture == lecture,
                      orElse: () => null),
                  isSimple: false,
                  onUploaded: (review) {
                    context.read<InfoModel>().getInfo();
                    context
                        .read<CourseDetailModel>()
                        .updateCourseReviews(review);
                  },
                ))
            .toList(),
        ...context.select<CourseDetailModel, List<Widget>>((model) => model
            .reviews
            .map((review) => ReviewBlock(review: review))
            .toList()),
      ]),
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
