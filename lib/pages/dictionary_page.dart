import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/providers/course_detail_model.dart';
import 'package:timeplanner_mobile/widgets/backdrop.dart';
import 'package:timeplanner_mobile/widgets/course_search.dart';

class DictionaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: CourseSearch(
        onCourseTap: (course) {
          context.read<CourseDetailModel>().loadCourse(course.id);
          Backdrop.of(context).show(1);
        },
      ),
    );
  }
}
