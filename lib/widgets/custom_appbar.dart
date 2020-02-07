import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';

class CustomAppBar extends StatelessWidget {
  final Widget leading;
  final List<Widget> actions;

  CustomAppBar({this.leading, this.actions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: PRIMARY_COLOR,
          height: 5,
        ),
        Container(
          padding: leading != null ? null : const EdgeInsets.only(left: 16.0),
          height: 50,
          child: Row(
            children: <Widget>[
                  leading ?? const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 11, 0, 12),
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
