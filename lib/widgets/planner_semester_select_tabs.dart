import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/providers/planner_model.dart';
import 'package:provider/provider.dart';

class PlannerSemesterSelectTabs extends StatefulWidget {
  final int index;
  final Function(int) onTap;

  PlannerSemesterSelectTabs({
    this.index = 0,
    required this.onTap,
  });

  @override
  State<PlannerSemesterSelectTabs> createState() =>
      _PlannerSemesterSelectTabsState();
}

class _PlannerSemesterSelectTabsState extends State<PlannerSemesterSelectTabs> {
  String _key = "";
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final planners = Provider.of<PlannerModel>(context);
    List semester = planners.lectures.keys.toList();
    List semester_excluded = planners.lectures_excluded.keys.toList();
    List semester_future = planners.lectures_future.keys.toList();
    List semester_future_excluded =
        planners.lectures_future_excluded.keys.toList();

    for (int i = 0; i < semester_excluded.length; i++) {
      if (!semester.contains(semester_excluded[i])) {
        semester.add(semester_excluded[i]);
      }
    }
    for (int i = 0; i < semester_future.length; i++) {
      if (!semester.contains(semester_future[i])) {
        semester.add(semester_future[i]);
      }
    }
    for (int i = 0; i < semester_future_excluded.length; i++) {
      if (!semester.contains(semester_future_excluded[i])) {
        semester.add(semester_future_excluded[i]);
      }
    }
    semester.sort();
    _key = planners.selectedSemesterKey;

    return Container(
      height: 28,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: semester.length,
        itemBuilder: (context, i) => _buildTab(i, context),
      ),
    );
  }

  Widget _buildTab(int i, BuildContext context) {
    final planners = Provider.of<PlannerModel>(context);
    List semester = planners.lectures.keys.toList();
    List semester_excluded = planners.lectures_excluded.keys.toList();
    List semester_future = planners.lectures_future.keys.toList();
    List semester_future_excluded =
        planners.lectures_future_excluded.keys.toList();

    for (int i = 0; i < semester_excluded.length; i++) {
      if (!semester.contains(semester_excluded[i])) {
        semester.add(semester_excluded[i]);
      }
    }
    for (int i = 0; i < semester_future.length; i++) {
      if (!semester.contains(semester_future[i])) {
        semester.add(semester_future[i]);
      }
    }
    for (int i = 0; i < semester_future_excluded.length; i++) {
      if (!semester.contains(semester_future_excluded[i])) {
        semester.add(semester_future_excluded[i]);
      }
    }
    semester.sort();
    Map _seme = {'1': '봄', '2': '여름', '3': '가을', '4': '겨울'};

    Text text = Text(
      semester[i].split(' ')[0] + _seme[semester[i].split(' ')[1]],
      style: bodyBold.copyWith(
          color: semester[i] == _key ? OTLColor.grayF : OTLColor.gray0),
      textAlign: TextAlign.center,
    );

    if (semester[i] == _key) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          height: 28,
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          decoration: BoxDecoration(
            color: OTLColor.pinksMain,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [text],
          ),
        ),
      );
    }

    return Container(
      height: 28,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: OTLColor.pinksLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: () {
          planners.setPLannerSemester(semester[i]);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: text,
        ),
      ),
    );
  }
}
