import 'package:easy_localization/easy_localization.dart';
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
    title: appBarPadding(Text(title.tr(), style: titleBold)),
    leading: isLeading
        ? appBarPadding(
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.navigate_before),
            ),
          )
        : null,
    actions: isActions
        ? <Widget>[
            appBarPadding(
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                ),
              ),
            ),
          ]
        : null,
    flexibleSpace:
        SafeArea(child: Container(color: OTLColor.pinksMain, height: 5.0)),
    toolbarHeight: kToolbarHeight + 5.0,
    backgroundColor: OTLColor.pinksLight,
    foregroundColor: OTLColor.gray0,
    elevation: 0.0,
    centerTitle: true,
    automaticallyImplyLeading: false,
  );
}

Widget appBarPadding(Widget widget) {
  return Padding(padding: const EdgeInsets.only(top: 5.0), child: widget);
}
