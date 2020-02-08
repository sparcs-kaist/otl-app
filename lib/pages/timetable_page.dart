import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';
import 'package:timeplanner_mobile/widgets/timetable_block.dart';
import 'package:timeplanner_mobile/widgets/timetable_table.dart';

class TimetablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timetableModel = Provider.of<TimetableModel>(context, listen: false);
    if (timetableModel.state == TimetableState.done) return _buildBody();

    final infoModel = Provider.of<InfoModel>(context, listen: false);
    timetableModel.getTimetable(semester: infoModel.semesters.last);

    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<TimetableModel>(
              builder: (context, timetableModel, _) {
                return TimetableTable(
                  lectureBlocks: timetableModel.timetables.first.lectures
                      .map((lecture) => TimetableBlock(lecture: lecture))
                      .toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
