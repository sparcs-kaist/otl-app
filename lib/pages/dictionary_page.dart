import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/widgets/course_search.dart';

class DictionaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: CourseSearch(),
      ),
    );
  }
}
