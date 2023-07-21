import 'package:flutter/material.dart';
import 'package:otlplus/constants/privacy.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/utils/build_app_bar.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, '개인정보취급방침', false, true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                          TextSpan(text: '\n'),
                          TextSpan(text: privacyTitles[index], style: bodyBold),
                          TextSpan(text: '\n'),
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
