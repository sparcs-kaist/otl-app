import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/utils/responsive_button.dart';

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
            IconTextButton(
              onTap: () => Navigator.pop(context),
              icon: Icons.navigate_before,
              padding: const EdgeInsets.all(16),
            ),
          )
        : null,
    actions: isActions
        ? <Widget>[
            appBarPadding(
              IconTextButton(
                icon: Icons.close,
                onTap: () => Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                ),
                padding: const EdgeInsets.all(16),
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
