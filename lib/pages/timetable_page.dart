import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';
import 'package:timeplanner_mobile/widgets/timetable.dart';

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
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Timetable(
              lectures: timetableModel.timetables.first.lectures,
            ),
          ),
        ),
      ),
    );
  }
}
