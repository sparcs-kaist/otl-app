import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';

PreferredSizeWidget buildAppBar(
  BuildContext context,
  String title,
  bool isLeading,
  bool isActions,
) {
  return AppBar(
    title: Text(title, style: bodyBold),
    leading: isLeading
        ? IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.navigate_before),
          )
        : null,
    actions: isActions
        ? <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.popUntil(
                context,
                (route) => route.isFirst,
              ),
            ),
          ]
        : null,
    flexibleSpace: SafeArea(
      child: Container(color: pinksMain, height: 5),
    ),
    backgroundColor: pinksLight,
    foregroundColor: gray0,
    elevation: 0.0,
    centerTitle: true,
    automaticallyImplyLeading: false,
  );
}
