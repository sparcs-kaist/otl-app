import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';

class TimetableTabs extends StatefulWidget {
  final int index;
  final int length;
  final Function(int) onTap;
  final Function(int) onDuplicate;
  final Function(int) onDelete;

  TimetableTabs(
      {this.index = 0,
      @required this.length,
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
    _index = widget.index;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children:
            List.generate(widget.length + 1, (i) => _buildTab(i, context)),
      ),
    );
  }

  Widget _buildTab(int i, BuildContext context) {
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
          onTap: _index == i
              ? null
              : () {
                  setState(() {
                    _index = i;
                    widget.onTap(i);
                  });
                },
          onLongPress: i == widget.length
              ? null
              : () async {
                  final func = await showDialog<Function(int)>(
                      context: context,
                      builder: (context) => SimpleDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            children: <Widget>[
                              SimpleDialogOption(
                                onPressed: () =>
                                    Navigator.pop(context, widget.onDuplicate),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.content_copy,
                                      size: 16.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("복제"),
                                    ),
                                  ],
                                ),
                              ),
                              SimpleDialogOption(
                                onPressed: () =>
                                    Navigator.pop(context, widget.onDelete),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      size: 16.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("삭제"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ));
                  if (func != null) func(i);
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 7.0,
            ),
            child: Text(
              i == widget.length ? "+" : "시간표 ${i + 1}",
              style: TextStyle(fontSize: 11.0),
            ),
          ),
        ),
      ),
    );
  }
}
