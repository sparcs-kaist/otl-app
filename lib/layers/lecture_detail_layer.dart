import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/constants/url.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/models/review.dart';
import 'package:timeplanner_mobile/widgets/custom_header_delegate.dart';
import 'package:timeplanner_mobile/widgets/review_block.dart';

class LectureDetailLayer extends StatelessWidget {
  final Lecture lecture;
  final _browser = ChromeSafariBrowser(bFallback: InAppBrowser());
  final _scrollController = ScrollController();

  LectureDetailLayer(this.lecture);

  String _getSyllabusUrl() {
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
      margin: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
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
            _buildButtons(),
            const SizedBox(height: 8.0),
            Expanded(child: _buildScrollView()),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          onTap: () {},
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
          onTap: () => _browser.open(url: _getSyllabusUrl()),
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

  CustomScrollView _buildScrollView() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            _buildAttribute(),
            _buildScores(),
          ]),
        ),
        _buildReviewHeader(),
        _buildReviews(),
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

  FutureBuilder<Response> _buildReviews() {
    return FutureBuilder<Response>(
      future: Dio().get(API_LECTURE_RELATED_REVIEWS_URL.replaceFirst(
          "{id}", lecture.id.toString())),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            child: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        }

        final reviews = snapshot.data.data as List;

        return SliverList(
          delegate: SliverChildListDelegate(reviews
              .map((review) => ReviewBlock(Review.fromJson(review)))
              .toList()),
        );
      },
    );
  }

  Widget _buildScores() {
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

  RichText _buildAttribute() {
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
