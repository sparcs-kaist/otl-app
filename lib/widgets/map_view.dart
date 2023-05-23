import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/classtime.dart';
import 'package:otlplus/models/lecture.dart';
import 'package:otlplus/widgets/timetable.dart';

const POSITION_OF_LOCATIONS = {
  'E2': {'left': 0.60, 'top': 0.81},
  'E3': {'left': 0.67, 'top': 0.75},
  'E6': {'left': 0.68, 'top': 0.63},
  'E6-5': {'left': 0.63, 'top': 0.58},
  'E7': {'left': 0.77, 'top': 0.61},
  'E11': {'left': 0.53, 'top': 0.58},
  'E16': {'left': 0.53, 'top': 0.49},
  'N1': {'left': 0.88, 'top': 0.39},
  'N2': {'left': 0.71, 'top': 0.45},
  'N3': {'left': 0.53, 'top': 0.45},
  'N4': {'left': 0.62, 'top': 0.41},
  'N5': {'left': 0.74, 'top': 0.39},
  'N7': {'left': 0.33, 'top': 0.41},
  'N7-2': {'left': 0.29, 'top': 0.42},
  'N22': {'left': 0.79, 'top': 0.35},
  'N24': {'left': 0.76, 'top': 0.31},
  'N25': {'left': 0.59, 'top': 0.36},
  'N27': {'left': 0.57, 'top': 0.24},
  'W1': {'left': 0.31, 'top': 0.84},
  'W1-1': {'left': 0.28, 'top': 0.88},
  'W1-2': {'left': 0.34, 'top': 0.85},
  'W1-3': {'left': 0.35, 'top': 0.81},
  'W8': {'left': 0.35, 'top': 0.55},
  'W16': {'left': 0.40, 'top': 0.87},
};

class MapView extends StatefulWidget {

  final Map<String, List<Map<Lecture, Classtime>>> _lectures = {};

  Map<String, List<Map<Lecture, Classtime>>> get lectures => _lectures;

  MapView({required List<Lecture> lectures}) {
    for(Lecture lecture in lectures) {
      for(Classtime classtime in lecture.classtimes) {
        String buildingCode = classtime.buildingCode;
        if (buildingCode == '') buildingCode = '기타';
        if ((_lectures[buildingCode]?.indexWhere((element) => element.values.first.classroom == classtime.classroom) ?? -1) == -1)
          _lectures[buildingCode] = _lectures[buildingCode]?.followedBy([{lecture: classtime}]).toList() ?? [{lecture: classtime}];
      }
    }
  }

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late double _width, _height;
  late List<String> _pinOrder, _blockOrder;

  @override
  void initState() {
    super.initState();
    _blockOrder = POSITION_OF_LOCATIONS.keys.toList();
    _blockOrder.add('기타');
    _pinOrder = [..._blockOrder];
  }

  @override
  Widget build(BuildContext context) {
    final List<String> pinKeys, blockKeys;
    pinKeys = widget.lectures.keys.toList()..sort((a, b) {
      return _pinOrder.indexOf(a).compareTo(_pinOrder.indexOf(b));
    });
    blockKeys = widget.lectures.keys.toList()..sort((a, b) {
      return _blockOrder.indexOf(a).compareTo(_blockOrder.indexOf(b));
    });
    _width = MediaQuery.of(context).size.width - 64;
    _height = _width * 131 / 146;
    return Column(
      children: [
        Container(
          height: _height + 36,
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
                pinKeys.length, (i) => _buildMapPin(context, pinKeys[i]),
              )
            ).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: blockKeys.length,
            itemBuilder: (_, i) => _buildBuildingBlock(blockKeys[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildMapPin(BuildContext context, String buildingCode) {
    return Positioned(
      left: _width * (POSITION_OF_LOCATIONS[buildingCode]?['left'] ?? 0.0) - 5,
      top: _height * (POSITION_OF_LOCATIONS[buildingCode]?['top'] ?? 1.0) - 16,
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
                if (buildingCode != '기타')
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
                  widget.lectures[buildingCode]!.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: _darken(TIMETABLE_BLOCK_COLORS[widget.lectures[buildingCode]![i].keys.first.course % 16]),
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
    if (buildingCode == '기타') return buildingCode;
    Classtime first = widget.lectures[buildingCode]![0].values.first;
    String buildingName = first.classroom;
    buildingName = buildingName.replaceAll('($buildingCode)', '');
    buildingName = buildingName.replaceAll(first.roomName, ''); 
    return buildingCode + ' ' + buildingName.trim();
  }

  Widget _buildBuildingBlock(String buildingCode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: BLOCK_COLOR,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _pinOrder.remove(buildingCode);
                _pinOrder.add(buildingCode);
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                    widget.lectures[buildingCode]!.length,
                    (i) => _buildLectureBlock(i, buildingCode),
                  ),
                ).toList(),
              )
            ),
          ),
        ),
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
    Lecture lecture = widget.lectures[buildingCode]![i].keys.first;
    Classtime classtime = widget.lectures[buildingCode]![i].values.first;
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
          if (classtime.roomName.isNotEmpty)
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
                  (buildingCode == '기타') ? classtime.classroom : classtime.roomName,
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