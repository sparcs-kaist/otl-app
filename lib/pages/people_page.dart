import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/utils/build_app_bar.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget sizedBox12 = const SizedBox(height: 12.0);
    Widget sizedBox4 = const SizedBox(height: 4.0);

    return Scaffold(
      appBar: buildAppBar(context, '만든 사람들', false, true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              decoration: BoxDecoration(
                color: pinksLight,
                borderRadius: BorderRadius.circular(16.0),
              ),
              width: double.infinity,
              child: Center(
                child: Text(
                  '2023.03~',
                  style: titleRegular,
                ),
              ),
            ),
            sizedBox12,
            Text(
              'Project Manager',
              style: labelBold,
            ),
            sizedBox4,
            Image.asset(
              "assets/people/yumyum.png",
              height: 22,
            ),
            sizedBox12,
            Text(
              'Tech Lead',
              style: labelBold,
            ),
            sizedBox4,
            Image.asset(
              "assets/people/platypus.png",
              height: 22,
            ),
            sizedBox12,
            Text(
              'Designer',
              style: labelBold,
            ),
            sizedBox4,
            Image.asset(
              "assets/people/zealot.png",
              height: 22,
            ),
            sizedBox4,
            Image.asset(
              "assets/people/yumyum.png",
              height: 22,
            ),
            sizedBox12,
            Text(
              'Developer',
              style: labelBold,
            ),
            sizedBox4,
            Image.asset(
              "assets/people/platypus.png",
              height: 22,
            ),
            sizedBox4,
            Image.asset(
              "assets/people/star.png",
              height: 22,
            ),
            sizedBox4,
            Image.asset(
              "assets/people/lobe.png",
              height: 22,
            ),
            sizedBox4,
            Image.asset(
              "assets/people/seungho.png",
              height: 22,
            ),
            sizedBox4,
            Image.asset(
              "assets/people/soongyu.png",
              height: 22,
            ),
            const SizedBox(height: 32.0),
            Container(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              decoration: BoxDecoration(
                color: pinksLight,
                borderRadius: BorderRadius.circular(16.0),
              ),
              width: double.infinity,
              child: Center(
                child: Text(
                  '2020.02 ~ 2023.02',
                  style: titleRegular,
                ),
              ),
            ),
            sizedBox12,
            Text(
              '준비 중입니다.',
              style: bodyRegular.copyWith(color: grayA),
            ),
          ],
        ),
      ),
    );
  }
}
