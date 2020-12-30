import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/user.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';

class UserLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select<InfoModel, User>((model) => model.user);
    final editableReviews = user.reviews
        .where((review) => user.reviewWritableLectures
            .any((lecture) => lecture.id == review.lecture.id))
        .toList();

    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTitle("내 정보"),
            _buildContent("이름 ", "${user.firstName} ${user.lastName}"),
            _buildContent("메일 ", user.email),
            const Divider(color: DIVIDER_COLOR),
            const SizedBox(height: 4.0),
            _buildTitle("학사 정보"),
            _buildContent("학번 ", user.studentId),
            _buildContent("전공 ",
                user.majors.map((department) => department.name).join(", ")),
            const Divider(color: DIVIDER_COLOR),
            const SizedBox(height: 4.0),
            _buildTitle("내가 들은 과목"),
            _buildContent("작성 후기 ",
                "${editableReviews.length}/${user.reviewWritableLectures.length}"),
            _buildContent(
                "추천 ",
                editableReviews
                    .fold<int>(0, (acc, val) => acc + val.like)
                    .toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 12.0),
          children: <TextSpan>[
            TextSpan(
              text: name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
