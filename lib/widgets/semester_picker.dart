import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/extensions/semester.dart';
import 'package:timeplanner_mobile/models/semester.dart';

class SemesterPicker extends StatefulWidget {
  final bool isExamTime;
  final List<Semester> semesters;
  final Function(int) onSemesterChanged;
  final VoidCallback onTap;

  SemesterPicker(
      {this.isExamTime = false,
      @required this.semesters,
      @required this.onSemesterChanged,
      this.onTap});

  @override
  _SemesterPickerState createState() => _SemesterPickerState();
}

class _SemesterPickerState extends State<SemesterPicker> {
  int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.semesters.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semester = widget.semesters[_index];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildLeftButton(theme),
        _buildTitle(context, semester),
        _buildRightButton(theme),
      ],
    );
  }

  Widget _buildRightButton(ThemeData theme) {
    return InkWell(
      onTap: _index == widget.semesters.length - 1
          ? null
          : () {
              setState(() {
                _index++;
                widget.onSemesterChanged(_index);
              });
            },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          Icons.chevron_right,
          color: _index == widget.semesters.length - 1
              ? theme.disabledColor
              : theme.iconTheme.color,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, Semester semester) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          semester.title + (widget.isExamTime ? " 시험" : " 수업"),
          style: const TextStyle(fontSize: 14.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLeftButton(ThemeData theme) {
    return InkWell(
      onTap: _index == 0
          ? null
          : () {
              setState(() {
                _index--;
                widget.onSemesterChanged(_index);
              });
            },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          Icons.chevron_left,
          color: _index == 0 ? theme.disabledColor : theme.iconTheme.color,
        ),
      ),
    );
  }
}
