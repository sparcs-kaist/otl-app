import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/backdrop.dart';
import 'package:timeplanner_mobile/layers/course_detail_layer.dart';
import 'package:timeplanner_mobile/providers/course_detail_model.dart';
import 'package:timeplanner_mobile/widgets/course_search.dart';

class DictionaryPage extends StatelessWidget {
  final _courseDetailLayer = CourseDetailLayer();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: CourseSearch(
        onCourseTap: (course) {
          context.read<CourseDetailModel>().loadCourse(course);
          Backdrop.of(context).show(_courseDetailLayer);
        },
      ),
    );
  }
}
