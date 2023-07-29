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
                "settings.send_error_log",
                style: bodyBold,
              ).tr(),
              subtitle: Text(
                "settings.send_error_log_desc",
                style: bodyRegular,
              ).tr(),
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
                  "settings.send_anonymously",
                  style: bodyBold,
                ).tr(),
                subtitle: Text(
                  "settings.send_anonymously_desc",
                  style: bodyRegular,
                ).tr(),
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
                  "settings.throw_test",
                  style: bodyBold,
                ).tr(),
                subtitle: Text(
                  "settings.throw_test_desc",
                  style: bodyRegular,
                ).tr(),
                onTap: () => throw Exception(),
              ),
            ),
            ListTile(
              title: Text("settings.reset_all", style: bodyBold).tr(),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'common.alert',
                      style: titleRegular,
                    ).tr(),
                    content: Text(
                      'settings.reset_all_desc',
                      style: bodyRegular,
                    ).tr(),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          "common.cancel",
                          style: bodyRegular,
                        ).tr(),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text(
                          "common.delete",
                          style: bodyRegular,
                        ).tr(),
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
