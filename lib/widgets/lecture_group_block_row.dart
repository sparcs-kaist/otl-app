import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              color: selected ? OTLColor.grayD : null,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: SizedBox(
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Wrap(
                        children: [
                          Text.rich(TextSpan(children: <InlineSpan>[
                            TextSpan(
                                text: widget.lecture.classTitle,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold)),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: 50,
                        child: Visibility(
                          visible: selected,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: widget.onLongPress,
                                child: Center(
                                  child: Center(
                                    child: SvgPicture.asset(
                                        'assets/icons/info.svg',
                                        height: 20.0,
                                        width: 20,
                                        colorFilter: ColorFilter.mode(
                                            Color(0xFF000000),
                                            BlendMode.srcIn)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 6.0,
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
                                            size: 24.0,
                                            color: OTLColor.pinksMain,
                                          )
                                        : SvgPicture.asset(
                                            'assets/icons/add.svg',
                                            height: 24.0,
                                            width: 24,
                                            colorFilter: ColorFilter.mode(
                                                Color(0xFF000000),
                                                BlendMode.srcIn))),
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
