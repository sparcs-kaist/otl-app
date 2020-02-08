import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';

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
    return Consumer<TimetableModel>(
      builder: (context, timetableModel, _) {
        return ListView(
          children: timetableModel.timetables.first.lectures
              .map((lecture) => Card(
                    color: TIMETABLE_BLOCK_COLORS[lecture.course % 16],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(lecture.title),
                          Text(lecture.professors.first.name),
                          Text(lecture.classroom),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }
}
