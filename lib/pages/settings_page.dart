import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/providers/settings_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatelessWidget {
  final contactEmail = 'otlplus@kaist.ac.kr';

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text("main.settings").tr(),
        ),
        body: Material(
            child: ListView(children: [
          ListTile(
            title: Text("settings.send_error_log").tr(),
            subtitle: Text("settings.send_error_log_desc").tr(),
            trailing: PlatformSwitch(
              value: context.watch<SettingsModel>().getSendCrashlytics(),
              onChanged: (value) =>
                  {context.read<SettingsModel>().setSendCrashlytics(value)},
            ),
          ),
          Visibility(
            visible: context.watch<SettingsModel>().getSendCrashlytics(),
            child: ListTile(
              title: Text("settings.send_anonymously").tr(),
              subtitle: Text("settings.send_anonymously_desc").tr(),
              trailing: PlatformSwitch(
                  value: context
                      .watch<SettingsModel>()
                      .getSendCrashlyticsAnonymously(),
                  onChanged: (value) => {
                        context
                            .read<SettingsModel>()
                            .setSendCrashlyticsAnonymously(value)
                      }),
            ),
          ),
          ListTile(
            title: Text("settings.reset_all").tr(),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('common.alert').tr(),
                  content: Text('settings.reset_all_desc').tr(),
                  actions: <Widget>[
                    TextButton(
                        child: new Text("common.cancel").tr(),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    TextButton(
                        child: new Text("common.delete").tr(),
                        onPressed: () {
                          context
                              .read<SettingsModel>()
                              .clearAllValues()
                              .then((_) => Navigator.pop(context));
                        }),
                  ],
                ),
              );
            },
          ),
          Visibility(
            visible: kDebugMode,
            child: ListTile(
              title: Text("settings.throw_test").tr(),
              subtitle: Text("settings.throw_test_desc").tr(),
              onTap: () => throw Exception(),
            ),
          ),
          AboutListTile(
            applicationName: "",
            applicationIcon: Image.asset("assets/logo.png", height: 48.0),
            aboutBoxChildren: <Widget>[
              Text(
                "Online Timeplanner with Lectures Plus @ KAIST",
                style: const TextStyle(fontSize: 14.0),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  InkWell(
                    onTap: () => launchUrl(Uri.parse("mailto:$contactEmail")),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          contactEmail,
                          style: const TextStyle(
                            color: PRIMARY_COLOR,
                            fontSize: 14.0,
                            height: 1.3,
                          ),
                        )),
                  )
                ],
              )
            ],
          ),
        ])));
  }
}
