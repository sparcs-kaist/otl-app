import 'package:flutter/material.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/models/filter.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/models/semester.dart';

class LectureSearchModel extends ChangeNotifier {
  Lecture? _selectedLecture;
  Lecture? get selectedLecture => _selectedLecture;

  void setSelectedLecture(Lecture? lecture) {
    _selectedLecture = lecture;
    notifyListeners();
  }

  bool get resultOpened => _lectures != null || _isSearching;

  List<List<Lecture>>? _lectures;
  List<List<Lecture>>? get lectures => _lectures ?? [];

  String _lectureSearchText = '';
  String get lectureSearchText => _lectureSearchText;
  void setLectureSearchText(String text) {
    _lectureSearchText = text;
  }

  Map<String, FilterGroupInfo> _lectureFilter = {
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
    ])
  };
  get lectureFilter => _lectureFilter;

  void resetLectureFilter() {
    _lectures = null;
    _lectureSearchText = '';
    _lectureFilter.values.forEach((e) {
      if (e.isMultiSelect)
        e.options.forEach((b) => b.forEach((c) => c.selected = true));
      else {
        e.options.forEach((b) => b.forEach((c) => c.selected = false));
        e.options[0][0].selected = true;
      }
    });
    updateLectureSearchqeury();
    notifyListeners();
  }

  void setLectureFilterSelected(String varient, String code, bool selected) {
    assert(['departments', 'types', 'levels'].contains(varient));
    _lectureFilter[varient]!
        .options
        .expand((i) => i)
        .firstWhere((i) => i.code == code)
        .selected = selected;
    notifyListeners();
  }

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Text _lectureSearchquery = Text.rich(TextSpan());
  Text get lectureSearchquery => _lectureSearchquery;
  void updateLectureSearchqeury() {
    List<String> _selectedFilters = (_lectureFilter.map((k, v) => MapEntry(
        k,
        (v.isMultiSelect == false && v.options[0][0].selected == true) ||
                v.options.expand((i) => i).every((i) => i.selected == true)
            ? Iterable<String>.empty()
            : v.options
                .expand((i) => i)
                .where((i) => i.selected == true)
                .map((i) => i.label)))).values.expand((i) => i).toList();
    _lectureSearchquery = Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 14, height: 1.2, letterSpacing: 0.15),
        children: [
          TextSpan(
              text: _lectureSearchText,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          TextSpan(style: TextStyle(color: Color(0xFFAAAAAA)), children: [
            if (_selectedFilters.length > 0 && _lectureSearchText.length > 0)
              TextSpan(text: ", "),
            TextSpan(text: _selectedFilters.join(", ")),
          ])
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  void lectureClear() {
    _lectures = null;
    notifyListeners();
  }

  Text createQuery(
      String? keyword,
      List<CodeLabelPair>? department,
      List<CodeLabelPair>? type,
      List<CodeLabelPair>? level,
      CodeLabelPair? term) {
    List<String> filterOptions = [
      ...(department ?? [])
          .where((i) => i.selected == true)
          .map((i) => i.label)
          .toList(),
      ...(type ?? [])
          .where((i) => i.selected == true)
          .map((i) => i.label)
          .toList(),
      ...(level ?? [])
          .where((i) => i.selected == true)
          .map((i) => i.label)
          .toList(),
      if (term != null && term.code != 'ALL') term.label,
    ];
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 14, height: 1.2, letterSpacing: 0.15),
        children: [
          TextSpan(
              text: keyword,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          if (filterOptions.length > 0)
            TextSpan(style: TextStyle(color: Color(0xFFAAAAAA)), children: [
              if ((keyword ?? '').length > 0) TextSpan(text: ", "),
              TextSpan(text: (filterOptions).join(", ")),
            ])
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Future<bool> lectureSearch(Semester semester) async {
    _lectureFilter.forEach((k, v) {
      if (v.options.expand((i) => i).every((i) => i.selected == false)) {
        if (v.isMultiSelect == true)
          v.options.expand((i) => i).forEach((j) {
            j.selected = true;
          });
        else
          v.options[0][0].selected = true;
      }
    });
    List<CodeLabelPair> dep = _lectureFilter['departments']!
            .options
            .expand((i) => i)
            .every((i) => i.selected == true)
        ? []
        : _lectureFilter['departments']!
            .options
            .expand((i) => i)
            .where((i) => i.selected == true)
            .toList();
    List<CodeLabelPair> typ = _lectureFilter['types']!
            .options
            .expand((i) => i)
            .every((i) => i.selected == true)
        ? []
        : _lectureFilter['types']!
            .options
            .expand((i) => i)
            .where((i) => i.selected == true)
            .toList();
    List<CodeLabelPair> lev = _lectureFilter['levels']!
            .options
            .expand((i) => i)
            .every((i) => i.selected == true)
        ? []
        : _lectureFilter['levels']!
            .options
            .expand((i) => i)
            .where((i) => i.selected == true)
            .toList();
    if (dep.length == 0 &&
        typ.length == 0 &&
        lev.length == 0 &&
        _lectureSearchText.length == 0) return false;
    Future(() async {
      updateLectureSearchqeury();
      _isSearching = true;
      notifyListeners();
      try {
        final response = await DioProvider()
            .dio
            .getUri(Uri(path: API_LECTURE_URL, queryParameters: {
              "year": semester.year.toString(),
              "semester": semester.semester.toString(),
              "keyword": _lectureSearchText,
              "department":
                  dep.length == 0 ? ['ALL'] : dep.map((i) => i.code).toList(),
              "type":
                  typ.length == 0 ? ['ALL'] : typ.map((i) => i.code).toList(),
              "level":
                  lev.length == 0 ? ['ALL'] : lev.map((i) => i.code).toList(),
            }));

        final rawLectures = response.data as List;
        final lectures =
            rawLectures.map((lecture) => Lecture.fromJson(lecture));
        final courseIds = lectures.map((lecture) => lecture.course).toSet();

        _lectures = courseIds
            .map((course) =>
                lectures.where((lecture) => lecture.course == course).toList())
            .where((course) => course.length > 0)
            .toList();
      } catch (exception) {
        print(exception);
      }

      _isSearching = false;
      notifyListeners();
    });
    return true;
  }
}
