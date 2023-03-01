import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/providers/lecture_detail_model.dart';
import 'package:otlplus/providers/search_model.dart';
import 'package:otlplus/providers/timetable_model.dart';
import 'package:otlplus/widgets/backdrop.dart';
import 'package:otlplus/widgets/lecture_group_block.dart';
import 'package:otlplus/widgets/search_filter.dart';

class SearchSheetResult extends StatefulWidget {
  const SearchSheetResult({
    Key? key, 
    this.result
  }) : super(key: key);
  final List<List<Lecture>>? result;

  @override
  State<SearchSheetResult> createState() => _SearchSheetResultState();
}

class _SearchSheetResultState extends State<SearchSheetResult> {
  final _scrollController = ScrollController();
  Lecture? _selectedLecture;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 544,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 4, 24, 24),
        child: _buildListView(widget.result ?? [[]]),
      ),
    );
  }

  ListView _buildListView(
      List<List<Lecture>> lectures) {
    return ListView.builder(
      itemCount: lectures.length,
      itemBuilder: (context, index) => LectureGroupBlock(
        lectures: lectures[index],
        selectedLecture: _selectedLecture,
        onTap: (lecture) {
          setState(() {
            _selectedLecture = (_selectedLecture == lecture) ? null : lecture;
            // if (widget.onSelectionChanged != null) {
            //   widget.onSelectionChanged!(_selectedLecture);
            // }
          });
        },
        onLongPress: (lecture) {
          // context.read<LectureDetailModel>().loadLecture(lecture.id, true);
          // Backdrop.of(context).show(2);
        },
      ),
    );
  }
}