import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';

class TimetableTabs extends StatefulWidget {
  final int index;
  final int length;
  final Function(int) onTap;
  final VoidCallback onAddTap;
  final VoidCallback onSettingsTap;

  TimetableTabs(
      {this.index = 0,
      required this.length,
      required this.onTap,
      required this.onAddTap,
      required this.onSettingsTap});

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
              children: List.generate(
                  widget.length + 1, (i) => _buildTab(i, context)),
            ),
          ),
        ),
        _buildButton(Icons.playlist_add, widget.onAddTap),
        _buildButton(Icons.settings, widget.onSettingsTap),
      ],
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(left: 8.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 7.0,
            ),
            child: Icon(
              icon,
              size: 20.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int i, BuildContext context) {
    return Card(
      color: _index == i ? Colors.white : TAB_COLOR,
      margin: const EdgeInsets.only(right: 10.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
          onTap: _index == i
              ? null
              : () {
                  setState(() {
                    _index = i;
                    widget.onTap(i);
                  });
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 9.0,
            ),
            child: i == widget.length
                ? Icon(
                    Icons.library_add,
                    size: 14,
                  )
                : Text(
                    "시간표 ${i + 1}",
                    style: const TextStyle(fontSize: 12.0),
                  ),
          ),
        ),
      ),
    );
  }
}
