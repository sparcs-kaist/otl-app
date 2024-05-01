import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/providers/hall_of_fame_model.dart';
import 'package:provider/provider.dart';

class PlannerSelect extends StatefulWidget {
  const PlannerSelect({Key? key, int selectedMode = 0})
      : _selectedMode = selectedMode,
        super(key: key);
  final int _selectedMode;

  @override
  State<PlannerSelect> createState() => _PlannerSelectState();
}

class _PlannerSelectState extends State<PlannerSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
      child: GestureDetector(
        onTap: () => context.read<HallOfFameModel>().setMode(0),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 34,
          width: 108,
          decoration: BoxDecoration(
            color: OTLColor.pinksMain,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "플래너1",
                style: titleBold.copyWith(color: OTLColor.grayF),
              ),
              Icon(
                Icons.expand_more_outlined,
                color: OTLColor.grayF,
              ),
            ],
          ),
        ),
      )
    );
  }
}
