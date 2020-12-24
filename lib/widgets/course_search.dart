import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/providers/search_model.dart';
import 'package:timeplanner_mobile/widgets/course_block.dart';
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

class CourseSearch extends StatefulWidget {
  @override
  _CourseSearchState createState() => _CourseSearchState();
}

class _CourseSearchState extends State<CourseSearch> {
  final _searchTextController = TextEditingController();

  FocusNode _focusNode;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            autofocus: true,
            controller: _searchTextController,
            focusNode: _focusNode,
            onSubmitted: (value) {
              context.read<SearchModel>().courseSearch(value,
                  department: _department, type: _type, grade: _grade);
              _searchTextController.clear();
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
          child: Row(
            children: <Widget>[
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
        Expanded(
          child: (context.watch<SearchModel>().state != SearchState.done)
              ? Center(
                  child: const CircularProgressIndicator(),
                )
              : Scrollbar(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    children: context.select<SearchModel, List<Widget>>(
                        (model) => model.courses
                            .map((course) => CourseBlock(course))
                            .toList()),
                  ),
                ),
        ),
      ],
    );
  }
}
