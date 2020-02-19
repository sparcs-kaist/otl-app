import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/lecture.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailDialog extends StatelessWidget {
  final Lecture lecture;

  CourseDetailDialog(this.lecture);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              lecture.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              lecture.oldCode,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.0),
            ),
            Row(
              children: <Widget>[
                const Spacer(),
                InkWell(
                  onTap: () => launch(
                      "https://cais.kaist.ac.kr/syllabusInfo?year=${lecture.year}&term=${lecture.semester}&subject_no=${lecture.code}&lecture_class=${lecture.classNo}&dept_id=${lecture.department}"),
                  child: const Text(
                    "실라버스",
                    style: const TextStyle(
                      color: PRIMARY_COLOR,
                      fontSize: 11.0,
                    ),
                  ),
                ),
              ],
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black87,
                  height: 1.5,
                  fontSize: 13.0,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "구분 ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: lecture.type),
                  TextSpan(
                    text: "\n학과 ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: lecture.departmentName),
                  TextSpan(
                    text: "\n교수 ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: lecture.professorsStrShort),
                  TextSpan(
                    text: "\n장소 ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: lecture.classroom),
                  TextSpan(
                    text: "\n정원 ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: lecture.limit.toString()),
                  TextSpan(
                    text: "\n시험 ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: lecture.exam),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        _buildStatus("언어", lecture.isEnglish ? "Eng" : "한"),
                        _buildStatus(
                            lecture.credit > 0 ? "학점" : "AU",
                            lecture.credit > 0
                                ? lecture.credit.toString()
                                : lecture.creditAu.toString()),
                        _buildStatus(
                            "경쟁률",
                            lecture.limit == 0
                                ? "0.0:1"
                                : "${(lecture.numPeople / lecture.limit).toStringAsFixed(1)}:1"),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        _buildStatus("성적", lecture.gradeLetter),
                        _buildStatus("널널", lecture.loadLetter),
                        _buildStatus("강의", lecture.speechLetter),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: <Widget>[
          Text(
            content,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
