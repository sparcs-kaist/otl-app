import 'package:flutter/material.dart';
import 'package:otlplus/pages/course_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/providers/course_detail_model.dart';
import 'package:otlplus/widgets/course_search.dart';

class DictionaryPage extends StatelessWidget {
  // static String route = 'dictionary_page';

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: CourseSearch(
        onCourseTap: (course) {
          context.read<CourseDetailModel>().loadCourse(course.id);
          // Backdrop.of(context).show(1);
          Navigator.pushNamed(context, CourseDetailPage.route);
        },
      ),
    );
  }
}
