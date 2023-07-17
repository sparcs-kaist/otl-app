import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:otlplus/providers/lecture_search_model.dart';
import 'package:otlplus/widgets/lecture_search.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/providers/lecture_detail_model.dart';
import 'package:otlplus/providers/timetable_model.dart';
import 'package:otlplus/utils/export_image.dart';
import 'package:otlplus/widgets/backdrop.dart';
import 'package:otlplus/widgets/semester_picker.dart';
import 'package:otlplus/widgets/timetable.dart';
import 'package:otlplus/widgets/timetable_block.dart';
import 'package:otlplus/widgets/timetable_summary.dart';
import 'package:otlplus/widgets/timetable_tabs.dart';
import 'package:easy_localization/easy_localization.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final _selectedKey = GlobalKey();
  final _paintKey = GlobalKey();

  bool _isExamTime = false;

  @override
  Widget build(BuildContext context) {
    if (context.select<TimetableModel, bool>((model) => model.isLoaded))
      return _buildBody(context);
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildBody(BuildContext context) {
    final bottomSheetModel = context.watch<LectureSearchModel>();
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
          child: ColoredBox(
            color: Colors.white,
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
                    context.read<LectureSearchModel>().setSelectedLecture(null);
                    context.read<LectureSearchModel>().setOpened(false);
                    context.read<LectureSearchModel>().lectureClear();
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
                    tempLecture: bottomSheetModel.selectedLecture,
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: context.watch<LectureSearchModel>().resultOpened,
          child: Expanded(
            child: LectureSearch(
              onClosed: () async {
                setState(() {
                  context.read<LectureSearchModel>().setOpened(false);
                  context.read<LectureSearchModel>().setSelectedLecture(null);
                  context.read<LectureSearchModel>().lectureClear();
                });
                return true;
              },
            ),
          ),
        ),
      ],
    );
  }

  Timetable _buildTimetable(BuildContext context, List<Lecture> lectures) {
    bool isFirst = true;
    final bottomSheetModel = context.watch<LectureSearchModel>();

    return Timetable(
      lectures: (bottomSheetModel.selectedLecture == null)
          ? lectures
          : [...lectures, bottomSheetModel.selectedLecture!],
      isExamTime: _isExamTime,
      builder: (lecture, classTimeIndex) {
        final isSelected = bottomSheetModel.selectedLecture == lecture;
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
            Backdrop.of(context).show(2);
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
        context.read<LectureSearchModel>().setSelectedLecture(null);
        context.read<LectureSearchModel>().setOpened(false);
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
}
