import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/utils/navigator.dart';
import 'package:otlplus/widgets/responsive_button.dart';

enum OTLDialogType { addLecture, addLectureWithTab }

enum BtnStyle { one, even, uneven }

class _OTLDialogData {
  /// Without tr()
  ///
  /// Example: 'timetable.dialog.add_lecture', 'timetable.dialog.ask_add_lecture'
  final String title, content;

  /// Without 'assets/icons/'
  ///
  /// Example: 'addLecture'
  final String icon;
  final String negText, posText;
  final BtnStyle btnStyle;

  _OTLDialogData({
    required this.title,
    required this.content,
    required this.icon,
    this.negText = '취소',
    required this.posText,
    this.btnStyle = BtnStyle.even,
  });
}

extension OTLDialogTypeExt on OTLDialogType {
  static final _data = {
    OTLDialogType.addLecture: _OTLDialogData(
      title: 'timetable.dialog.add_lecture',
      content: 'timetable.dialog.ask_add_lecture',
      icon: 'addLecture',
      posText: '추가',
    ),
    OTLDialogType.addLectureWithTab: _OTLDialogData(
      title: 'timetable.dialog.add_lecture',
      content: 'timetable.dialog.ask_add_lecture_with_tab',
      icon: 'addLecture',
      posText: '추가',
    )
  };

  String get title => _data[this]!.title;
  String get content => _data[this]!.content;
  String get icon => _data[this]!.icon;
  String get negText => _data[this]!.negText;
  String get posText => _data[this]!.posText;
  BtnStyle get btnStyle => _data[this]!.btnStyle;
}

class OTLDialog extends StatelessWidget {
  const OTLDialog({
    Key? key,
    required this.type,
    this.args,
    this.onTapContent,
    this.onTapNeg,
    this.onTapPos,
  }) : super(key: key);

  final OTLDialogType type;
  final List<String>? args;
  final void Function()? onTapContent, onTapNeg, onTapPos;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 256,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: OTLColor.grayF,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: OTLColor.gray0.withOpacity(0.15),
              offset: const Offset(2, 2),
              blurRadius: 16,
            ),
          ],
        ),
        child: Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/${type.icon}.svg',
                height: 80,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type.title.tr(), style: titleBold),
                    const SizedBox(height: 8),
                    _buildContent(),
                  ],
                ),
              ),
              () {
                // Map<isPos, data>
                final btnData = {
                  true: {
                    'btnColor': OTLColor.pinksMain,
                    'onTap': () {
                      if (onTapPos != null) onTapPos!();
                      OTLNavigator.pop(context);
                    },
                    'btnText': type.posText,
                    'textColor': OTLColor.grayF,
                  },
                  false: {
                    'btnColor': OTLColor.grayE,
                    'onTap': () {
                      if (onTapNeg != null) onTapNeg!();
                      OTLNavigator.pop(context);
                    },
                    'btnText': type.negText,
                    'textColor': OTLColor.gray0,
                  }
                };

                switch (type.btnStyle) {
                  case BtnStyle.one:
                    return _buildButton(btnData[false]!);
                  case BtnStyle.even:
                    return Row(
                      children: [
                        Expanded(child: _buildButton(btnData[false]!)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildButton(btnData[true]!)),
                      ],
                    );
                  case BtnStyle.uneven:
                    return Row(
                      children: [
                        Expanded(child: _buildButton(btnData[true]!)),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 64,
                          child: _buildButton(btnData[false]!),
                        ),
                      ],
                    );
                }
              }(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (type) {
      case OTLDialogType.addLecture:
      case OTLDialogType.addLectureWithTab:
        return Text(
          type.content.tr(args: args),
          style: bodyRegular,
        );
      default:
        return SizedBox();
    }
  }

  Widget _buildButton(Map<String, dynamic> data) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackgroundButton(
        color: data['btnColor'],
        onTap: data['onTap'],
        child: Container(
          height: 30,
          alignment: Alignment.center,
          child: Text(
            data['btnText'],
            style: bodyBold.copyWith(color: data['textColor']),
          ),
        ),
      ),
    );
  }
}
