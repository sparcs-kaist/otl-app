import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:otlplus/constants/text_styles.dart';
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
    final isEn = EasyLocalization.of(context)!.currentLocale == Locale('en');

    return Scaffold(
      appBar: buildAppBar(
        context,
        lectureDetailModel.hasData
            ? (isEn
                ? lectureDetailModel.lecture.titleEn
                : lectureDetailModel.lecture.title)
            : '',
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
          child: Text(
            "dictionary.dictionary".tr(),
            style: bodyRegular.copyWith(color: OTLColor.pinksMain),
          ),
        ),
        const SizedBox(width: 8.0),
        InkWell(
          onTap: () => FlutterWebBrowser.openWebPage(
            url: _getSyllabusUrl(lecture),
            customTabsOptions: CustomTabsOptions(
              colorScheme: CustomTabsColorScheme.light,
              defaultColorSchemeParams: CustomTabsColorSchemeParams(
                  toolbarColor: OTLColor.pinksLight),
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
          child: Text(
            "dictionary.syllabus".tr(),
            style: bodyRegular.copyWith(color: OTLColor.pinksMain),
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
            _buildAttributes(context, lecture),
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
            Text("dictionary.reviews".tr(), style: bodyBold),
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
            return [Text("common.no_result".tr())];
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
              _buildStatus(
                "dictionary.language".tr(),
                lecture.isEnglish ? "Eng" : "한",
              ),
              _buildStatus(
                  (lecture.credit > 0) ? "dictionary.credit".tr() : "AU",
                  (lecture.credit > 0)
                      ? lecture.credit.toString()
                      : lecture.creditAu.toString()),
              _buildStatus(
                "dictionary.competition".tr(),
                (lecture.limit == 0)
                    ? "0.0:1"
                    : "${(lecture.numPeople / lecture.limit).toStringAsFixed(1)}:1",
              ),
            ],
          ),
          TableRow(
            children: <Widget>[
              _buildStatus("review.grade".tr(), lecture.gradeLetter),
              _buildStatus("review.load".tr(), lecture.loadLetter),
              _buildStatus("review.speech".tr(), lecture.speechLetter),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttribute(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(title, style: bodyBold),
          const SizedBox(width: 4.0),
          Text(content, style: bodyRegular),
        ],
      ),
    );
  }

  Widget _buildAttributes(BuildContext context, Lecture lecture) {
    final isEn = EasyLocalization.of(context)!.currentLocale == Locale('en');

    return Column(
      children: [
        _buildAttribute("dictionary.code".tr(), lecture.oldCode),
        _buildAttribute(
          "dictionary.type".tr(),
          isEn ? lecture.typeEn : lecture.type,
        ),
        _buildAttribute(
          "dictionary.department".tr(),
          isEn ? lecture.departmentName : lecture.departmentNameEn,
        ),
        _buildAttribute(
          "dictionary.professors".tr(),
          isEn ? lecture.professorsStrShort : lecture.professorsStrShortEn,
        ),
        _buildAttribute(
            "dictionary.classroom".tr(),
            lecture.classtimes
                .map((classtime) =>
                    isEn ? classtime.classroomEn : classtime.classroom)
                .toSet()
                .join(", ")),
        _buildAttribute(
          "dictionary.limit".tr(),
          lecture.limit.toString(),
        ),
        _buildAttribute(
          "dictionary.exam".tr(),
          (lecture.examtimes.length == 0)
              ? "common.no_info".tr()
              : lecture.examtimes
                  .map((examtime) => isEn ? examtime.strEn : examtime.str)
                  .toSet()
                  .join(", "),
        ),
      ],
    );
  }

  Widget _buildStatus(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: <Widget>[
          Text(content, style: titleRegular),
          Text(title, style: labelRegular),
        ],
      ),
    );
  }
}
