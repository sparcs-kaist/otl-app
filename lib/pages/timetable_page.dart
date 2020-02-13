import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/models/semester.dart';
import 'package:timeplanner_mobile/models/timetable.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';
import 'package:timeplanner_mobile/widgets/semester_picker.dart';
import 'package:timeplanner_mobile/widgets/timetable.dart' as TimetableWidget;
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
                  child: TimetableWidget.Timetable(
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
      onSettingsTap: (i) async {
        final func = await showDialog<Function(Timetable)>(
            context: context,
            builder: (context) =>
                _buildSetttingDialog(context, timetableModel));
        if (func != null) func(timetableModel.timetables[i]);
      },
    );
  }

  SimpleDialog _buildSetttingDialog(
      BuildContext context, TimetableModel timetableModel) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () => Navigator.pop(
              context,
              (Timetable timetable) =>
                  timetableModel.createTimetable(lectures: timetable.lectures)),
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
          onPressed: () => Navigator.pop(
              context,
              (Timetable timetable) =>
                  timetableModel.deleteTimetable(timetable: timetable)),
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
    );
  }
}
