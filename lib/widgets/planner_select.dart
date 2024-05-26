import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/providers/planner_model.dart';
import 'package:otlplus/providers/track_model.dart';
import 'package:otlplus/utils/navigator.dart';
import 'package:otlplus/widgets/dropdown.dart';
import 'package:otlplus/widgets/otl_dialog.dart';
import 'package:provider/provider.dart';

class PlannerSelect extends StatefulWidget {
  const PlannerSelect({Key? key, int selectedMode = 0})
      : super(key: key);

  @override
  State<PlannerSelect> createState() => _PlannerSelectState();
}

class _PlannerSelectState extends State<PlannerSelect> {
  bool dropdown = false;
  @override
  Widget build(BuildContext context) {
    final planners = Provider.of<PlannerModel>(context);
    final tracks = Provider.of<TrackModel>(context);

    return Container(
        padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Dropdown<int>(
            customButton: Container(
              height: 34,
              padding: EdgeInsets.fromLTRB(12, 0, 8, 0),
              decoration: BoxDecoration(
                color: OTLColor.pinksMain,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "플래너 " + (planners.selectedIndex).toString(),
                    style: titleBold.copyWith(color: OTLColor.grayF),
                  ),
                  Icon(
                    Icons.expand_more_outlined,
                    color: OTLColor.grayF,
                  ),
                ],
              ),
            ),
            items: makeItems(context),
            offsetFromLeft: true,
            onChanged: (value) {
              if (value == planners.selectedIndex) {
              } else if (value! < planners.planners.length) {
                planners.selectPlanner(value);
              } else if (value == planners.planners.length) {
                //copy
                Future<bool> result = planners.copyPlanner();
                result.then((value) =>
                    planners.selectPlanner(planners.planners.length - 1));
              } else if (value == planners.planners.length + 1) {
                // get general track
                tracks.loadTracks();
                Future<bool> result = planners.createPlanner(
                    tracks.general_tracks, tracks.major_tracks);
                result.then((value) =>
                    planners.selectPlanner(planners.planners.length - 1));
                //add
              } else if (value == planners.planners.length + 2) {
                //delete
                if (planners.planners.length <= 2) {
                  OTLNavigator.pushDialog(
                    context: context,
                    builder: (_) => OTLDialog(
                      type: OTLDialogType.disabledDeleteLastPlannerTab,
                      namedArgs: {
                        'planner': 'planner.tab'
                            .tr(args: [planners.selectedIndex.toString()])
                      },
                    ),
                  );
                } else {
                  OTLNavigator.pushDialog(
                    context: context,
                    builder: (_) => OTLDialog(
                      type: OTLDialogType.deletePlannerTab,
                      namedArgs: {
                        'planner': 'planner.tab'
                            .tr(args: [planners.selectedIndex.toString()])
                      },
                      onTapPos: () =>
                          context.read<PlannerModel>().deletePlanner(),
                    ),
                  );
                }

                // planners.deletePlanner();
              }
            },
          ),
        ));
  }

  List<ItemData<int>> makeItems(BuildContext context) {
    final planners = Provider.of<PlannerModel>(context);
    List<ItemData<int>> items = [];
    for (int i = 1; i < planners.planners.length; i++) {
      if (i == planners.selectedIndex) {
        items.add(ItemData(
          value: i,
          text: "플래너 " + (i).toString(),
          icon: Icons.check_outlined,
        ));
      } else {
        items.add(ItemData(
          value: i,
          text: "플래너 " + (i).toString(),
        ));
      }
    }
    items.add(ItemData(
      value: planners.planners.length,
      text: "플래너 복제",
      icon: Icons.copy,
    ));
    items.add(ItemData(
      value: planners.planners.length + 1,
      text: "플래너 추가",
      icon: Icons.add_outlined,
    ));
    items.add(ItemData(
      value: planners.planners.length + 2,
      text: "플래너 삭제",
      icon: Icons.delete_outlined,
      textColor: OTLColor.red,
      iconColor: OTLColor.red,
    ));
    return items;
  }
}
