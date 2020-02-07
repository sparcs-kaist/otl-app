import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';

class TimeplannerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: BACKGROUND_COLOR,
        child: Column(
          children: <Widget>[
            _buildAppBar(),
            Expanded(
              child: IndexedStack(
                children: <Widget>[],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Column(
      children: <Widget>[
        Container(
          color: IDENTITY_BAR_COLOR,
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
              IconButton(
                color: MENU_COLOR,
                icon: const Icon(Icons.menu),
                padding: const EdgeInsets.symmetric(vertical: 13),
                onPressed: () {},
              ),
            ],
          ),
        )
      ],
    );
  }
}
