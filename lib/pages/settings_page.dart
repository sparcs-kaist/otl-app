import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/providers/settings_model.dart';
import 'package:otlplus/widgets/responsive_button.dart';
import 'package:otlplus/utils/navigator.dart';
import 'package:otlplus/widgets/otl_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:easy_localization/easy_localization.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class SettingsPage extends StatelessWidget {
  final contactEmail = 'otlplus@kaist.ac.kr';

  @override
  Widget build(BuildContext context) {
    final isEn = EasyLocalization.of(context)?.currentLocale == Locale('en');

    return OTLScaffold(
      child: OTLLayout(
        middle: Text('title.settings'.tr(), style: titleBold),
        body: ColoredBox(
          color: OTLColor.grayF,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "settings.language".tr(),
                      style: bodyBold,
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        customButton: Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: OTLColor.pinksLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.language,
                                color: OTLColor.pinksMain,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isEn
                                    ? "settings.english".tr()
                                    : "settings.korean".tr(),
                                style: bodyBold.copyWith(
                                    height: 1.2, color: OTLColor.pinksMain),
                              )
                            ],
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          direction: DropdownDirection.left,
                          width: 200,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: OTLColor.gray6,
                          ),
                          offset: const Offset(0, -6),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          height: 42,
                          padding: EdgeInsets.zero,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: false,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomStart,
                              children: [
                                Container(
                                  height: 42,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 16),
                                      !isEn
                                          ? Icon(
                                              Icons.check,
                                              color: OTLColor.grayF,
                                              size: 16,
                                            )
                                          : const SizedBox(width: 16),
                                      const SizedBox(width: 12),
                                      Text(
                                        "settings.korean".tr(),
                                        style: bodyRegular.copyWith(
                                            color: OTLColor.grayF),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: OTLColor.grayF.withOpacity(0.5),
                                  height: 0.5,
                                ),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: true,
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                isEn
                                    ? Icon(
                                        Icons.check,
                                        color: OTLColor.grayF,
                                        size: 16,
                                      )
                                    : const SizedBox(width: 16),
                                const SizedBox(width: 12),
                                Text(
                                  "settings.english".tr(),
                                  style: bodyRegular.copyWith(
                                      color: OTLColor.grayF),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == false) {
                            EasyLocalization.of(context)
                                ?.setLocale(Locale('ko'));
                          } else {
                            EasyLocalization.of(context)
                                ?.setLocale(Locale('en'));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                _buildListTile(
                  title: "settings.send_error_log".tr(),
                  subtitle: "settings.send_error_log_desc".tr(),
                  trailing: CupertinoSwitch(
                    value: context.watch<SettingsModel>().getSendCrashlytics(),
                    onChanged: (value) =>
                        context.read<SettingsModel>().setSendCrashlytics(value),
                  ),
                ),
                Visibility(
                  visible: context.watch<SettingsModel>().getSendCrashlytics(),
                  child: _buildListTile(
                    title: "settings.send_anonymously".tr(),
                    subtitle: "settings.send_anonymously_desc".tr(),
                    trailing: CupertinoSwitch(
                      value: context
                          .watch<SettingsModel>()
                          .getSendCrashlyticsAnonymously(),
                      onChanged: (value) => context
                          .read<SettingsModel>()
                          .setSendCrashlyticsAnonymously(value),
                    ),
                  ),
                ),
                Visibility(
                  visible: kDebugMode,
                  child: _buildListTile(
                    title: "settings.throw_test".tr(),
                    subtitle: "settings.throw_test_desc".tr(),
                    onTap: () => throw Exception(),
                  ),
                ),
                _buildListTile(
                  title: "settings.reset_all".tr(),
                  onTap: () {
                    OTLNavigator.pushDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          'common.alert'.tr(),
                          style: titleRegular,
                        ),
                        content: Text(
                          'settings.reset_all_desc'.tr(),
                          style: bodyRegular,
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              "common.cancel".tr(),
                              style: bodyRegular,
                            ),
                            onPressed: () {
                              OTLNavigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text(
                              "common.delete".tr(),
                              style: bodyRegular,
                            ),
                            onPressed: () {
                              context
                                  .read<SettingsModel>()
                                  .clearAllValues()
                                  .then((_) => OTLNavigator.pop(context));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                _buildListTile(
                  title: "settings.about".tr(),
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: "",
                    applicationIcon:
                        Image.asset("assets/images/logo.png", height: 48.0),
                    children: [
                      Text(
                        "Online Timeplanner with Lectures Plus @ KAIST",
                        style: bodyRegular,
                      ),
                      IconTextButton(
                        padding: EdgeInsets.fromLTRB(0, 4, 10, 4),
                        onTap: () =>
                            launchUrl(Uri.parse("mailto:$contactEmail")),
                        text: contactEmail,
                        textStyle:
                            bodyRegular.copyWith(color: OTLColor.pinksMain),
                      )
                    ],
                  ),
                  hasTopPadding: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(
      {required String title,
      String subtitle = '',
      Widget? trailing,
      void Function()? onTap,
      bool hasTopPadding = true}) {
    return Padding(
      padding: EdgeInsets.only(top: hasTopPadding ? 16 : 0),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: bodyBold),
                    const SizedBox(height: 4),
                    Text(subtitle, style: bodyRegular),
                  ],
                ),
              ),
              if (trailing != null) trailing
            ],
          ),
        ),
      ),
    );
  }
}
