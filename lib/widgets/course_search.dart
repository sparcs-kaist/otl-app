import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/course.dart';
import 'package:otlplus/providers/search_model.dart';
import 'package:otlplus/widgets/course_block.dart';
import 'package:otlplus/widgets/search_filter.dart';

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
  "TS": "융인",
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

final levels = {
  "ALL": "전체",
  "100": "100번대",
  "200": "200번대",
  "300": "300번대",
  "400": "400번대",
  "ETC": "기타",
};

final orders = {
  "DEF": "기본순",
  "RAT": "평점순",
  "GRA": "성적순",
  "LOA": "널널순",
  "SPE": "강의순",
};

final terms = {
  "ALL": "전체",
  "1": "1년 이내",
  "2": "2년 이내",
  "3": "3년 이내",
};

class CourseSearch extends StatefulWidget {
  final void Function(Course)? onCourseTap;

  CourseSearch({this.onCourseTap});

  @override
  _CourseSearchState createState() => _CourseSearchState();
}

class _CourseSearchState extends State<CourseSearch> {
  final _searchTextController = TextEditingController();

  late FocusNode _focusNode;
  List<String> _department = [departments.keys.first];
  List<String> _type = [types.keys.first];
  List<String> _level = [levels.keys.first];
  String _order = orders.keys.first;
  String _term = terms.keys.first;

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
    final searchModel = context.watch<SearchModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchTextController,
            focusNode: _focusNode,
            onSubmitted: (value) {
              context.read<SearchModel>().courseSearch(value,
                  department: _department,
                  type: _type,
                  level: _level,
                  order: _order,
                  term: _term);
              _searchTextController.clear();
            },
            style: const TextStyle(fontSize: 14.0),
            decoration: const InputDecoration(
              hintText: "검색",
              icon: Icon(
                Icons.search,
                color: PRIMARY_COLOR,
              ),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
          child: Row(
            children: <Widget>[
              SearchFilter(
                property: "학과",
                items: departments,
                isMultiSelect: true,
                onChanged: (value) {
                  _department = value;
                  _focusNode.requestFocus();
                },
              ),
              const SizedBox(width: 6.0),
              SearchFilter(
                property: "구분",
                items: types,
                isMultiSelect: true,
                onChanged: (value) {
                  _type = value;
                  _focusNode.requestFocus();
                },
              ),
              const SizedBox(width: 6.0),
              SearchFilter(
                property: "학년",
                items: levels,
                isMultiSelect: true,
                onChanged: (value) {
                  _level = value;
                  _focusNode.requestFocus();
                },
              ),
              const SizedBox(width: 6.0),
              SearchFilter(
                property: "정렬",
                items: orders,
                onChanged: (value) {
                  _order = value;
                  _focusNode.requestFocus();
                },
              ),
              const SizedBox(width: 6.0),
              SearchFilter(
                property: "기간",
                items: terms,
                onChanged: (value) {
                  _term = value;
                  _focusNode.requestFocus();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: searchModel.isSearching
              ? Center(
                  child: const CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: searchModel.courses?.length ?? 0,
                      itemBuilder: (context, index) => CourseBlock(
                        course: searchModel.courses![index],
                        onTap: () =>
                            widget.onCourseTap!(searchModel.courses![index]),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
