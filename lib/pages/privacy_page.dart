import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/privacy.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/utils/build_app_bar.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'title.privacy'.tr(), false, true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text.rich(
              TextSpan(
                style: bodyRegular,
                children: <TextSpan>[
                  TextSpan(
                    text: privacyText0,
                    children: List.generate(
                      12,
                      (index) => TextSpan(
                        children: [
                          const TextSpan(text: '\n'),
                          TextSpan(text: privacyTitles[index], style: bodyBold),
                          const TextSpan(text: '\n'),
                          TextSpan(text: privacyTexts[index]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
