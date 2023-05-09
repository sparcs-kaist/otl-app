import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/classtime.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/widgets/timetable.dart';

const POSITION_OF_LOCATIONS = {
  'E2': {'left': 0.60, 'top': 0.81},
  'E3': {'left': 0.67, 'top': 0.75},
  'E6': {'left': 0.68, 'top': 0.63},
  'E7': {'left': 0.77, 'top': 0.61},
  'E11': {'left': 0.53, 'top': 0.58},
  'E16': {'left': 0.53, 'top': 0.49},
  'N1': {'left': 0.88, 'top': 0.39},
  'N3': {'left': 0.53, 'top': 0.45},
  'N4': {'left': 0.62, 'top': 0.41},
  'N5': {'left': 0.74, 'top': 0.39},
  'N7': {'left': 0.33, 'top': 0.41},
  'N22': {'left': 0.79, 'top': 0.35},
  'N24': {'left': 0.76, 'top': 0.31},
  'N25': {'left': 0.59, 'top': 0.36},
  'N27': {'left': 0.57, 'top': 0.24},
  'W1': {'left': 0.31, 'top': 0.84},
  'W8': {'left': 0.35, 'top': 0.55},
  'W16': {'left': 0.40, 'top': 0.87},
};

class MapView extends StatelessWidget {

  final Map<String, List<Lecture>> _lectures = {};

  MapView({required List<Lecture> lectures}) {
    for(Lecture lecture in lectures) {
      String buildingCode = lecture.classtimes[0].buildingCode;
      if (buildingCode == '') buildingCode = '정보 없음';
      _lectures[buildingCode] = _lectures[buildingCode]?.followedBy([lecture]).toList() ?? [lecture];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> keys = _lectures.keys.toList()..sort();
    double width = MediaQuery.of(context).size.width - 64;
    double height = width * 131 / 146;
    return Column(
      children: [
        Container(
          height: height + 36,
          padding: const EdgeInsets.fromLTRB(32, 12, 32, 24),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              Image.asset(
                'assets/images/kaist_map.png',
              ),
            ].followedBy(
              List.generate(
                keys.length, (i) => _buildMapPin(context, keys[i]),
              )
            ).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: keys.length,
            itemBuilder: (_, i) => _buildBuildingBlock(keys[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildMapPin(BuildContext context, String buildingCode) {
    double width = MediaQuery.of(context).size.width - 64;
    double height = width * 131 / 146;
    return Positioned(
      left: width * (POSITION_OF_LOCATIONS[buildingCode]?['left'] ?? 0.0) - 5,
      top: height * (POSITION_OF_LOCATIONS[buildingCode]?['top'] ?? 1.0) - 16,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 3.5,
            bottom: -3,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: CONTENT_COLOR.withOpacity(0.8),
                    spreadRadius: 3,
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 3,
            bottom: -3,
            child: ClipPath(
              clipper: CustomTriangleClipper(),
              child: Container(
                width: 4,
                height: 3,
                color: BLOCK_COLOR,
              ),
            ),
          ),
          Container(
            height: 13,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
            decoration: BoxDecoration(
              color: BLOCK_COLOR,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (buildingCode != '정보 없음')
                  Padding(
                    padding: const EdgeInsets.only(right: 1),
                    child: Text(
                      buildingCode,
                      style: TextStyle(
                        fontSize: 10,
                        height: 9 / 10,
                      ),
                    ),
                  ),
              ].followedBy(
                List.generate(
                  _lectures[buildingCode]!.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: _darken(TIMETABLE_BLOCK_COLORS[_lectures[buildingCode]![i].course % 16]),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _codeToName(String buildingCode) {
    if (buildingCode == '정보 없음') return buildingCode;
    Classtime first = _lectures[buildingCode]![0].classtimes[0];
    String buildingName = first.classroom;
    buildingName = buildingName.replaceAll('($buildingCode)', '');
    buildingName = buildingName.replaceAll(first.roomName, ''); 
    return buildingCode + ' ' + buildingName.trim();
  }

  Widget _buildBuildingBlock(String buildingCode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: BLOCK_COLOR,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _codeToName(buildingCode),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                height: 17 / 12,
              ),
            ),
            const SizedBox(height: 4),
          ].followedBy(
            List.generate(
              _lectures[buildingCode]!.length,
              (i) => _buildLectureBlock(i, buildingCode),
            ),
          ).toList(),
        )
      ),
    );
  }

  Color _darken(Color originalColor) {
    HSLColor color = HSLColor.fromColor(originalColor);
    double saturation = color.saturation + 0.1;
    double lightness = color.lightness - 0.1;
    return color.withSaturation(saturation).withLightness(lightness).toColor();
  }

  Widget _buildLectureBlock(int i, String buildingCode) {
    Lecture lecture = _lectures[buildingCode]![i];
    String roomName = lecture.classtimes[0].roomName;
    return Padding(
      padding: EdgeInsets.only(top: i == 0 ? 0 : 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: _darken(TIMETABLE_BLOCK_COLORS[lecture.course % 16]),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              lecture.title,
              style: TextStyle(
                fontSize: 12,
                height: 17 / 12,
              ),
              maxLines: 5,
            ),
          ),
          if (roomName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 0, 0),
              child: Container(
                height: 16,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: TIMETABLE_BLOCK_COLORS[lecture.course % 16],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  (buildingCode == '정보 없음') ? lecture.classtimes[0].classroom : roomName,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}