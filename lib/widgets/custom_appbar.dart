import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({List<Widget> actions})
      : super(
          title: Image.asset(
            "assets/logo.png",
            height: 27,
          ),
          flexibleSpace: SafeArea(
            child: Container(
              color: PRIMARY_COLOR,
              height: 5,
            ),
          ),
          actions: actions,
          automaticallyImplyLeading: false,
        );
}
