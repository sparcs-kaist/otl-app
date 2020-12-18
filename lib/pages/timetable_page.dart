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
import 'package:timeplanner_mobile/widgets/lecture_search.dart';
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
  final _selectedKey = GlobalKey();

  PersistentBottomSheetController _searchSheetController;
  List<Semester> _semesters;
  Lecture _selectedLecture;

  @override
  void initState() {
    super.initState();
    _semesters = context.read<InfoModel>().semesters;
    context.read<TimetableModel>().loadTimetable(semester: _semesters.last);
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<TimetableModel>().state == TimetableState.done)
      return _buildBody(context);
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildBody(BuildContext context) {
    final lectures = context.select<TimetableModel, List<Lecture>>(
        (model) => model.currentTimetable.lectures);
    bool isFirst = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedKey?.currentContext != null)
        Scrollable.ensureVisible(_selectedKey.currentContext);
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          _buildTimetableTabs(context),
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
                      semesters: _semesters,
                      onSemesterChanged: (index) {
                        _searchSheetController?.close();
                        _searchSheetController = null;

                        setState(() {
                          _selectedLecture = null;
                        });

                        context
                            .read<TimetableModel>()
                            .loadTimetable(semester: _semesters[index]);
                      },
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
                            lectures: (_selectedLecture == null)
                                ? lectures
                                : [...lectures, _selectedLecture],
                            builder: (lecture) {
                              final isSelected = _selectedLecture == lecture;
                              Key key;

                              if (isSelected && isFirst) {
                                key = _selectedKey;
                                isFirst = false;
                              }

                              return TimetableBlock(
                                key: key,
                                lecture: lecture,
                                isTemp: isSelected,
                                onTap: () {
                                  _searchSheetController?.close();
                                  _searchSheetController = null;

                                  setState(() {
                                    _selectedLecture = null;
                                  });

                                  Backdrop.of(context)
                                      .toggleBackdropLayerVisibility(
                                          LectureDetailLayer(lecture));
                                },
                              );
                            },
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
                      child: TimetableSummary(lectures),
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

  TimetableTabs _buildTimetableTabs(BuildContext context) {
    final timetableModel = context.watch<TimetableModel>();

    return TimetableTabs(
      index: timetableModel.selectedIndex,
      length: timetableModel.timetables.length,
      onTap: (i) {
        final timetableModel = context.read<TimetableModel>();

        if (i > 0 && i == timetableModel.timetables.length)
          timetableModel.createTimetable();
        else
          timetableModel.setIndex(i);
      },
      onAddTap: () async {
        _searchSheetController = showBottomSheet(
            context: context,
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => SearchModel(),
                  child: LectureSearch(
                    onSelectionChanged: (lecture) {
                      setState(() {
                        _selectedLecture = lecture;
                      });
                    },
                  ),
                ));
        await _searchSheetController.closed;
        _searchSheetController = null;

        setState(() {
          _selectedLecture = null;
        });
      },
      onSettingsTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => _buildSettingsSheet(context));
      },
    );
  }

  Widget _buildSettingsSheet(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.content_copy),
            title: const Text("복제"),
            onTap: () {
              final timetableModel = context.read<TimetableModel>();
              timetableModel.createTimetable(
                  lectures: timetableModel.currentTimetable.lectures);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("삭제"),
            onTap: () {
              context.read<TimetableModel>().deleteTimetable();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
