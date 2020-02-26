import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({List<Widget> actions})
      : super(
          title: SizedBox(
            height: 27,
            child: Image.asset("assets/logo.png"),
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
