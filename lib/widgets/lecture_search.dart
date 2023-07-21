import 'package:flutter/material.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:otlplus/constants/icon.dart';
import 'package:otlplus/pages/lecture_search_page.dart';
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              LectureSearchPage(openKeyboard: false))),
                      child: ColoredBox(
                        color: Color(0xFFF9F0F0),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CustomIcons.search, color: PRIMARY_COLOR),
                                SizedBox(width: 8.0),
                                Flexible(
                                    child: context
                                        .watch<LectureSearchModel>()
                                        .lectureSearchquery),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: GestureDetector(
                      onTap: widget.onClosed,
                      child: const Icon(Icons.close_outlined),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: searchModel.isSearching
                    ? Center(
                        child: const CircularProgressIndicator(),
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
      ),
    );
  }

  ListView _buildListView(
      List<List<Lecture>> lectures, ScrollController scrollController) {
    return ListView.separated(
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
        separatorBuilder: (context, index) => SizedBox(height: 10));
  }
}
