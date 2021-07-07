import 'dart:convert';
import 'package:test/test.dart';
import 'package:timeplanner_mobile/models/classtime.dart';

void main() {
  group('Classtime', () {
    var buildingCode = 'buildingCode';
      var json = """
      {
        "building_code": "$buildingCode",
        "classroom": "",
        "classroom_en": "",
        "classroom_short": "",
        "classroom_short_en": "",
        "room_name": "",
        "day": 1,
        "begin": 1,
        "end": 1
      }
      """;

    test('constructor', () {
      var classtime = Classtime();
      expect(classtime.buildingCode, null);
    });

    test('fromJson', () {
      var classtime = Classtime.fromJson(jsonDecode(json));
      expect(classtime.buildingCode, buildingCode);
    });
  });
}