import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:otlplus/models/review.dart';
import 'package:otlplus/utils/build_app_bar.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/extensions/lecture.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/providers/course_detail_model.dart';
import 'package:otlplus/providers/info_model.dart';
import 'package:otlplus/providers/lecture_detail_model.dart';
import 'package:otlplus/providers/timetable_model.dart';
import 'package:otlplus/widgets/custom_header_delegate.dart';
import 'package:otlplus/widgets/review_block.dart';
import 'package:otlplus/widgets/review_write_block.dart';

class LectureDetailPage extends StatelessWidget {
  static String route = 'lecture_detail_page';

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
    final LectureDetailModel lectureDetailModel =
        context.watch<LectureDetailModel>();

    return Scaffold(
      appBar: buildAppBar(
        context,
        lectureDetailModel.hasData ? lectureDetailModel.lecture.title : '',
        true,
        false,
      ),
      body: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child:
            context.select<LectureDetailModel, bool>((model) => model.hasData)
                ? _buildBody(context)
                : Center(
                    child: const CircularProgressIndicator(),
                  ),
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
          _buildButtons(context, lecture),
          const SizedBox(height: 8.0),
          Expanded(child: _buildScrollView(context, lecture)),
          if (context.select<LectureDetailModel, bool>(
                  (model) => model.isUpdateEnabled) &&
              context.read<TimetableModel>().selectedIndex != 0) ...[
            const Divider(color: DIVIDER_COLOR),
            Align(
              alignment: Alignment.centerRight,
              child: _buildUpdateButton(context, lecture),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context, Lecture lecture) {
    final isAdded = context.select<TimetableModel, bool>(
        (model) => model.currentTimetable.lectures.contains(lecture));

    return InkWell(
      onTap: () {
        final timetableModel = context.read<TimetableModel>();

        if (isAdded) {
          timetableModel.removeLecture(lecture: lecture);
        } else {
          timetableModel.addLecture(
            lecture: lecture,
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
        }
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
            context.read<CourseDetailModel>().loadCourse(lecture.course);
            Navigator.push(context, buildCourseDetailPageRoute());
          },
          child: const Text(
            "과목사전",
            style: TextStyle(
              color: OTLColor.pinksMain,
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
              defaultColorSchemeParams:
                  CustomTabsColorSchemeParams(toolbarColor: OTLColor.pinksLight),
              shareState: CustomTabsShareState.on,
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
              color: OTLColor.pinksMain,
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
        _buildReviews(context, lecture),
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
            await Scrollable.ensureVisible(headerKey.currentContext!,
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
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
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

  SliverList _buildReviews(BuildContext context, Lecture lecture) {
    final user = context.watch<InfoModel>().user;
    Review? existingReview;
    try {
      existingReview =
          user.reviews.firstWhere((review) => review.lecture.id == lecture.id);
    } on StateError {}

    return SliverList(
      delegate: SliverChildListDelegate([
        if (user.reviewWritableLectures.contains(lecture))
          ReviewWriteBlock(
            lecture: lecture,
            existingReview: existingReview,
            isSimple: true,
            onUploaded: (review) {
              context.read<InfoModel>().getInfo();
              context.read<LectureDetailModel>().updateLectureReviews(review);
            },
          ),
        ...context.select<LectureDetailModel, List<Widget>>((model) {
          if (model.reviews.length == 0) {
            return [Text("결과 없음")];
          } else {
            return model.reviews
                .map((review) => ReviewBlock(
                      review: review,
                    ))
                .toList();
          }
        }),
      ]),
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
                  (lecture.credit > 0) ? "학점" : "AU",
                  (lecture.credit > 0)
                      ? lecture.credit.toString()
                      : lecture.creditAu.toString()),
              _buildStatus(
                  "경쟁률",
                  (lecture.limit == 0)
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

  Widget _buildAttribute(Lecture lecture) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          height: 1.5,
          fontSize: 12.0,
        ),
        children: <TextSpan>[
          TextSpan(
            text: "과목코드 ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: lecture.oldCode),
          TextSpan(
            text: "\n구분 ",
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
          TextSpan(
              text: lecture.classtimes
                  .map((classtime) => classtime.classroom)
                  .toSet()
                  .join(", ")),
          TextSpan(
            text: "\n정원 ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: lecture.limit.toString()),
          TextSpan(
            text: "\n시험 ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
              text: (lecture.examtimes.length == 0)
                  ? "정보 없음"
                  : lecture.examtimes
                      .map((examtime) => examtime.str)
                      .toSet()
                      .join(", ")),
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
