import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/utils/responsive_button.dart';
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
    return IconTextButton(
      onTap: widget.onTap,
      padding: const EdgeInsets.all(8.0),
      text: context.watch<TimetableModel>().selectedSemester.title,
      textStyle: displayBold.copyWith(height: 1.448),
    );
  }

  Widget _buildLeftButton(ThemeData theme) {
    return IconTextButton(
        onTap: context.watch<TimetableModel>().canGoPreviousSemester()
            ? () {
                context.read<TimetableModel>().goPreviousSemester();
                widget.onSemesterChanged();
              }
            : null,
        icon: Icons.navigate_before_outlined,
        iconSize: 24,
        color: context.watch<TimetableModel>().canGoPreviousSemester()
            ? OTLColor.gray0
            : OTLColor.grayA,
        padding: const EdgeInsets.all(4.0),
        tapEffect: context.watch<TimetableModel>().canGoNextSemester()
            ? 'lighten'
            : 'none');
  }

  Widget _buildRightButton(ThemeData theme) {
    return IconTextButton(
        onTap: context.watch<TimetableModel>().canGoNextSemester()
            ? () {
                context.read<TimetableModel>().goNextSemester();
                widget.onSemesterChanged();
              }
            : null,
        icon: Icons.navigate_next_outlined,
        iconSize: 24,
        color: context.watch<TimetableModel>().canGoNextSemester()
            ? OTLColor.gray0
            : OTLColor.grayA,
        padding: const EdgeInsets.all(4.0),
        tapEffect: context.watch<TimetableModel>().canGoNextSemester()
            ? 'lighten'
            : 'none');
  }
}
