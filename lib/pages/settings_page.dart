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
    return Scaffold(
        appBar: _buildAppBar(context),
        body: Material(
            child: ListView(children: [
          ListTile(
            title: Text(
              "settings.send_error_log",
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            subtitle: Text(
              "settings.send_error_log_desc",
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ).tr(),
            trailing: PlatformSwitch(
              value: context.watch<SettingsModel>().getSendCrashlytics(),
              onChanged: (value) =>
                  {context.read<SettingsModel>().setSendCrashlytics(value)},
            ),
          ),
          Visibility(
            visible: context.watch<SettingsModel>().getSendCrashlytics(),
            child: ListTile(
              title: Text("settings.send_anonymously",
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  )).tr(),
              subtitle: Text("settings.send_anonymously_desc",
                  style: const TextStyle(
                    fontSize: 12.0,
                  )).tr(),
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
            title: Text("settings.reset_all",
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                )).tr(),
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
              title: Text("settings.throw_test",
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  )).tr(),
              subtitle: Text("settings.throw_test_desc",
                  style: const TextStyle(
                    fontSize: 12.0,
                  )).tr(),
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Theme(
        data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme(
          color: BACKGROUND_COLOR,
          elevation: 0.0,
          actionsIconTheme: IconThemeData(
            color: CONTENT_COLOR,
          ),
        )),
        child: AppBar(
          title: Image.asset(
            "assets/logo.png",
            height: 27,
          ),
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Container(
                  color: PRIMARY_COLOR,
                  height: 5,
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
