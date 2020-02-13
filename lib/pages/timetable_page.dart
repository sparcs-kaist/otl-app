import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/models/semester.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';
import 'package:timeplanner_mobile/widgets/semester_picker.dart';
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
          return _buildBody(context, timetableModel, semesters);

        timetableModel.loadTimetable(semester: semesters.last);

        return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TimetableModel timetableModel,
      List<Semester> semesters) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTimetableTabs(context, timetableModel),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(6.0)),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SemesterPicker(
                    semesters: semesters,
                    onSemesterChanged: (index) => timetableModel.loadTimetable(
                        semester: semesters[index]),
                  ),
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

  TimetableTabs _buildTimetableTabs(
      BuildContext context, TimetableModel timetableModel) {
    return TimetableTabs(
      index: timetableModel.selectedIndex,
      length: timetableModel.timetables.length,
      onTap: (i) {
        if (i > 0 && i == timetableModel.timetables.length)
          timetableModel.createTimetable();
        else
          timetableModel.setIndex(i);
      },
      onSettingsTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => _buildSettingsSheet(context, timetableModel));
      },
    );
  }

  Widget _buildSettingsSheet(
      BuildContext context, TimetableModel timetableModel) {
    return Container(
      color: Colors.white,
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.content_copy),
            title: const Text("복제"),
            onTap: () {
              timetableModel.createTimetable(
                  lectures: timetableModel.currentTimetable.lectures);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("삭제"),
            onTap: () {
              timetableModel.deleteTimetable();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
