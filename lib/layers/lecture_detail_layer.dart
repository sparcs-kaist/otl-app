import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/backdrop.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/layers/course_detail_layer.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/models/review.dart';
import 'package:timeplanner_mobile/providers/course_detail_model.dart';
import 'package:timeplanner_mobile/providers/lecture_detail_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';
import 'package:timeplanner_mobile/widgets/custom_header_delegate.dart';
import 'package:timeplanner_mobile/widgets/review_block.dart';

class LectureDetailLayer extends StatelessWidget {
  final _courseDetailLayer = CourseDetailLayer();
  final _scrollController = ScrollController();

  String _getSyllabusUrl(Lecture lecture) {
    return Uri.https("cais.kaist.ac.kr", "/syllabusInfo", {
      "year": lecture.year.toString(),
      "term": lecture.semester.toString(),
      "subject_no": lecture.code,
      "lecture_class": lecture.classNo,
      "dept_id": lecture.department.toString(),
    }).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: context.select<LectureDetailModel, bool>((model) => model.hasData)
          ? _buildBody(context)
          : Center(
              child: const CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final lecture =
        context.select<LectureDetailModel, Lecture>((model) => model.lecture);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: <Widget>[
          Text(
            lecture.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4.0),
          Text(
            lecture.classNo.isEmpty
                ? lecture.oldCode
                : "${lecture.oldCode} (${lecture.classNo})",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.0),
          ),
          _buildButtons(context, lecture),
          const SizedBox(height: 8.0),
          Expanded(child: _buildScrollView(context, lecture)),
          const Divider(color: DIVIDER_COLOR),
          Align(
            alignment: Alignment.centerRight,
            child: _buildUpdateButton(context, lecture),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context, Lecture lecture) {
    final isAdded = context.select<TimetableModel, bool>(
        (model) => model.currentTimetable.lectures.contains(lecture));

    return InkWell(
      onTap: () {
        context.read<TimetableModel>().updateTimetable(
              lecture: lecture,
              delete: isAdded,
              onOverlap: (lectures) async {
                bool result = false;

                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: const Text("수업 추가"),
                    content: const Text(
                        "시간이 겹치는 수업이 있습니다. 추가하시면 해당 수업은 삭제됩니다.\n시간표에 추가하시겠습니까?"),
                    actions: [
                      TextButton(
                        child: const Text("취소"),
                        onPressed: () {
                          result = false;
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text("추가하기"),
                        onPressed: () {
                          result = true;
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );

                return result;
              },
            );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          isAdded
              ? const Icon(
                  Icons.close,
                  size: 14.0,
                )
              : const Icon(
                  Icons.add,
                  size: 14.0,
                ),
          const SizedBox(width: 4.0),
          Text(
            isAdded ? "시간표에서 제거" : "시간표에 추가",
            style: const TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, Lecture lecture) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          onTap: () {
            context
                .read<CourseDetailModel>()
                .loadCourse(context.read<LectureDetailModel>().course);
            Backdrop.of(context).show(_courseDetailLayer);
          },
          child: const Text(
            "과목사전",
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontSize: 11.0,
            ),
          ),
        ),
        const SizedBox(width: 6.0),
        InkWell(
          onTap: () => FlutterWebBrowser.openWebPage(
            url: _getSyllabusUrl(lecture),
            customTabsOptions: CustomTabsOptions(
              colorScheme: CustomTabsColorScheme.light,
              toolbarColor: BACKGROUND_COLOR,
              addDefaultShareMenuItem: true,
              instantAppsEnabled: true,
              showTitle: true,
              urlBarHidingEnabled: true,
            ),
            safariVCOptions: SafariViewControllerOptions(
              barCollapsingEnabled: true,
              dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
              modalPresentationCapturesStatusBarAppearance: true,
            ),
          ),
          child: const Text(
            "실라버스",
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontSize: 11.0,
            ),
          ),
        ),
      ],
    );
  }

  CustomScrollView _buildScrollView(BuildContext context, Lecture lecture) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            _buildAttribute(lecture),
            _buildScores(lecture),
          ]),
        ),
        _buildReviewHeader(),
        _buildReviews(context),
      ],
    );
  }

  SliverPersistentHeader _buildReviewHeader() {
    final key = GlobalKey();
    return SliverPersistentHeader(
      key: key,
      pinned: true,
      delegate: CustomHeaderDelegate(
        height: 25.0,
        padding: const EdgeInsets.only(bottom: 6.0),
        onTap: (shrinkOffset) async {
          if (shrinkOffset > 0) {
            _scrollController.jumpTo(0);
          } else {
            await Scrollable.ensureVisible(key.currentContext);
            _scrollController.jumpTo(_scrollController.offset + 1);
          }
        },
        builder: (shrinkOffset) => Row(
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: "과목 후기",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FittedBox(
              child: Icon(shrinkOffset > 0
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
            ),
          ],
        ),
      ),
    );
  }

  SliverList _buildReviews(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(context
          .select<LectureDetailModel, List<Review>>((model) => model.reviews)
          .map((review) => ReviewBlock(
                review: review,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                isSimple: true,
              ))
          .toList()),
    );
  }

  Widget _buildScores(Lecture lecture) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              _buildStatus("언어", lecture.isEnglish ? "Eng" : "한"),
              _buildStatus(
                  lecture.credit > 0 ? "학점" : "AU",
                  lecture.credit > 0
                      ? lecture.credit.toString()
                      : lecture.creditAu.toString()),
              _buildStatus(
                  "경쟁률",
                  lecture.limit == 0
                      ? "0.0:1"
                      : "${(lecture.numPeople / lecture.limit).toStringAsFixed(1)}:1"),
            ],
          ),
          TableRow(
            children: <Widget>[
              _buildStatus("성적", lecture.gradeLetter),
              _buildStatus("널널", lecture.loadLetter),
              _buildStatus("강의", lecture.speechLetter),
            ],
          ),
        ],
      ),
    );
  }

  RichText _buildAttribute(Lecture lecture) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black87,
          height: 1.5,
          fontSize: 13.0,
        ),
        children: <TextSpan>[
          TextSpan(
            text: "구분 ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: lecture.type),
          TextSpan(
            text: "\n학과 ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: lecture.departmentName),
          TextSpan(
            text: "\n교수 ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: lecture.professorsStrShort),
          TextSpan(
            text: "\n장소 ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: lecture.classroom),
          TextSpan(
            text: "\n정원 ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: lecture.limit.toString()),
          TextSpan(
            text: "\n시험 ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: lecture.exam),
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
