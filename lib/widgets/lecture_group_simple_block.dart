import 'package:flutter/material.dart';
import 'package:otlplus/pages/lecture_detail_page.dart';
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
    return Column(
      children: <Widget>[
        if (semester == 1) const Spacer(),
        Container(
          width: 110.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: ListTile.divideTiles(
              color: BORDER_BOLD_COLOR,
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
                          ? SELECTED_COLOR
                          : BLOCK_COLOR,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context
                              .read<LectureDetailModel>()
                              .loadLecture(lecture.id, false);
                          // Backdrop.of(context).show(2);
                          Navigator.push(
                            context,
                            _buildLectureDetailPageRoute(),
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
                            horizontal: 10.0,
                            vertical: 4.0,
                          ),
                          child: Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 12.0,
                                height: 1.3,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: lecture.classTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: " "),
                                TextSpan(text: lecture.professorsStrShort),
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

  Route _buildLectureDetailPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (_, animation, __) => LectureDetailPage(),
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final curveTween = CurveTween(curve: Curves.ease);
        final tween = Tween(begin: begin, end: end).chain(curveTween);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
