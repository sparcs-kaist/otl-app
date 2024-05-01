import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/utils/get_text_height.dart';
import 'package:otlplus/widgets/responsive_button.dart';

class PlannerBlock extends StatelessWidget {
  // final Lecture lecture;
  final String lectureTitle;
  final int lectureType;
  final int lectureCredit;
  final int classTimeIndex;
  final double height;
  final double fontSize;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isTemp;
  final bool isExamTime;
  final bool showTitle;
  final bool showClassroom;

  PlannerBlock(
      {Key? key,
      // required this.lecture,
      required this.lectureTitle,
      required this.lectureType,
      this.lectureCredit = 3,
      this.classTimeIndex = 0,
      this.height = 78,
      this.fontSize = 9.0,
      this.onTap,
      this.onLongPress,
      this.isTemp = false,
      this.isExamTime = false,
      this.showTitle = true,
      this.showClassroom = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contents = <Widget>[];
    final validHeight = height - 16;
    final lineHeight = singleHeight(context, labelRegular);
    int maxLines = (validHeight - lineHeight) ~/ lineHeight;
    final isKo = context.locale == Locale('ko');
    // final title = isKo ? lecture.title : lecture.titleEn;
    final title = lectureTitle;

    const TYPES_SHORT = [
      "br",
      "be",
      "mr",
      "me",
      "hse",
      "etc",
    ];




    if (showTitle && lectureCredit > 1) {
      contents.add(Text(
        title,
        style: labelRegular.copyWith(
          color: isTemp ? OTLColor.grayF : OTLColor.gray0,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: maxLines > 1 ? maxLines : 1,
      ));
    }


    return Container(
      height: lectureCredit*18,
      padding: EdgeInsets.only(top: 1.5, bottom: 1.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.0),
        child: BackgroundButton(
          color: OTLColor.plannerBlockColors[lectureType],
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: EdgeInsets.only(left: 6.0, right: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: contents,
            ),
          ),
        ),
      ),
    );
  }
}
