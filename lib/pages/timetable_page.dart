import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/backdrop.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/extensions/semester.dart';
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
  static const MethodChannel _channel =
      const MethodChannel("me.blog.ghwhsbsb123.timeplanner_mobile");

  final _selectedKey = GlobalKey();
  final _paintKey = GlobalKey();

  bool _isSearchOpened = false;
  bool _isExamTime = false;
  List<Semester> _semesters;
  Lecture _selectedLecture;

  @override
  void initState() {
    super.initState();
    _semesters = context.read<InfoModel>().semesters;
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
              margin: const EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 4.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(6.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: <Widget>[
                    SemesterPicker(
                      isExamTime: _isExamTime,
                      semesters: _semesters,
                      onSemesterChanged: (index) {
                        setState(() {
                          _isSearchOpened = false;
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
                          child: RepaintBoundary(
                            key: _paintKey,
                            child: Container(
                              color: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Timetable(
                                lectures: (_selectedLecture == null)
                                    ? lectures
                                    : [...lectures, _selectedLecture],
                                isExamTime: _isExamTime,
                                builder: (lecture) {
                                  final isSelected =
                                      _selectedLecture == lecture;
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
                                      Backdrop.of(context)
                                          .toggleBackdropLayerVisibility(
                                              LectureDetailLayer(lecture));
                                    },
                                    onLongPress: isSelected
                                        ? null
                                        : () async {
                                            bool result = false;

                                            await showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => AlertDialog(
                                                title: const Text("삭제"),
                                                content: Text(
                                                    "'${lecture.title}' 수업을 삭제하시겠습니까?"),
                                                actions: [
                                                  TextButton(
                                                    child: const Text("취소"),
                                                    onPressed: () {
                                                      result = false;
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text("삭제"),
                                                    onPressed: () {
                                                      result = true;
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (result) {
                                              context
                                                  .read<TimetableModel>()
                                                  .updateTimetable(
                                                      lecture: lecture,
                                                      delete: true);
                                            }
                                          },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: const Divider(
                        color: DIVIDER_COLOR,
                        height: 1.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 12.0,
                      ),
                      child: TimetableSummary(
                        lectures: lectures,
                        tempLecture: _selectedLecture,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: const Divider(
                        color: DIVIDER_COLOR,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: _isSearchOpened,
            child: WillPopScope(
              onWillPop: () async {
                if (_isSearchOpened) {
                  setState(() {
                    _isSearchOpened = false;
                    _selectedLecture = null;
                  });
                  return null;
                }
                return true;
              },
              child: ChangeNotifierProvider(
                create: (context) => SearchModel(),
                child: LectureSearch(
                  onAdded: () {
                    setState(() {
                      _selectedLecture = null;
                    });
                  },
                  onClosed: () {
                    setState(() {
                      _isSearchOpened = false;
                      _selectedLecture = null;
                    });
                  },
                  onSelectionChanged: (lecture) {
                    setState(() {
                      _selectedLecture = lecture;
                    });
                  },
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
      isExamTime: _isExamTime,
      onTap: (i) {
        final timetableModel = context.read<TimetableModel>();

        if (i > 0 && i == timetableModel.timetables.length)
          timetableModel.createTimetable();
        else
          timetableModel.setIndex(i);
      },
      onAddTap: () {
        if (_isSearchOpened) return;
        setState(() {
          _isSearchOpened = true;
          _selectedLecture = null;
        });
      },
      onExamTap: () {
        setState(() {
          _isExamTime = !_isExamTime;
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
            leading: const Icon(Icons.image),
            title: const Text("이미지 저장"),
            onTap: () async {
              final boundary = _paintKey.currentContext.findRenderObject()
                  as RenderRepaintBoundary;
              final image = await boundary.toImage(pixelRatio: 3.0);
              final byteData =
                  await image.toByteData(format: ImageByteFormat.png);

              final timetableModel = context.read<TimetableModel>();
              final fileName =
                  "${timetableModel.selectedSemester.title.replaceAll(" ", "_")}_${timetableModel.selectedIndex + 1}_${_isExamTime ? "시험" : "수업"}.png";

              if (Platform.isAndroid) {
                await _channel
                    .invokeMethod("writeImageAsBytes", <String, dynamic>{
                  "fileName": fileName,
                  "bytes": byteData.buffer.asUint8List(),
                });
              } else {
                final directory = await getApplicationDocumentsDirectory();
                final path = "${directory.path}/$fileName";
                File(path).writeAsBytesSync(byteData.buffer.asUint8List());
                OpenFile.open(path);
              }
              Navigator.pop(context);
            },
          ),
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
            onTap: (context.select<TimetableModel, bool>(
                    (model) => model.timetables.length <= 1))
                ? null
                : () {
                    context.read<TimetableModel>().deleteTimetable();
                    Navigator.pop(context);
                  },
          ),
        ],
      ),
    );
  }
}
