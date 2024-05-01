import 'package:flutter/material.dart';
import 'package:otlplus/widgets/otl_scaffold.dart';
import 'package:otlplus/widgets/planner_select.dart';
import 'package:otlplus/widgets/planner_statistic.dart';
import 'package:otlplus/widgets/planner_table.dart';
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
    return OTLLayout(
      leading: PlannerSelect(
        selectedMode: context.watch<HallOfFameModel>().selectedMode,
      ),
      trailing: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.search_outlined,
              color: OTLColor.pinksMain,
            ),
            SizedBox(width: 12,),
            Icon(
              Icons.settings_outlined,
              color: OTLColor.pinksMain,
            ),
          ],
        ),
      ),
      body: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(16.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                PlannerTable(),
                Container(
                  color: OTLColor.grayE,
                  width: double.infinity,
                  height: 4,
                ),
                PlannerStatistic()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
