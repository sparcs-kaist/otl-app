import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/extensions/lecture.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/providers/lecture_search_model.dart';
import 'package:otlplus/widgets/responsive_button.dart';
import 'package:otlplus/utils/navigator.dart';
import 'package:provider/provider.dart';

import '../providers/timetable_model.dart';

class LectureGroupBlockRow extends StatefulWidget {
  const LectureGroupBlockRow({
    Key? key,
    required this.lecture,
    this.onLongPress,
  }) : super(key: key);

  final Lecture lecture;
  final VoidCallback? onLongPress;

  @override
  State<LectureGroupBlockRow> createState() => _LectureGroupBlockRowState();
}

class _LectureGroupBlockRowState extends State<LectureGroupBlockRow> {
  RegExp exp = new RegExp(r"[^A-Z]");
  @override
  Widget build(BuildContext context) {
    final alreadyAdded = context.select<TimetableModel, bool>((model) =>
        model.currentTimetable.lectures.any((lec) =>
            lec.oldCode == widget.lecture.oldCode &&
            widget.lecture.classTitle == lec.classTitle));
    bool selected =
        context.watch<LectureSearchModel>().selectedLecture == widget.lecture;
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: GestureDetector(
          onTap: () {
            if (context.read<LectureSearchModel>().selectedLecture !=
                widget.lecture) {
              context
                  .read<LectureSearchModel>()
                  .setSelectedLecture(widget.lecture);
            } else {
              context.read<LectureSearchModel>().setSelectedLecture(null);
            }
          },
          onLongPress: widget.onLongPress,
          child: Container(
            decoration: BoxDecoration(
              color: selected ? OTLColor.grayD : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 0, 6),
                    child: Wrap(
                      children: [
                        Text.rich(TextSpan(children: <InlineSpan>[
                          TextSpan(
                              text: widget.lecture.classTitle,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold)),
                          WidgetSpan(
                            child: SizedBox(
                              width: 8,
                            ),
                          ),
                          WidgetSpan(
                              child: Text(widget.lecture.professorsStrShort,
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.black54)))
                        ]))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 50,
                    child: Visibility(
                      visible: selected,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconTextButton(
                            icon: 'assets/icons/info.svg',
                            iconSize: 20.0,
                            onTap: widget.onLongPress,
                            color: Color(0xFF000000),
                          ),
                          SizedBox(
                            width: 6.0,
                          ),
                          IconTextButton(
                            onTap: () {
                              if (alreadyAdded) {
                                _removeLecture(widget.lecture);
                              } else {
                                _addLecture(widget.lecture);
                              }
                            },
                            icon: alreadyAdded
                                ? Icons.remove
                                : 'assets/icons/add.svg',
                            iconSize: 24,
                            color: alreadyAdded
                                ? OTLColor.pinksMain
                                : Color(0xFF000000),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addLecture(Lecture lec) async {
    bool result = await context.read<TimetableModel>().addLecture(
          lecture: lec,
          onOverlap: (lectures) async {
            bool result = false;
            await OTLNavigator.pushDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text("수업 추가"),
                content: const Text(
                    "시간이 겹치는 수업이 있습니다. 추가하시면 해당 수업은 삭제됩니다.\n시간표에 추가하시겠습니까?"),
                actions: [
                  IconTextButton(
                    padding: EdgeInsets.all(12),
                    text: 'common.cancel'.tr(),
                    color: OTLColor.pinksMain,
                    onTap: () {
                      result = false;
                      OTLNavigator.pop(context);
                    },
                  ),
                  IconTextButton(
                    padding: EdgeInsets.all(12),
                    text: 'common.add'.tr(),
                    color: OTLColor.pinksMain,
                    onTap: () {
                      result = true;
                      OTLNavigator.pop(context);
                    },
                  ),
                ],
              ),
            );
            return result;
          },
        );
    if (result) {
      context.read<LectureSearchModel>().setSelectedLecture(null);
    }
  }

  Future<void> _removeLecture(Lecture lec) async {
    await context.read<TimetableModel>().removeLecture(
          lecture: lec,
        );
    context.read<LectureSearchModel>().setSelectedLecture(null);
  }
}
