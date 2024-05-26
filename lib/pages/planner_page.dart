import 'package:flutter/material.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/providers/planner_model.dart';
import 'package:otlplus/providers/track_model.dart';
import 'package:otlplus/widgets/otl_scaffold.dart';
import 'package:otlplus/widgets/planner_preview.dart';
import 'package:otlplus/widgets/planner_select.dart';
import 'package:otlplus/widgets/planner_semester.dart';
import 'package:otlplus/widgets/planner_semester_select_tabs.dart';
import 'package:otlplus/widgets/timetable.dart';
import 'package:provider/provider.dart';
import '../constants/color.dart';
import '../providers/hall_of_fame_model.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({Key? key}) : super(key: key);

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  @override
  Widget build(BuildContext context) {
    final planners = Provider.of<PlannerModel>(context);

    return OTLLayout(
      leading: PlannerSelect(),
      trailing: Container(
        padding: EdgeInsets.all(16),
        child: Icon(
          Icons.settings_outlined,
          color: OTLColor.pinksMain,
        ),
      ),
      body: !planners.isLoaded?
        Center(
          child: CircularProgressIndicator(),
        ):
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(16.0)),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  PlannerPreview(),
                  SizedBox(
                    height: 16,
                  ),
                  PlannerSemesterSelectTabs(
                    onTap: (i) {},
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  PlannerSemester(),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
