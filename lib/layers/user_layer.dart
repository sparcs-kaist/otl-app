import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/models/user.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';

class UserLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select<InfoModel, User>((model) => model.user);

    return Card(
      margin: const EdgeInsets.only(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTitle("내 정보"),
            _buildContent(context, "이름", "${user.firstName} ${user.lastName}"),
            _buildContent(context, "메일", user.email),
            const Divider(color: DIVIDER_COLOR),
            _buildTitle("학사 정보"),
            _buildContent(context, "학번", user.studentId),
            _buildContent(context, "전공",
                user.majors.map((department) => department.name).join(", ")),
            const Divider(color: DIVIDER_COLOR),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyText2,
          children: <TextSpan>[
            TextSpan(
              text: "$name ",
              style: TextStyle(fontWeight: FontWeight.bold),
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
