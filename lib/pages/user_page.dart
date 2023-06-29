import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/providers/info_model.dart';
import 'package:otlplus/widgets/backdrop.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<InfoModel>().user;

    return Container(
      constraints: const BoxConstraints.expand(),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
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
                _buildContent(
                    "전공 ",
                    user.majors
                        .map((department) => department.name)
                        .join(", ")),
                const Divider(color: DIVIDER_COLOR),
                const SizedBox(height: 4.0),
                _buildTextButton(context, '내가 들은 과목', 3),
                _buildTextButton(context, '좋아요한 후기', 4),
              ],
            ),
          ),
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

  Widget _buildTextButton(BuildContext context, String name, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () => Backdrop.of(context).show(index),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: PRIMARY_COLOR,
            ),
          ),
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(StadiumBorder()),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
