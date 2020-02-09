import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';
import 'package:timeplanner_mobile/widgets/timetable.dart';
import 'package:timeplanner_mobile/widgets/timetable_tabs.dart';

class TimetablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableModel>(
      builder: (context, timetableModel, _) {
        if (timetableModel.state == TimetableState.done)
          return _buildBody(timetableModel);

        final infoModel = Provider.of<InfoModel>(context, listen: false);
        timetableModel.getTimetable(semester: infoModel.semesters.last);

        return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildBody(TimetableModel timetableModel) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TimetableTabs(
              length: timetableModel.timetables.length,
              onTap: (i) {
                if (i == timetableModel.timetables.length)
                  print("Table create");
                else
                  timetableModel.setIndex(i);
              },
              onDuplicate: (i) {},
              onDelete: (i) {},
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(6.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Timetable(
                  lectures: timetableModel.currentTimetable.lectures,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
