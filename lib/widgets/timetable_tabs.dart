import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';

class TimetableTabs extends StatefulWidget {
  final int length;
  final Function(int) onTap;
  final Function(int) onDuplicate;
  final Function(int) onDelete;

  TimetableTabs(
      {@required this.length,
      @required this.onTap,
      @required this.onDuplicate,
      @required this.onDelete});

  @override
  _TimetableTabsState createState() => _TimetableTabsState();
}

class _TimetableTabsState extends State<TimetableTabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(widget.length + 1, (i) => _buildTab(i)),
    );
  }

  Widget _buildTab(int i) {
    return Card(
      color: (_index == i) ? Colors.white : TAB_COLOR,
      margin: const EdgeInsets.only(left: 4.0, right: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4.0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4.0)),
          onTap: () {
            setState(() {
              _index = i;
              widget.onTap(i);
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 7.0,
            ),
            child: Text(
              (i == widget.length) ? "+" : "시간표 ${i + 1}",
              style: TextStyle(fontSize: 11.0),
            ),
          ),
        ),
      ),
    );
  }
}
