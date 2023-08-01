import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/utils/responsive_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class PopUp extends StatefulWidget {
  const PopUp({Key? key}) : super(key: key);

  @override
  State<PopUp> createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.all(0.0),
      actionsPadding: EdgeInsets.only(top: 8.0),
      elevation: 0.0,
      content: _buildAppEvent(context),
      actions: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconTextButton(
                onTap: () {
                  setState(() {
                    _checked = !_checked;
                    SharedPreferences.getInstance().then(
                      (value) => value.setBool('popup', !_checked),
                    );
                  });
                },
                tapEffect: 'none',
                icon: Icons.check_circle_outline,
                color: _checked ? OTLColor.pinksMain : OTLColor.grayA,
                spaceBetween: 8.0,
                text: 'popup.dont_show_again'.tr(),
                textStyle: bodyRegular.copyWith(
                  color: _checked ? OTLColor.grayF : OTLColor.grayA,
                ),
              ),
              IconTextButton(
                onTap: () async {
                  Navigator.pop(context);
                },
                icon: Icons.close,
                color: OTLColor.grayF,
                tapEffect: 'darken',
                tapEffectColorRatio: 0.24,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildAppEvent(BuildContext context) {
  final isEn = EasyLocalization.of(context)?.currentLocale == Locale('en');

  return SingleChildScrollView(
    child: Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset(
            isEn
                ? 'assets/app-event-image-en.png'
                : 'assets/app-event-image.png',
            height: 328.0,
            width: 285.0,
          ),
          Column(
            children: [
              const SizedBox(height: 262.0),
              FilledButton(
                onPressed: () => launchUrl(
                  Uri.parse(
                    'https://docs.google.com/forms/d/e/1FAIpQLSfZbU_TFUPN53De_ihtS4ZK5Tb_nRDazRS7EYQgp3QWAYvyhQ/viewform',
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('popup.join_the_event'.tr(), style: bodyBold),
                    const SizedBox(width: 8.0),
                    Icon(Icons.arrow_forward)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// ignore: unused_element
Widget _buildGraduatePlanner() {
  return SingleChildScrollView(
    child: Column(
      children: [
        Text.rich(
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
        const SizedBox(height: 16.0),
        Image.asset('assets/graduate-planner.png', height: 128.0),
        const SizedBox(height: 8.0),
        Text(
          '웹에서 지금 바로 만나보세요!',
          style: bodyRegular,
        ),
        const SizedBox(height: 8.0),
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
        ),
      ],
    ),
  );
}
