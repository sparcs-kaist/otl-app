import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/providers/settings_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  final contactEmail = 'otlplus@kaist.ac.kr';

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text("설정"),
        ),
        body: Material(
            child: ListView(children: [
          ListTile(
            title: Text("오류 로그 전송"),
            subtitle: Text("사용자의 제보 없이 자동으로 오류를 수집합니다."),
            trailing: PlatformSwitch(
              value: context.watch<SettingsModel>().getSendCrashlytics(),
              onChanged: (value) =>
                  {context.read<SettingsModel>().setSendCrashlytics(value)},
            ),
          ),
          Visibility(
            visible: context.watch<SettingsModel>().getSendCrashlytics(),
            child: ListTile(
              title: Text("익명으로 전송"),
              subtitle: Text("오류 로그에 사용자 ID를 포함하지 않고 익명으로 전송합니다."),
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
            title: Text("모든 설정 데이터 초기화"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('경고'),
                  content: Text('정말 모든 설정 데이터를 초기화하시겠습니까? 로그인 정보는 초기화되지 않습니다.'),
                  actions: <Widget>[
                    TextButton(
                        child: new Text("취소"),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    TextButton(
                        child: new Text("삭제"),
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
