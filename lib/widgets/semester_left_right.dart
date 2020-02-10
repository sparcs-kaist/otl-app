import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/extensions/semester.dart';
import 'package:timeplanner_mobile/models/semester.dart';

class SemesterLeftRight extends StatefulWidget {
  final List<Semester> semesters;
  final Function(int) onSemesterChanged;

  SemesterLeftRight(
      {@required this.semesters, @required this.onSemesterChanged});

  @override
  _SemesterLeftRightState createState() => _SemesterLeftRightState();
}

class _SemesterLeftRightState extends State<SemesterLeftRight> {
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

    return SizedBox(
      width: 120,
      child: Row(
        children: <Widget>[
          _buildLeftButton(theme),
          Expanded(child: _buildTitle(context, semester)),
          _buildRightButton(theme),
        ],
      ),
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
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.arrow_forward_ios,
          color: _index == widget.semesters.length - 1
              ? theme.disabledColor
              : theme.iconTheme.color,
          size: 10.0,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, Semester semester) {
    return InkWell(
      onTap: () async {
        final index = await showDialog<int>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text(
              "학기 선택",
              style: TextStyle(fontSize: 16.0),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            children: List.generate(
                widget.semesters.length,
                (i) => SimpleDialogOption(
                      onPressed: () => Navigator.pop(
                          context, widget.semesters.length - i - 1),
                      child: Text(
                        widget.semesters[widget.semesters.length - i - 1].title,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    )),
          ),
        );

        if (index != null) {
          _index = index;
          widget.onSemesterChanged(_index);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          semester.title,
          style: const TextStyle(fontSize: 12.0),
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
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.arrow_back_ios,
          color: _index == 0 ? theme.disabledColor : theme.iconTheme.color,
          size: 10.0,
        ),
      ),
    );
  }
}
