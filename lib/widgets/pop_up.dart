import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class PopUp extends StatelessWidget {
  const PopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      insetPadding: EdgeInsets.all(16.0),
      backgroundColor: OTLColor.pinksLight,
      title: Text.rich(
        TextSpan(
          style: titleBold,
          children: <TextSpan>[
            TextSpan(text: '졸업플래너'),
            TextSpan(style: labelBold, text: 'BETA'),
            TextSpan(text: ' 서비스 이용 안내'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/graduate-planner.png', height: 128.0),
            Text(
              '웹에서 지금 바로 만나보세요!',
              style: bodyRegular,
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => launchUrl(
            Uri.https("otl.kaist.ac.kr", "planner"),
          ),
          child: Text.rich(
            TextSpan(
              style: titleBold,
              children: <TextSpan>[
                TextSpan(text: '졸업플래너'),
                TextSpan(style: labelBold, text: 'BETA'),
                TextSpan(text: ' 이용하러 가기'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
