import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/models/semester.dart';
import 'package:otlplus/providers/hall_of_fame_model.dart';
import 'package:otlplus/providers/info_model.dart';
import 'package:provider/provider.dart';

class HallOfFameControl extends StatefulWidget {
  HallOfFameControl({
    Key? key,
  }) : super(key: key);

  @override
  State<HallOfFameControl> createState() => _HallOfFameControlState();
}

class _HallOfFameControlState extends State<HallOfFameControl> {
  late List<Semester> _targetSemesters;
  late Semester? _currentSemester;
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    _targetSemesters = context
        .watch<InfoModel>()
        .semesters
        .where((s) =>
            s.year >= 2013 &&
            (s.gradePosting == null ||
                DateTime.now()
                    .isAfter(s.gradePosting!.add(Duration(days: 30)))))
        .toList();
    _currentSemester = context.read<HallOfFameModel>().semeseter;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<Semester?>(
        onMenuStateChange: (isOpen) => _isOpen = isOpen,
        customButton: Container(
          height: 34,
          padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
          decoration: BoxDecoration(
            color: OTLColor.grayF,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              Text(
                _currentSemester == null
                    ? "common.all".tr()
                    : "${_currentSemester?.year} ${_currentSemester?.semester == 1 ? 'semester.spring'.tr() : 'semester.fall'.tr()}",
                style: evenBodyBold.copyWith(
                  color: OTLColor.pinksMain,
                ),
              ),
              const SizedBox(width: 2.0),
              Icon(
                _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: OTLColor.pinksMain,
              ),
            ],
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          direction: DropdownDirection.left,
          maxHeight: 225,
          width: 180,
          elevation: 0,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: OTLColor.gray6,
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: Radius.circular(100),
            mainAxisMargin: 8.0,
            crossAxisMargin: 4.0,
            thickness: MaterialStatePropertyAll(4.0),
            thumbColor: MaterialStatePropertyAll(OTLColor.grayF),
          ),
          offset: const Offset(0, -8),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.zero,
        ),
        items: [
          DropdownMenuItem(
            value: null,
            child: buildItem('common.all'.tr(), _currentSemester == null),
          ),
          ...List.generate(
            _targetSemesters.length,
            (index) => DropdownMenuItem(
              value: _targetSemesters[index],
              child: buildItem(
                "${_targetSemesters[index].year} ${_targetSemesters[index].semester == 1 ? 'semester.spring'.tr() : 'semester.fall'.tr()}",
                _currentSemester == _targetSemesters[index],
              ),
            ),
          ).reversed
        ],
        onChanged: (value) {
          setState(() {
            context.read<HallOfFameModel>().setSemester(value);
            context.read<HallOfFameModel>().clear();
          });
        },
      ),
    );
  }
}

Widget buildItem(String text, bool selected) {
  return Stack(
    alignment: AlignmentDirectional.bottomStart,
    children: [
      Container(
        height: 40,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: bodyRegular.copyWith(color: OTLColor.grayF),
            ),
            selected
                ? Icon(Icons.check, color: OTLColor.grayF)
                : SizedBox(width: 24.0),
          ],
        ),
      ),
      Container(
        color: OTLColor.grayF.withOpacity(0.5),
        height: 0.5,
      ),
    ],
  );
}
