import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/backdrop.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/layers/lecture_detail_layer.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/models/semester.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';
import 'package:timeplanner_mobile/providers/search_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';
import 'package:timeplanner_mobile/widgets/course_lectures_block.dart';
import 'package:timeplanner_mobile/widgets/semester_picker.dart';
import 'package:timeplanner_mobile/widgets/timetable.dart';
import 'package:timeplanner_mobile/widgets/timetable_block.dart';
import 'package:timeplanner_mobile/widgets/timetable_summary.dart';
import 'package:timeplanner_mobile/widgets/timetable_tabs.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final _searchTextController = TextEditingController();
  PersistentBottomSheetController _searchSheetController;

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableModel>(
      builder: (context, timetableModel, _) {
        final semesters =
            Provider.of<InfoModel>(context, listen: false).semesters;

        if (timetableModel.state == TimetableState.done)
          return _buildBody(context, timetableModel, semesters);

        timetableModel.loadTimetable(semester: semesters.last);

        return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TimetableModel timetableModel,
      List<Semester> semesters) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          _buildTimetableTabs(context, timetableModel),
          Expanded(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(6.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SemesterPicker(
                      semesters: semesters,
                      onSemesterChanged: (index) => timetableModel
                          .loadTimetable(semester: semesters[index]),
                    ),
                    Expanded(
                      child: ShaderMask(
                        blendMode: BlendMode.dstIn,
                        shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.white,
                              Colors.transparent,
                            ],
                            stops: <double>[
                              0.95,
                              1.0,
                            ]).createShader(
                            bounds.shift(Offset(-bounds.left, -bounds.top))),
                        child: SingleChildScrollView(
                          child: Timetable(
                            lectures: timetableModel.currentTimetable.lectures,
                            builder: (lecture) => TimetableBlock(
                              lecture: lecture,
                              onTap: () {
                                _searchSheetController?.close();
                                _searchSheetController = null;

                                Backdrop.of(context)
                                    .toggleBackdropLayerVisibility(
                                        LectureDetailLayer(lecture));
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      color: DIVIDER_COLOR,
                      height: 1.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: TimetableSummary(
                          timetableModel.currentTimetable.lectures),
                    ),
                    const Divider(
                      color: DIVIDER_COLOR,
                      height: 1.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourse(BuildContext context, List<Lecture> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: BLOCK_COLOR,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: ListTile.divideTiles(
          context: context,
          color: BORDER_BOLD_COLOR,
          tiles: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black87),
                  children: <TextSpan>[
                    TextSpan(
                      text: course.first.commonTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: " "),
                    TextSpan(text: course.first.oldCode),
                  ],
                ),
              ),
            ),
            ...course.map((lecture) => CourseLecturesBlock(
                  lecture: lecture,
                  onTap: () {},
                )),
          ],
        ).toList(),
      ),
    );
  }

  TimetableTabs _buildTimetableTabs(
      BuildContext context, TimetableModel timetableModel) {
    return TimetableTabs(
      index: timetableModel.selectedIndex,
      length: timetableModel.timetables.length,
      onTap: (i) {
        if (i > 0 && i == timetableModel.timetables.length)
          timetableModel.createTimetable();
        else
          timetableModel.setIndex(i);
      },
      onAddTap: () {
        _searchSheetController = showBottomSheet(
            context: context,
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => SearchModel(),
                  child: Builder(
                    builder: (context) =>
                        _buildSearchSheet(context, timetableModel),
                  ),
                ));
      },
      onSettingsTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => _buildSettingsSheet(context, timetableModel));
      },
    );
  }

  Widget _buildSearchSheet(
      BuildContext context, TimetableModel timetableModel) {
    final searchModel = Provider.of<SearchModel>(context, listen: false);

    return Container(
      color: Colors.white,
      child: Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 12.0),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: _searchTextController,
                    onSubmitted: (value) {
                      searchModel.search(
                          timetableModel.selectedSemester, value);
                      _searchTextController.clear();
                    },
                    style: const TextStyle(fontSize: 14.0),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(),
                      isDense: true,
                      hintText: "검색",
                      hintStyle: TextStyle(
                        color: PRIMARY_COLOR,
                        fontSize: 14.0,
                      ),
                      icon: Icon(
                        Icons.search,
                        color: PRIMARY_COLOR,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.black45,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Consumer<SearchModel>(
              builder: (context, searchModel, _) {
                if (searchModel.state != SearchState.done) {
                  return Center(
                    child: const CircularProgressIndicator(),
                  );
                }
                return Scrollbar(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    itemCount: searchModel.courses.length,
                    itemBuilder: (context, index) =>
                        _buildCourse(context, searchModel.courses[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSheet(
      BuildContext context, TimetableModel timetableModel) {
    return Container(
      color: Colors.white,
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.content_copy),
            title: const Text("복제"),
            onTap: () {
              timetableModel.createTimetable(
                  lectures: timetableModel.currentTimetable.lectures);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("삭제"),
            onTap: () {
              timetableModel.deleteTimetable();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
