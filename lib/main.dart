import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/home.dart';
import 'package:timeplanner_mobile/pages/login_page.dart';
import 'package:timeplanner_mobile/providers/auth_model.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthModel()),
        ChangeNotifierProxyProvider<AuthModel, InfoModel>(
          create: (context) => InfoModel(),
          update: (context, authModel, infoModel) {
            if (authModel.isLogined)
              infoModel.updateInfo(cookies: authModel.cookies);
            return infoModel;
          },
        ),
      ],
      child: TimeplannerApp(),
    ));

class TimeplannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Timeplanner Mobile",
      theme: _buildTheme(),
      home: Consumer<InfoModel>(
        builder: (context, infoModel, _) {
          if (infoModel.state == InfoState.done) return TimeplannerHome();
          return LoginPage();
        },
      ),
    );
  }

  ThemeData _buildTheme() {
    final base = ThemeData.light();

    return base.copyWith(
      accentColor: PRIMARY_COLOR,
      appBarTheme: base.appBarTheme.copyWith(
        color: BACKGROUND_COLOR,
        elevation: 0.0,
      ),
      canvasColor: BACKGROUND_COLOR,
      iconTheme: base.iconTheme.copyWith(color: CONTENT_COLOR),
      primaryColor: PRIMARY_COLOR,
      primaryIconTheme: base.primaryIconTheme.copyWith(color: CONTENT_COLOR),
      scaffoldBackgroundColor: BACKGROUND_COLOR,
      textTheme: base.textTheme.apply(
        bodyColor: CONTENT_COLOR,
        displayColor: CONTENT_COLOR,
      ),
    );
  }
}
