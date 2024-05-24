import 'package:flutter/material.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/providers/planner_model.dart';
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
    // final mode =
    // context.select<PlannerModel, int>((model) => model.user);
    if(!planners.isLoaded){
      return OTLLayout(
        body: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text(
                "불러오는 중",
                style: bodyRegular.copyWith(color: OTLColor.pinksMain),
              ),
            ],
          ),
        ),
      );
    }
    return OTLLayout(
      leading: PlannerSelect(),
      trailing: Container(
        padding: EdgeInsets.all(16),
        child: Icon(
          Icons.settings_outlined,
          color: OTLColor.pinksMain,
        ),
      ),
      body: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(16.0)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Text("ID : "+planners.planners[planners.selectedIndex].id.toString()),
                // Text("Start Year : "+planners.planners[planners.selectedIndex].start_year.toString()),
                // Text("End Year : "+planners.planners[planners.selectedIndex].end_year.toString()),
                // Text("General Track Total Credit : "+planners.planners[planners.selectedIndex].general_track.total_credit.toString()),

                PlannerPreview(),
                SizedBox(height: 16,),
                PlannerSemesterSelectTabs(
                  onTap: (i){},
                ),
                SizedBox(height: 16,),
                PlannerSemester(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
