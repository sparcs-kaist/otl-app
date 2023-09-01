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

class SettingsPage extends StatelessWidget {
  final contactEmail = 'otlplus@kaist.ac.kr';

  @override
  Widget build(BuildContext context) {
    return OTLScaffold(
      child: OTLLayout(
        middle: Text('title.settings'.tr(), style: titleBold),
        body: ColoredBox(
          color: OTLColor.grayF,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildListTile(
                  title: "settings.language".tr(),
                  subtitle: "settings.current_language".tr(),
                  trailing: CupertinoSwitch(
                    value: EasyLocalization.of(context)?.currentLocale ==
                        Locale("en"),
                    onChanged: (value) {
                      if (value) {
                        EasyLocalization.of(context)?.setLocale(Locale('en'));
                      } else {
                        EasyLocalization.of(context)?.setLocale(Locale('ko'));
                      }
                    },
                  ),
                  hasTopPadding: false,
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
