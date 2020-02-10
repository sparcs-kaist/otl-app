import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/models/semester.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';
import 'package:timeplanner_mobile/widgets/semester_left_right.dart';
import 'package:timeplanner_mobile/widgets/timetable.dart';
import 'package:timeplanner_mobile/widgets/timetable_tabs.dart';

class TimetablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableModel>(
      builder: (context, timetableModel, _) {
        final semesters =
            Provider.of<InfoModel>(context, listen: false).semesters;

        if (timetableModel.state == TimetableState.done)
          return _buildBody(timetableModel, semesters);

        timetableModel.loadTimetable(semester: semesters.last);

        return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildBody(TimetableModel timetableModel, List<Semester> semesters) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTimetableTabs(timetableModel),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(6.0),
                bottomLeft: Radius.circular(6.0),
                bottomRight: Radius.circular(6.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildTableController(timetableModel, semesters),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Timetable(
                    lectures: timetableModel.currentTimetable.lectures,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableController(
      TimetableModel timetableModel, List<Semester> semesters) {
    return Stack(
      children: <Widget>[
        Center(
          child: SemesterLeftRight(
            semesters: semesters,
            onSemesterChanged: (index) {
              timetableModel.loadTimetable(semester: semesters[index]);
            },
          ),
        ),
        Positioned(
          right: 0,
          child: Row(
            children: <Widget>[
              _buildDuplicateButton(timetableModel),
              _buildDeleteButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return InkWell(
      onTap: () {},
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          Icons.delete,
          size: 12.0,
        ),
      ),
    );
  }

  Widget _buildDuplicateButton(TimetableModel timetableModel) {
    return InkWell(
      onTap: () {
        timetableModel.createTimetable(
            lectures: timetableModel.currentTimetable.lectures);
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          Icons.content_copy,
          size: 12.0,
        ),
      ),
    );
  }

  TimetableTabs _buildTimetableTabs(TimetableModel timetableModel) {
    return TimetableTabs(
      index: timetableModel.selectedIndex,
      length: timetableModel.timetables.length,
      onTap: (i) {
        if (i > 0 && i == timetableModel.timetables.length)
          timetableModel.createTimetable();
        else
          timetableModel.setIndex(i);
      },
      onDuplicate: (i) {},
      onDelete: (i) {},
    );
  }
}
