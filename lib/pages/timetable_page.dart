import 'package:flutter/material.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:otlplus/providers/lecture_search_model.dart';
import 'package:otlplus/widgets/lecture_search.dart';
import 'package:otlplus/widgets/map_view.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/providers/lecture_detail_model.dart';
import 'package:otlplus/providers/timetable_model.dart';
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
    final bottomSheetModel = context.watch<LectureSearchModel>();
    final lectures = context.select<TimetableModel, List<Lecture>>(
        (model) => model.currentTimetable.lectures);
    final mode = context.read<TimetableModel>().selectedMode;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedKey.currentContext != null)
        Scrollable.ensureVisible(_selectedKey.currentContext!);
    });

    return Column(
      children: <Widget>[
        Expanded(
          child: ColoredBox(
            color: grayF,
            child: Column(
              children: <Widget>[
                Container(
                  color: pinksLight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: grayF,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(16)),
                    ),
                    child: _buildTimetableTabs(context),
                  ),
                ),
                const SizedBox(height: 2),
                Expanded(
                  child: () {
                    switch (mode) {
                      case 0:
                      case 1:
                        return _buildTimetableMode(
                            context, lectures, mode == 1);
                      default:
                        return MapView(lectures: lectures);
                    }
                  }(),
                )
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

  Widget _buildTimetableMode(
      BuildContext context, List<Lecture> lectures, bool isExamTime) {
    return Column(
      children: [
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
                  child: _buildTimetable(context, lectures, isExamTime),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: const Divider(color: DIVIDER_COLOR, height: 1.0),
        ),
        if (!isExamTime)
          TimetableSummary(
            lectures: lectures,
            tempLecture: _selectedLecture,
          ),
      ],
    );
  }

  Timetable _buildTimetable(
      BuildContext context, List<Lecture> lectures, bool isExamTime) {
    bool isFirst = true;
    final bottomSheetModel = context.watch<LectureSearchModel>();

    return Timetable(
      lectures: (bottomSheetModel.selectedLecture == null)
          ? lectures
          : [...lectures, _selectedLecture!],
      isExamTime: isExamTime,
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
          isExamTime: isExamTime,
          onTap: () {
            context.read<LectureDetailModel>().loadLecture(lecture.id, true);
            Navigator.push(context, buildLectureDetailPageRoute());
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
      onCopyTap: () {
        final timetableModel = context.read<TimetableModel>();
        timetableModel.createTimetable(
            lectures: timetableModel.currentTimetable.lectures);
        /*if (_isSearchOpened) return;
        setState(() {
          _isSearchOpened = true;
          _selectedLecture = null;
        });*/
      },
      onDeleteTap: () {
        showGeneralDialog(
          context: context,
          barrierColor: Colors.black.withOpacity(0.2),
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          pageBuilder: (context, _, __) =>
              _buildDeleteDialog(context, timetableModel.selectedIndex),
        );
      },
      onExportTap: (type) {
        context
            .read<TimetableModel>()
            .shareTimetable(type, context.locale.languageCode);
      },
    );
  }

  Widget _buildDeleteDialog(BuildContext context, int i) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 19, 16, 20),
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Text(
                    '시간표 $i을(를) 정말 삭제하시겠습니까?',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          color: BLOCK_COLOR,
                          child: Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.read<TimetableModel>().deleteTimetable();
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          color: PRIMARY_COLOR,
                          child: Text(
                            '삭제',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
