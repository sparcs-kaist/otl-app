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
    "departments": FilterGroupInfo("학과", true, [
      [
        CodeLabelPair("HSS", "인문"),
        CodeLabelPair("CE", "건환"),
        CodeLabelPair("MSB", "기경"),
        CodeLabelPair("ME", "기계"),
      ],
      [
        CodeLabelPair("PH", "물리"),
        CodeLabelPair("BiS", "바공"),
        CodeLabelPair("IE", "산공"),
        CodeLabelPair("ID", "산디"),
      ],
      [
        CodeLabelPair("BS", "생명"),
        CodeLabelPair("CBE", "생화공"),
        CodeLabelPair("MAS", "수리"),
        CodeLabelPair("MS", "신소재"),
      ],
      [
        CodeLabelPair("NQE", "원양"),
        CodeLabelPair("TS", "융인"),
        CodeLabelPair("CS", "전산"),
        CodeLabelPair("EE", "전자"),
      ],
      [
        CodeLabelPair("AE", "항공"),
        CodeLabelPair("CH", "화학"),
        CodeLabelPair("ETC", "기타"),
      ]
    ]),
    "types": FilterGroupInfo("구분", true, [
      [
        CodeLabelPair("BR", "기필"),
        CodeLabelPair("BE", "기선"),
        CodeLabelPair("MR", "전필"),
        CodeLabelPair("ME", "전선"),
      ],
      [
        CodeLabelPair("MGC", "교필"),
        CodeLabelPair("HSE", "인선"),
        CodeLabelPair("GR", "공통"),
        CodeLabelPair("EG", "석박"),
      ],
      [
        CodeLabelPair("OE", "자선"),
        CodeLabelPair("ETC", "기타"),
      ]
    ]),
    "levels": FilterGroupInfo("학년", true, [
      [
        CodeLabelPair("100", "100번"),
        CodeLabelPair("200", "200번"),
        CodeLabelPair("300", "300번")
      ],
      [CodeLabelPair("400", "400번"), CodeLabelPair("ETC", "500번 이상")]
    ]),
    // "orders": {
    //   "label": "정렬",
    //   "isMultiSelect": false,
    //   "options": [
    //     [
    //       CodeLabelPair("DEF", "기본순", true),
    //       CodeLabelPair("RAT", "평점순", false),
    //     ],
    //     [
    //       CodeLabelPair("GRA", "성적순", false),
    //       CodeLabelPair("LOA", "널널순", false),
    //       CodeLabelPair("SPE", "강의순", false),
    //     ]
    //   ]
    // },
    "terms": FilterGroupInfo("기간", false, [
      [CodeLabelPair("ALL", "전체", true)],
      [CodeLabelPair("3", "3년이내", false)],
      [CodeLabelPair("2", "2년이내", false)],
      [CodeLabelPair("1", "1년이내", false)],
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
        e.options[0][0].selected = true;
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
        (v.isMultiSelect == false && v.options[0][0].selected == true) ||
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
          v.options[0][0].selected = true;
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
