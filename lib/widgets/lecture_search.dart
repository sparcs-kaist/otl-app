import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:timeplanner_mobile/providers/search_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';
import 'package:timeplanner_mobile/widgets/course_lectures_block.dart';
import 'package:timeplanner_mobile/widgets/lecture_filter.dart';

final departments = {
  "ALL": "전체",
  "HSS": "인문",
  "CE": "건환",
  "MSB": "기경",
  "ME": "기계",
  "PH": "물리",
  "BiS": "바공",
  "IE": "산공",
  "ID": "산디",
  "BS": "생명",
  "CBE": "생화공",
  "MAS": "수리",
  "MS": "신소재",
  "NQE": "원양",
  "CS": "전산",
  "EE": "전자",
  "AE": "항공",
  "CH": "화학",
  "ETC": "기타",
};

final types = {
  "ALL": "전체",
  "BR": "기필",
  "BE": "기선",
  "MR": "전필",
  "ME": "전선",
  "MGC": "교필",
  "HSE": "인선",
  "GR": "공통",
  "EG": "석박",
  "OE": "자선",
  "ETC": "기타",
};

final grades = {
  "ALL": "전체",
  "100": "100번대",
  "200": "200번대",
  "300": "300번대",
  "400": "400번대",
  "ETC": "기타",
};

class LectureSearch extends StatefulWidget {
  final VoidCallback onClosed;
  final void Function(Lecture) onSelectionChanged;

  LectureSearch({this.onClosed, this.onSelectionChanged});

  @override
  _LectureSearchState createState() => _LectureSearchState();
}

class _LectureSearchState extends State<LectureSearch> {
  final _searchTextController = TextEditingController();

  FocusNode _focusNode;
  Lecture _selectedLecture;
  String _department;
  String _type;
  String _grade;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Wrap(
        children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(width: 12.0),
              Expanded(
                child: TextField(
                  autofocus: true,
                  controller: _searchTextController,
                  focusNode: _focusNode,
                  onSubmitted: (value) {
                    context.read<SearchModel>().search(
                        context.read<TimetableModel>().selectedSemester, value,
                        department: _department, type: _type, grade: _grade);
                    _searchTextController.clear();

                    setState(() {
                      _selectedLecture = null;
                      widget.onSelectionChanged(_selectedLecture);
                    });
                  },
                  style: const TextStyle(fontSize: 14.0),
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
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: (_selectedLecture == null ||
                        context.select<TimetableModel, bool>((model) =>
                            model.currentTimetable.lectures
                                .where((lecture) =>
                                    lecture.oldCode == _selectedLecture.oldCode)
                                .length >
                            0))
                    ? null
                    : () {
                        widget.onClosed();
                        context.read<TimetableModel>().updateTimetable(
                              lecture: _selectedLecture,
                              onOverlap: (lectures) async {
                                bool result = false;

                                await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    title: const Text("수업 추가"),
                                    content: const Text(
                                        "시간이 겹치는 수업이 있습니다. 추가하시면 해당 수업은 삭제됩니다.\n시간표에 추가하시겠습니까?"),
                                    actions: [
                                      TextButton(
                                        child: const Text("취소"),
                                        onPressed: () {
                                          result = false;
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("추가하기"),
                                        onPressed: () {
                                          result = true;
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );

                                return result;
                              },
                            );
                      },
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: widget.onClosed,
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
            child: Row(
              children: [
                LectureFilter(
                  property: "학과",
                  items: departments,
                  onChanged: (value) {
                    _department = value;
                    _focusNode.requestFocus();
                  },
                ),
                const SizedBox(width: 6.0),
                LectureFilter(
                  property: "구분",
                  items: types,
                  onChanged: (value) {
                    _type = value;
                    _focusNode.requestFocus();
                  },
                ),
                const SizedBox(width: 6.0),
                LectureFilter(
                  property: "학년",
                  items: grades,
                  onChanged: (value) {
                    _grade = value;
                    _focusNode.requestFocus();
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: (context.watch<SearchModel>().state != SearchState.done)
                ? Center(
                    child: const CircularProgressIndicator(),
                  )
                : Scrollbar(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      children: context
                          .select<SearchModel, List<List<Lecture>>>(
                              (model) => model.courses)
                          .map((course) => _buildCourse(context, course))
                          .toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourse(BuildContext context, List<Lecture> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
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
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black87),
                  children: <TextSpan>[
                    TextSpan(
                      text: course.first.commonTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: " "),
                    TextSpan(text: course.first.oldCode),
                  ],
                ),
              ),
            ),
            ...course.map((lecture) => CourseLecturesBlock(
                  lecture: lecture,
                  isSelected: _selectedLecture == lecture,
                  onTap: () {
                    setState(() {
                      _selectedLecture =
                          (_selectedLecture == lecture) ? null : lecture;
                      widget.onSelectionChanged(_selectedLecture);
                    });
                  },
                )),
          ],
        ).toList(),
      ),
    );
  }
}
