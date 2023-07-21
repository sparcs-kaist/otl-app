import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/extensions/lecture.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/providers/lecture_search_model.dart';
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
              color: selected ? SELECTED_COLOR : null,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(2.0, 4.0, 4.0, 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Wrap(
                      children: [
                        Text.rich(TextSpan(children: <InlineSpan>[
                          if (exp
                                  .allMatches(widget.lecture.classTitle)
                                  .length ==
                              0)
                            WidgetSpan(
                              child: SizedBox(
                                width: 2,
                              ),
                            ),
                          TextSpan(
                              text: widget.lecture.classTitle,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold)),
                          WidgetSpan(
                            child: SizedBox(
                              width: 6,
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
                  SizedBox(
                    width: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: selected,
                          child: GestureDetector(
                            onTap: widget.onLongPress,
                            child: Center(
                                child: Icon(
                              Icons.info_outline,
                              size: 18.0,
                              color: Color(0x66000000),
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (alreadyAdded) {
                              _removeLecture(widget.lecture);
                            } else {
                              _addLecture(widget.lecture);
                            }
                          },
                          child: Center(
                              child: alreadyAdded
                                  ? Icon(
                                      Icons.remove,
                                      size: 18.0,
                                      color: PRIMARY_COLOR,
                                    )
                                  : Icon(
                                      Icons.add,
                                      size: 18.0,
                                      color: Color(0xFF000000),
                                    )),
                        )
                      ],
                    ),
                  )
                ],
              ),
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
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text("수업 추가"),
                content: const Text(
                    "시간이 겹치는 수업이 있습니다. 추가하시면 해당 수업은 삭제됩니다.\n시간표에 추가하시겠습니까?"),
                actions: [
                  TextButton(
                    child: const Text("취소"),
                    onPressed: () {
                      result = false;
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text("추가하기"),
                    onPressed: () {
                      result = true;
                      Navigator.pop(context);
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
