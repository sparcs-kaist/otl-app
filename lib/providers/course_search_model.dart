import 'package:flutter/material.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/models/filter.dart';
import 'package:otlplus/models/course.dart';

class CourseSearchModel extends ChangeNotifier {
  List<Course>? _courses;
  List<Course>? get courses => _courses ?? [];

  String _courseSearchText = '';
  String get courseSearchText => _courseSearchText;
  void setCourseSearchText(String text) {
    _courseSearchText = text;
  }

  Map<String, FilterGroupInfo> _courseFilter = {
    "departments": FilterGroupInfo(label: "학과", isMultiSelect: true, options: [
      [
        CodeLabelPair(code: "HSS", label: "인문"),
        CodeLabelPair(code: "CE", label: "건환"),
        CodeLabelPair(code: "MSB", label: "기경"),
        CodeLabelPair(code: "ME", label: "기계"),
      ],
      [
        CodeLabelPair(code: "PH", label: "물리"),
        CodeLabelPair(code: "BiS", label: "바공"),
        CodeLabelPair(code: "IE", label: "산공"),
        CodeLabelPair(code: "ID", label: "산디"),
      ],
      [
        CodeLabelPair(code: "BS", label: "생명"),
        CodeLabelPair(code: "CBE", label: "생화공"),
        CodeLabelPair(code: "MAS", label: "수리"),
        CodeLabelPair(code: "MS", label: "신소재"),
      ],
      [
        CodeLabelPair(code: "NQE", label: "원양"),
        CodeLabelPair(code: "TS", label: "융인"),
        CodeLabelPair(code: "CS", label: "전산"),
        CodeLabelPair(code: "EE", label: "전자"),
      ],
      [
        CodeLabelPair(code: "AE", label: "항공"),
        CodeLabelPair(code: "CH", label: "화학"),
        CodeLabelPair(code: "ETC", label: "기타"),
      ]
    ]),
    "types": FilterGroupInfo(label: "구분", isMultiSelect: true, options: [
      [
        CodeLabelPair(code: "BR", label: "기필"),
        CodeLabelPair(code: "BE", label: "기선"),
        CodeLabelPair(code: "MR", label: "전필"),
        CodeLabelPair(code: "ME", label: "전선"),
      ],
      [
        CodeLabelPair(code: "MGC", label: "교필"),
        CodeLabelPair(code: "HSE", label: "인선"),
        CodeLabelPair(code: "GR", label: "공통"),
        CodeLabelPair(code: "EG", label: "석박"),
      ],
      [
        CodeLabelPair(code: "OE", label: "자선"),
        CodeLabelPair(code: "ETC", label: "기타"),
      ]
    ]),
    "levels": FilterGroupInfo(label: "학년", isMultiSelect: true, options: [
      [
        CodeLabelPair(code: "100", label: "100번"),
        CodeLabelPair(code: "200", label: "200번"),
        CodeLabelPair(code: "300", label: "300번")
      ],
      [
        CodeLabelPair(code: "400", label: "400번"),
        CodeLabelPair(code: "ETC", label: "500번 이상")
      ]
    ]),
    // "orders": {
    //   "label": "정렬",
    //   "isMultiSelect": false,
    //   "options": [
    //     [
    //       CodeLabelPair(code: "DEF", label: "기본순", true),
    //       CodeLabelPair(code: "RAT", label: "평점순", false),
    //     ],
    //     [
    //       CodeLabelPair(code: "GRA", label: "성적순", false),
    //       CodeLabelPair(code: "LOA", label: "널널순", false),
    //       CodeLabelPair(code: "SPE", label: "강의순", false),
    //     ]
    //   ]
    // },
    "terms": FilterGroupInfo(
        label: "기간",
        isMultiSelect: false,
        type: "slider",
        options: [
          [CodeLabelPair(code: "ALL", label: "전체", selected: true)],
          [CodeLabelPair(code: "3", label: "3년이내", selected: false)],
          [CodeLabelPair(code: "2", label: "2년이내", selected: false)],
          [CodeLabelPair(code: "1", label: "1년이내", selected: false)],
        ])
  };
  get courseFilter => _courseFilter;

