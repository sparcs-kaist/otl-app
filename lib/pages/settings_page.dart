import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/providers/settings_model.dart';
import 'package:otlplus/utils/build_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatelessWidget {
  final contactEmail = 'otlplus@kaist.ac.kr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, '설정', false, true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "settings.send_error_log".tr(),
                style: bodyBold,
              ),
              subtitle: Text(
                "settings.send_error_log_desc".tr(),
                style: bodyRegular,
              ),
              trailing: PlatformSwitch(
                value: context.watch<SettingsModel>().getSendCrashlytics(),
                onChanged: (value) =>
                    context.read<SettingsModel>().setSendCrashlytics(value),
              ),
            ),
            Visibility(
              visible: context.watch<SettingsModel>().getSendCrashlytics(),
              child: ListTile(
                title: Text(
                  "settings.send_anonymously".tr(),
                  style: bodyBold,
                ),
                subtitle: Text(
                  "settings.send_anonymously_desc".tr(),
                  style: bodyRegular,
                ),
                trailing: PlatformSwitch(
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
              child: ListTile(
                title: Text(
                  "settings.throw_test".tr(),
                  style: bodyBold,
                ),
                subtitle: Text(
                  "settings.throw_test_desc".tr(),
                  style: bodyRegular,
                ),
                onTap: () => throw Exception(),
              ),
            ),
            ListTile(
              title: Text("settings.reset_all".tr(), style: bodyBold),
              onTap: () {
                showDialog(
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
                          Navigator.pop(context);
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
                              .then((_) => Navigator.pop(context));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            AboutListTile(
              applicationName: "",
              applicationIcon:
                  Image.asset("assets/images/logo.png", height: 48.0),
              aboutBoxChildren: <Widget>[
                Text(
                  "Online Timeplanner with Lectures Plus @ KAIST",
                  style: bodyRegular,
                ),
                InkWell(
                  onTap: () => launchUrl(Uri.parse("mailto:$contactEmail")),
                  child: Text(
                    contactEmail,
                    style: bodyRegular.copyWith(color: OTLColor.pinksMain),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
