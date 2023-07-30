import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/extensions/lecture.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/providers/lecture_detail_model.dart';

class LectureGroupSimpleBlock extends StatelessWidget {
  final List<Lecture> lectures;
  final int semester;
  final String? filter;

  LectureGroupSimpleBlock(
      {required this.lectures, required this.semester, this.filter});

  @override
  Widget build(BuildContext context) {
    final isEn = EasyLocalization.of(context)?.currentLocale == Locale('en');

    return Column(
      children: <Widget>[
        if (semester == 1) const Spacer(),
        Container(
          width: isEn ? 150.0 : 100.0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: ListTile.divideTiles(
              color: OTLColor.gray0,
              tiles: lectures.map((lecture) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: (lectures.first == lecture)
                            ? const Radius.circular(4.0)
                            : Radius.zero,
                        bottom: (lectures.last == lecture)
                            ? const Radius.circular(4.0)
                            : Radius.zero,
                      ),
                      color: (lecture.professors.any((professor) =>
                              professor.professorId.toString() == filter))
                          ? OTLColor.pinksSub
                          : OTLColor.grayE,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context
                              .read<LectureDetailModel>()
                              .loadLecture(lecture.id, false);
                          Navigator.push(
                            context,
                            buildLectureDetailPageRoute(),
                          );
                        },
                        borderRadius: BorderRadius.vertical(
                          top: (lectures.first == lecture)
                              ? const Radius.circular(4.0)
                              : Radius.zero,
                          bottom: (lectures.last == lecture)
                              ? const Radius.circular(4.0)
                              : Radius.zero,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Text.rich(
                            TextSpan(
                              style: bodyRegular,
                              children: [
                                TextSpan(
                                  text: lecture.classTitle,
                                  style: bodyBold,
                                ),
                                TextSpan(text: ' '),
                                TextSpan(
                                  text: isEn
                                      ? lecture.professorsStrShortEn
                                      : lecture.professorsStrShort,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
            ).toList(),
          ),
        ),
        if (semester == 3) const Spacer(),
      ],
    );
  }
}
