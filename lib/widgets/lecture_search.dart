import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:otlplus/pages/lecture_search_page.dart';
import 'package:otlplus/utils/responsive_button.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/providers/lecture_detail_model.dart';
import 'package:otlplus/providers/lecture_search_model.dart';
import 'package:otlplus/widgets/lecture_group_block.dart';

class LectureSearch extends StatefulWidget {
  final Future<bool> Function()? onClosed;

  LectureSearch({this.onClosed});

  @override
  _LectureSearchState createState() => _LectureSearchState();
}

class _LectureSearchState extends State<LectureSearch> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final searchModel = context.watch<LectureSearchModel>();

    return WillPopScope(
      onWillPop: widget.onClosed,
      child: ColoredBox(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      child: BackgroundButton(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const LectureSearchPage(
                                    openKeyboard: false))),
                        color: const Color(0xFFF9F0F0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/search.svg',
                                    height: 24.0,
                                    width: 24.0,
                                    colorFilter: const ColorFilter.mode(
                                        OTLColor.pinksMain, BlendMode.srcIn)),
                                const SizedBox(width: 12.0),
                                Flexible(
                                    child: context
                                        .watch<LectureSearchModel>()
                                        .lectureSearchquery),
                              ],
                            ),
                          ),
                        ),
                      )),
                )),
                IconTextButton(
                  padding: const EdgeInsets.fromLTRB(8, 12, 16, 12),
                  icon: Icons.close_outlined,
                  iconSize: 24,
                  onTap: widget.onClosed,
                )
              ],
            ),
            Expanded(
              child: searchModel.isSearching
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Scrollbar(
                      controller: _scrollController,
                      child: _buildListView(
                          searchModel.lectures ?? [[]], _scrollController),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  ListView _buildListView(
      List<List<Lecture>> lectures, ScrollController scrollController) {
    return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        controller: scrollController,
        itemCount: lectures.length,
        itemBuilder: (context, index) => LectureGroupBlock(
              lectures: lectures[index],
              onLongPress: (lecture) {
                context
                    .read<LectureDetailModel>()
                    .loadLecture(lecture.id, true);
                Navigator.push(context, buildLectureDetailPageRoute());
              },
            ),
        separatorBuilder: (context, index) => const SizedBox(height: 8));
  }
}