  void resetCourseFilter() {
    _courses = null;
    _courseSearchText = '';
    _courseFilter.values.forEach((e) {
      if (e.isMultiSelect)
        e.options.forEach((b) => b.forEach((c) => c.selected = true));
      else {
        e.options.forEach((b) => b.forEach((c) => c.selected = false));
        e.options.first.first.selected = true;
      }
    });
    updateCourseSearchquery();
    notifyListeners();
  }

  void setCourseFilterSelected(String varient, String code, bool selected) {
    assert(['departments', 'types', 'levels', 'terms'].contains(varient));
    _courseFilter[varient]!
        .options
        .expand((i) => i)
        .firstWhere((i) => i.code == code)
        .selected = selected;
    notifyListeners();
  }

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Text _courseSearchquery = Text("과목명, 교수님 성함 등을 검색해 보세요",
      style: TextStyle(
        color: Color(0xFFAAAAAA),
        fontSize: 16,
        height: 1.2,
      ));
  Text get courseSearchquery => _courseSearchquery;
  void updateCourseSearchquery() {
    List<String> _selectedFilters = (_courseFilter.map((k, v) => MapEntry(
        k,
        (v.isMultiSelect == false && v.options.first.first.selected == true) ||
                v.options.expand((i) => i).every((i) => i.selected == true)
            ? Iterable<String>.empty()
            : v.options
                .expand((i) => i)
                .where((i) => i.selected == true)
                .map((i) => i.label)))).values.expand((i) => i).toList();
    if (_selectedFilters.length == 0 && _courseSearchText.length == 0) {
      _courseSearchquery = Text("과목명, 교수님 성함 등을 검색해 보세요",
          style: TextStyle(
            color: Color(0xFFAAAAAA),
            fontSize: 16,
            height: 1.2,
          ));
    } else {
      _courseSearchquery = Text.rich(
        TextSpan(
          style: TextStyle(fontSize: 14, height: 1.2, letterSpacing: 0.15),
          children: [
            TextSpan(
                text: _courseSearchText,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            TextSpan(style: TextStyle(color: Color(0xFFAAAAAA)), children: [
              if (_selectedFilters.length > 0 && _courseSearchText.length > 0)
                TextSpan(text: ", "),
              TextSpan(text: _selectedFilters.join(", ")),
            ])
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  // Text createQuery(
  //     String? keyword,
  //     List<CodeLabelPair>? department,
  //     List<CodeLabelPair>? type,
  //     List<CodeLabelPair>? level,
  //     CodeLabelPair? term) {
  //   List<String> filterOptions = ;
  //   return Text.rich(
  //     TextSpan(
  //       style: TextStyle(fontSize: 14, height: 1.2, letterSpacing: 0.15),
  //       children: [
  //         TextSpan(
  //             text: keyword,
  //             style:
  //                 TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
  //         if (filterOptions.length > 0)
  //           TextSpan(style: TextStyle(color: Color(0xFFAAAAAA)), children: [
  //             if ((keyword ?? '').length > 0) TextSpan(text: ", "),
  //             TextSpan(text: (filterOptions).join(", ")),
  //           ])
  //       ],
  //     ),
  //     maxLines: 1,
  //     overflow: TextOverflow.ellipsis,
  //   );
  // }

  Future<bool> courseSearch({String order = "DEF", double tune = 3}) async {
    _courseFilter.forEach((k, v) {
      if (v.options.expand((i) => i).every((i) => i.selected == false)) {
        if (v.isMultiSelect == true)
          v.options.expand((i) => i).forEach((j) {
            j.selected = true;
          });
        else
          v.options.first.first.selected = true;
      }
    });
    List<CodeLabelPair> dep = _courseFilter['departments']!
            .options
            .expand((i) => i)
            .every((i) => i.selected == true)
        ? []
        : _courseFilter['departments']!
            .options
            .expand((i) => i)
            .where((i) => i.selected == true)
            .toList();
    List<CodeLabelPair> typ = _courseFilter['types']!
            .options
            .expand((i) => i)
            .every((i) => i.selected == true)
        ? []
        : _courseFilter['types']!
            .options
            .expand((i) => i)
            .where((i) => i.selected == true)
            .toList();
    List<CodeLabelPair> lev = _courseFilter['levels']!
            .options
            .expand((i) => i)
            .every((i) => i.selected == true)
        ? []
        : _courseFilter['levels']!
            .options
            .expand((i) => i)
            .where((i) => i.selected == true)
            .toList();
    CodeLabelPair term = _courseFilter['terms']!
        .options
        .expand((i) => i)
        .firstWhere((i) => i.selected == true);
    if (dep.length == 0 &&
        typ.length == 0 &&
        lev.length == 0 &&
        _courseSearchText.length == 0) return false;
    Future(() async {
      updateCourseSearchquery();
      _isSearching = true;
      notifyListeners();
      try {
        final response = await DioProvider()
            .dio
            .getUri(Uri(path: API_COURSE_URL, queryParameters: {
              "keyword": _courseSearchText,
              "department":
                  dep.length == 0 ? ['ALL'] : dep.map((i) => i.code).toList(),
              "type":
                  typ.length == 0 ? ['ALL'] : typ.map((i) => i.code).toList(),
              "level":
                  lev.length == 0 ? ['ALL'] : lev.map((i) => i.code).toList(),
              "term": term.code,
            }));

        final rawCourses = response.data as List;
        _courses = rawCourses.map((course) => Course.fromJson(course)).toList();

        switch (order) {
          case "RAT":
            final avgRatings = _courses!.fold<double>(
                    0, (acc, val) => acc + val.grade + val.load + val.speech) /
                _courses!.length;
            _courses!.sort((a, b) {
              final aRating =
                  ((a.grade + a.load + a.speech) * a.reviewTotalWeight +
                          avgRatings * tune) /
                      (a.reviewTotalWeight + tune);
              final bRating =
                  ((b.grade + b.load + b.speech) * b.reviewTotalWeight +
                          avgRatings * tune) /
                      (b.reviewTotalWeight + tune);
              return bRating.compareTo(aRating);
            });
            break;
          case "GRA":
            final avgRatings =
                _courses!.fold<double>(0, (acc, val) => acc + val.grade) /
                    _courses!.length;
            _courses!.sort((a, b) {
              final aRating =
                  (a.grade * a.reviewTotalWeight + avgRatings * tune) /
                      (a.reviewTotalWeight + tune);
              final bRating =
                  (b.grade * b.reviewTotalWeight + avgRatings * tune) /
                      (b.reviewTotalWeight + tune);
              return bRating.compareTo(aRating);
            });
            break;
          case "LOA":
            final avgRatings =
                _courses!.fold<double>(0, (acc, val) => acc + val.load) /
                    _courses!.length;
            _courses!.sort((a, b) {
              final aRating =
                  (a.load * a.reviewTotalWeight + avgRatings * tune) /
                      (a.reviewTotalWeight + tune);
              final bRating =
                  (b.load * b.reviewTotalWeight + avgRatings * tune) /
                      (b.reviewTotalWeight + tune);
              return bRating.compareTo(aRating);
            });
            break;
          case "SPE":
            final avgRatings =
                _courses!.fold<double>(0, (acc, val) => acc + val.speech) /
                    _courses!.length;
            _courses!.sort((a, b) {
              final aRating =
                  (a.speech * a.reviewTotalWeight + avgRatings * tune) /
                      (a.reviewTotalWeight + tune);
              final bRating =
                  (b.speech * b.reviewTotalWeight + avgRatings * tune) /
                      (b.reviewTotalWeight + tune);
              return bRating.compareTo(aRating);
            });
            break;
        }
      } catch (exception) {
        print(exception);
      }

      _isSearching = false;
      notifyListeners();
    });
    return true;
  }
}
