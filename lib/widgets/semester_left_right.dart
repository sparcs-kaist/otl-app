import 'package:flutter/material.dart';
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
  final _semesterNames = ["봄", "여름", "가을", "겨울"];
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
          InkWell(
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
                color:
                    _index == 0 ? theme.disabledColor : theme.iconTheme.color,
                size: 10.0,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "${semester.year} ${_semesterNames[semester.semester - 1]}",
                style: const TextStyle(fontSize: 12.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          InkWell(
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
          ),
        ],
      ),
    );
  }
}
