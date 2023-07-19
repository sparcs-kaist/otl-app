import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:otlplus/pages/lecture_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/providers/lecture_detail_model.dart';
import 'package:otlplus/providers/search_model.dart';
import 'package:otlplus/providers/timetable_model.dart';
import 'package:otlplus/utils/export_image.dart';
import 'package:otlplus/widgets/lecture_search.dart';
import 'package:otlplus/widgets/semester_picker.dart';
import 'package:otlplus/widgets/timetable.dart';
import 'package:otlplus/widgets/timetable_block.dart';
import 'package:otlplus/widgets/timetable_summary.dart';
import 'package:otlplus/widgets/timetable_tabs.dart';
import 'package:easy_localization/easy_localization.dart';

class TimetablePage extends StatefulWidget {
  static String route = 'timetable_page';

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final _selectedKey = GlobalKey();
  final _paintKey = GlobalKey();

  bool _isSearchOpened = false;
  bool _isExamTime = false;
  Lecture? _selectedLecture;

  @override
  Widget build(BuildContext context) {
    if (context.select<TimetableModel, bool>((model) => model.isLoaded))
      return _buildBody(context);
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildBody(BuildContext context) {
    final lectures = context.select<TimetableModel, List<Lecture>>(
        (model) => model.currentTimetable.lectures);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedKey.currentContext != null)
        Scrollable.ensureVisible(_selectedKey.currentContext!);
    });

    return Column(
      children: <Widget>[
        _buildTimetableTabs(context),
        Expanded(
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 8.0),
                SemesterPicker(
                  isExamTime: _isExamTime,
                  onTap: () {
                    setState(() {
                      _isExamTime = !_isExamTime;
                    });
                  },
                  onSemesterChanged: () {
                    setState(() {
                      _isSearchOpened = false;
                      _selectedLecture = null;
                    });
                    context.read<SearchModel>().lectureClear();
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
                      ],
                    ).createShader(bounds.shift(Offset(
                      -bounds.left,
                      -bounds.top,
                    ))),
                    child: SingleChildScrollView(
                      child: RepaintBoundary(
                        key: _paintKey,
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _buildTimetable(context, lectures),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Divider(color: DIVIDER_COLOR, height: 1.0),
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
              ],
            ),
          ),
        ),
        Visibility(
          visible: _isSearchOpened,
          child: Expanded(
            child: LectureSearch(
              onAdded: () {
                setState(() {
                  _selectedLecture = null;
                });
              },
              onClosed: () async {
                setState(() {
                  _isSearchOpened = false;
                  _selectedLecture = null;
                  context.read<SearchModel>().lectureClear();
                });
                return true;
              },
              onSelectionChanged: (lecture) {
                setState(() {
                  _selectedLecture = lecture;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Timetable _buildTimetable(BuildContext context, List<Lecture> lectures) {
    bool isFirst = true;

    return Timetable(
      lectures: (_selectedLecture == null)
          ? lectures
          : [...lectures, _selectedLecture!],
      isExamTime: _isExamTime,
      builder: (lecture, classTimeIndex) {
        final isSelected = _selectedLecture == lecture;
        Key? key;

        if (isSelected && isFirst) {
          key = _selectedKey;
          isFirst = false;
        }

        return TimetableBlock(
          key: key,
          lecture: lecture,
          classTimeIndex: classTimeIndex,
          isTemp: isSelected,
          onTap: () {
            context.read<LectureDetailModel>().loadLecture(lecture.id, true);
            Navigator.push(context, _buildLectureDetailPageRoute());
          },
          onLongPress: isSelected
              ? null
              : () async {
                  bool result = false;

                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text("common.delete").tr(),
                      content: Text("timetable.ask_delete_lecture").tr(
                        args: [lecture.title],
                      ),
                      actions: [
                        TextButton(
                          child: const Text("common.cancel").tr(),
                          onPressed: () {
                            result = false;
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text("common.delete").tr(),
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
                        .removeLecture(lecture: lecture);
                  }
                },
        );
      },
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
      onAddTap: () {
        if (_isSearchOpened) return;
        setState(() {
          _isSearchOpened = true;
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
            leading: const Icon(Icons.image),
            title: const Text("이미지 저장"),
            onTap: () {
              final boundary = _paintKey.currentContext?.findRenderObject()
                  as RenderRepaintBoundary;
              exportImage(boundary);
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
          context.select<TimetableModel, int>((model) => model.selectedIndex) ==
                  0
              ? SizedBox()
              : ListTile(
                  enabled: (context.select<TimetableModel, bool>(
                      (model) => model.timetables.length > 2)),
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

  Route _buildLectureDetailPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (_, animation, __) => LectureDetailPage(),
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final curveTween = CurveTween(curve: Curves.ease);
        final tween = Tween(begin: begin, end: end).chain(curveTween);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
