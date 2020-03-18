import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/providers/search_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';
import 'package:timeplanner_mobile/widgets/course_lectures_block.dart';
import 'package:timeplanner_mobile/widgets/custom_appbar.dart';
import 'package:timeplanner_mobile/widgets/timetable.dart';
import 'package:timeplanner_mobile/widgets/timetable_block.dart';

class LectureAddPage extends StatefulWidget {
  @override
  _LectureAddPageState createState() => _LectureAddPageState();
}

class _LectureAddPageState extends State<LectureAddPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TimetableModel>(
          builder: (context, timetableModel, _) {
            return Column(
              children: <Widget>[
                Flexible(
                  flex: 3,
                  child: _buildTimetable(timetableModel),
                ),
                const SizedBox(height: 8.0),
                Flexible(
                  flex: 2,
                  child: _buildLectureList(timetableModel),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLectureList(TimetableModel timetableModel) {
    final searchModel = Provider.of<SearchModel>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TextField(
                autofocus: true,
                controller: _searchController,
                onSubmitted: (value) {
                  searchModel.search(timetableModel.selectedSemester, value);
                  _searchController.clear();
                },
                style: TextStyle(fontSize: 14.0),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(),
                  isDense: true,
                  hintText: "검색",
                  hintStyle: TextStyle(
                    color: PRIMARY_COLOR,
                    fontSize: 14.0,
                  ),
                  icon: Icon(
                    Icons.search,
                    color: PRIMARY_COLOR,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<SearchModel>(
                builder: (context, searchModel, _) {
                  if (searchModel.state != SearchState.done) {
                    return Center(
                      child: const CircularProgressIndicator(),
                    );
                  }
                  return Scrollbar(
                    child: ListView.builder(
                      itemCount: searchModel.courses.length,
                      itemBuilder: (context, index) =>
                          _buildCourse(context, searchModel.courses[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimetable(TimetableModel timetableModel) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.white,
                Colors.transparent,
              ],
              stops: <double>[
                0.95,
                1.0,
              ]).createShader(bounds.shift(Offset(-bounds.left, -bounds.top))),
          child: SingleChildScrollView(
            child: Timetable(
              lectures: timetableModel.currentTimetable.lectures,
              builder: (lecture) => TimetableBlock(lecture: lecture),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourse(BuildContext context, List<Lecture> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: BLOCK_COLOR,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: ListTile.divideTiles(
          context: context,
          color: BORDER_BOLD_COLOR,
          tiles: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black87),
                  children: <TextSpan>[
                    TextSpan(
                      text: course.first.commonTitle,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " "),
                    TextSpan(text: course.first.oldCode),
                  ],
                ),
              ),
            ),
            ...course.map((lecture) => CourseLecturesBlock(
                  lecture: lecture,
                  onTap: () {},
                )),
          ],
        ).toList(),
      ),
    );
  }
}
