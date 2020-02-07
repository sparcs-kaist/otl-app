import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';

class CustomAppBar extends StatelessWidget {
  final List<Widget> actions;

  CustomAppBar({this.actions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: PRIMARY_COLOR,
          height: 5,
        ),
        SizedBox(
          height: 50,
          child: Row(
            children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 11, 0, 12),
                    child: Image.asset("assets/logo.png"),
                  ),
                  const Spacer(),
                ] +
                actions,
          ),
        )
      ],
    );
  }
}
