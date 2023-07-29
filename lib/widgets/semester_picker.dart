import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          context.watch<TimetableModel>().selectedSemester.title,
          style: displayBold.copyWith(height: 1.448),
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
      child: Icon(
        Icons.navigate_before_outlined,
        color: context.watch<TimetableModel>().canGoPreviousSemester()
            ? OTLColor.gray0
            : OTLColor.grayA,
        size: 24,
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
      child: Icon(
        Icons.navigate_next_outlined,
        color:
            context.watch<TimetableModel>().canGoNextSemester() ? OTLColor.gray0 : OTLColor.grayA,
        size: 24,
      ),
    );
  }
}
