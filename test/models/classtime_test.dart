import 'dart:convert';
import 'package:test/test.dart';
import 'package:otlplus/models/classtime.dart';

void main() {
  group('Classtime', () {
    String buildingCode = 'building_code';
    String classroom = 'classroom';
    String classroomEn = 'classroom_en';
    String classroomShort = 'classroom_short';
    String classroomShortEn = 'classroom_short_en';
    String roomName = 'room_name';
    int day = 1;
    int begin = 2;
    int end = 3;
    String json = """
      {
        "building_code": "$buildingCode",
        "classroom": "$classroom",
        "classroom_en": "$classroomEn",
        "classroom_short": "$classroomShort",
        "classroom_short_en": "$classroomShortEn",
        "room_name": "$roomName",
        "day": $day,
        "begin": $begin,
        "end": $end
      }
      """;
    Classtime classtime = Classtime(
        buildingCode: buildingCode,
        classroom: classroom,
        classroomEn: classroomEn,
        classroomShort: classroomShort,
        classroomShortEn: classroomShortEn,
        roomName: roomName,
        day: day,
        begin: begin,
        end: end);

    test('constructor', () {
      expect(classtime.buildingCode, buildingCode);
      expect(classtime.classroom, classroom);
      expect(classtime.classroomEn, classroomEn);
      expect(classtime.classroomShort, classroomShort);
      expect(classtime.classroomShortEn, classroomShortEn);
      expect(classtime.roomName, roomName);
      expect(classtime.day, day);
      expect(classtime.begin, begin);
      expect(classtime.end, end);
    });

    test('fromJson', () {
      var classtimeFromJson = Classtime.fromJson(jsonDecode(json));
      expect(classtimeFromJson == classtime, true);
    });

    test('toJson', () {
      expect(classtime.toJson(), jsonDecode(json));
    });
  });
}
