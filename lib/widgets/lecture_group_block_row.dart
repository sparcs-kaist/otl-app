import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/extensions/lecture.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:provider/provider.dart';

import '../providers/timetable_model.dart';

class LectureGroupBlockRow extends StatefulWidget {
  const LectureGroupBlockRow({
    Key? key,
    required this.lecture,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.isSelected,
  }) : super(key: key);

  final Lecture lecture;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final bool? isSelected;

  @override
  State<LectureGroupBlockRow> createState() => _LectureGroupBlockRowState();
}

class _LectureGroupBlockRowState extends State<LectureGroupBlockRow> {
  
  @override
  Widget build(BuildContext context) {
    final selected0 = context.select<TimetableModel, bool>((model) =>
      model.selectedIndex == 0
    );
    final alreadyAdded = context.select<TimetableModel, bool>((model) =>
      model.currentTimetable.lectures.any((lec) =>
        lec.oldCode == widget.lecture.oldCode
      )
    );
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: GestureDetector(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          child: Container(
            decoration: BoxDecoration(
              color: widget.isSelected ?? false ? SELECTED_COLOR : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: [
                        Text(
                          widget.lecture.classTitle + " ",
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.lecture.professorsStrShort,
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    )
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if(!selected0) {
                      if(alreadyAdded) {
                        _removeLecture(widget.lecture);
                      }
                      else {
                        _addLecture(widget.lecture);
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: selected0
                        ? null
                        : alreadyAdded
                          ? Icon(
                              Icons.remove,
                              size: 18.0,
                              color: PRIMARY_COLOR,
                            )
                          : Icon(
                              Icons.add,
                              size: 18.0,
                              color: Color(0xFF000000),
                            )
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
      // setState(() {
      //   if (widget.onAdded != null) {
      //     widget.onAdded!();
      //   }
      // });
    }
  }

  Future<void> _removeLecture(Lecture lec) async {
    bool result = await context.read<TimetableModel>().removeLecture(
      lecture: lec,
    );
  }
}
