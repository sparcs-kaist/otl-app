import 'package:flutter/material.dart';
import 'package:otlplus/constants/url.dart';
import 'package:otlplus/dio_provider.dart';
import 'package:otlplus/models/code_label_pair.dart';
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

  Map<String, dynamic> _lectureFilter = {
    "departments": {
      "label": "학과",
      "isMultiSelect": true,
      "options": <List<CodeLabelPair>>[
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
      ]
    },
    "types": {
      "label": '구분',
      "isMultiSelect": true,
      "options": <List<CodeLabelPair>>[
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
      ]
    },
    "levels": {
      "label": "학년",
      "isMultiSelect": true,
      "options": <List<CodeLabelPair>>[
        [
          CodeLabelPair("100", "100번"),
          CodeLabelPair("200", "200번"),
          CodeLabelPair("300", "300번")
        ],
        [CodeLabelPair("400", "400번"), CodeLabelPair("ETC", "500번 이상")]
      ]
    }
  };
  get lectureFilter => _lectureFilter;

  void resetLectureFilter() {
    _lectureSearchText = '';
    _lectureFilter.values.forEach((e) {
      (e['options'] as List<List<CodeLabelPair>>)
          .forEach((b) => b.forEach((c) => c.selected = true));
    });
    notifyListeners();
  }

  void setLectureFilterSelected(String varient, String code, bool selected) {
    assert(['departments', 'types', 'levels'].contains(varient));
    (_lectureFilter[varient]["options"] as List<List<CodeLabelPair>>)
        .expand((i) => i)
        .firstWhere((i) => i.code == code)
        .selected = selected;
    notifyListeners();
  }

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Text _lectureSearchquery = Text.rich(TextSpan());
  Text get lectureSearchquery => _lectureSearchquery;

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
        style: TextStyle(fontSize: 14, height: 1.4, letterSpacing: 0.15),
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

  Future<void> lectureSearch(Semester semester, String? keyword,
      {List<CodeLabelPair>? department,
      List<CodeLabelPair>? type,
      List<CodeLabelPair>? level}) async {
    List<CodeLabelPair> dep =
        (department ?? []).every((i) => i.selected == true)
            ? []
            : (department ?? []).where((i) => i.selected == true).toList();
    List<CodeLabelPair> typ = (type ?? []).every((i) => i.selected == true)
        ? []
        : (type ?? []).where((i) => i.selected == true).toList();
    List<CodeLabelPair> lev = (level ?? []).every((i) => i.selected == true)
        ? []
        : (level ?? []).where((i) => i.selected == true).toList();
    _lectureSearchquery = createQuery(keyword, dep, typ, lev, null);
    _isSearching = true;
    notifyListeners();

    try {
      final response = await DioProvider()
          .dio
          .getUri(Uri(path: API_LECTURE_URL, queryParameters: {
            "year": semester.year.toString(),
            "semester": semester.semester.toString(),
            "keyword": keyword ?? '',
            "department":
                dep.length == 0 ? ['ALL'] : dep.map((i) => i.code).toList(),
            "type": typ.length == 0 ? ['ALL'] : typ.map((i) => i.code).toList(),
            "level":
                lev.length == 0 ? ['ALL'] : lev.map((i) => i.code).toList(),
          }));

      final rawLectures = response.data as List;
      final lectures = rawLectures.map((lecture) => Lecture.fromJson(lecture));
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
  }
}
