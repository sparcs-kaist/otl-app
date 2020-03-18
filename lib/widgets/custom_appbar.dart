import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({Widget leading, List<Widget> actions})
      : super(
          title: leading == null
              ? Image.asset(
                  "assets/logo.png",
                  height: 27,
                )
              : null,
          flexibleSpace: SafeArea(
            child: Container(
              color: PRIMARY_COLOR,
              height: 5,
            ),
          ),
          leading: leading,
          actions: actions,
        );
}
