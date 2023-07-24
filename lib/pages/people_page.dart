import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/utils/build_app_bar.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, '만든 사람들', false, true),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildContainer('2023.03 ~'),
            ..._get202303(),
            const SizedBox(height: 32.0),
            _buildContainer('2020.03 ~ 2023.02'),
            const SizedBox(height: 12.0),
            Text(
              '준비 중입니다.',
              style: bodyRegular.copyWith(color: grayA),
            ),
          ],
        ),
      ),
    );
  }

  _buildContainer(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: pinksLight,
        borderRadius: BorderRadius.circular(16.0),
      ),
      width: double.infinity,
      child: Center(
        child: Text(title, style: titleRegular),
      ),
    );
  }

  List<Widget> _get202303() {
    const List<String> positions = [
      'Project Manager',
      'Tech Lead',
      'Designer',
      'Developer',
    ];

    const List<List<String>> people = [
      ['yumyum'],
      ['platypus'],
      ['yumyum'],
      ['platypus', 'star', 'lobe', 'seungho', 'soongyu'],
    ];

    return List.generate(
      4,
      (i) => Column(
        children: [
          const SizedBox(height: 12.0),
          Text(
            positions[i],
            style: labelBold,
          ),
          ...List.generate(
            people[i].length,
            (j) => Column(
              children: [
                const SizedBox(height: 4.0),
                SvgPicture.asset(
                  'assets/people/${people[i][j]}.svg',
                  height: 24.0,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
