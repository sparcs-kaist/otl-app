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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: CourseSearch(
          onCourseTap: (course) {
            context.read<CourseDetailModel>().loadCourse(course);
            Backdrop.of(context)
                .toggleBackdropLayerVisibility(_courseDetailLayer);
          },
        ),
      ),
    );
  }
}
