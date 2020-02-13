import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';

class TimetableTabs extends StatefulWidget {
  final int index;
  final int length;
  final Function(int) onTap;
  final Function(int) onSettingsTap;

  TimetableTabs(
      {this.index = 0,
      @required this.length,
      @required this.onTap,
      @required this.onSettingsTap});

  @override
  _TimetableTabsState createState() => _TimetableTabsState();
}

class _TimetableTabsState extends State<TimetableTabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    _index = widget.index;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                  widget.length + 1, (i) => _buildTab(i, context)),
            ),
          ),
        ),
        Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4.0)),
              onTap: () => widget.onSettingsTap(_index),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 7.0,
                ),
                child: const Icon(
                  Icons.settings,
                  size: 16.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(int i, BuildContext context) {
    return Card(
      color: _index == i ? Colors.white : TAB_COLOR,
      margin: const EdgeInsets.only(left: 4.0, right: 6.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4.0)),
          onTap: _index == i
              ? null
              : () {
                  setState(() {
                    _index = i;
                    widget.onTap(i);
                  });
                },
          onLongPress:
              i == widget.length ? null : () => widget.onSettingsTap(i),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 7.0,
            ),
            child: Text(
              i == widget.length ? "+" : "시간표 ${i + 1}",
              style: const TextStyle(fontSize: 11.0),
            ),
          ),
        ),
      ),
    );
  }
}
