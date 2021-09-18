import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/extensions/semester.dart';
import 'package:otlplus/providers/timetable_model.dart';

class SemesterPicker extends StatefulWidget {
  final bool isExamTime;
  final Function() onSemesterChanged;
  final VoidCallback? onTap;

  SemesterPicker(
      {this.isExamTime = false, required this.onSemesterChanged, this.onTap});

  @override
  _SemesterPickerState createState() => _SemesterPickerState();
}

class _SemesterPickerState extends State<SemesterPicker> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildLeftButton(theme),
        _buildTitle(context),
        _buildRightButton(theme),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          context.watch<TimetableModel>().selectedSemester.title +
              (widget.isExamTime ? " 시험" : " 수업"),
          style: const TextStyle(fontSize: 14.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLeftButton(ThemeData theme) {
    return InkWell(
      onTap: context.watch<TimetableModel>().canGoPreviousSemester()
          ? () {
              context.read<TimetableModel>().goPreviousSemester();
              widget.onSemesterChanged();
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          Icons.chevron_left,
          color: context.watch<TimetableModel>().canGoPreviousSemester()
              ? theme.iconTheme.color
              : theme.disabledColor,
        ),
      ),
    );
  }

  Widget _buildRightButton(ThemeData theme) {
    return InkWell(
      onTap: context.watch<TimetableModel>().canGoNextSemester()
          ? () {
              context.read<TimetableModel>().goNextSemester();
              widget.onSemesterChanged();
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          Icons.chevron_right,
          color: context.watch<TimetableModel>().canGoNextSemester()
              ? theme.iconTheme.color
              : theme.disabledColor,
        ),
      ),
    );
  }
}
