import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/home.dart';
import 'package:timeplanner_mobile/pages/login_page.dart';
import 'package:timeplanner_mobile/providers/auth_model.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: TimeplannerApp(),
    ));

class TimeplannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Timeplanner Mobile",
      theme: _buildTheme(),
      home: Consumer<AuthModel>(
        builder: (context, authModel, _) {
          if (!authModel.isLogined) return LoginPage();
          return TimeplannerHome();
        },
      ),
    );
  }

  ThemeData _buildTheme() {
    final base = ThemeData.light();

    return base.copyWith(
      accentColor: PRIMARY_COLOR,
      canvasColor: BACKGROUND_COLOR,
      iconTheme: base.iconTheme.copyWith(color: CONTENT_COLOR),
      primaryColor: PRIMARY_COLOR,
      scaffoldBackgroundColor: BACKGROUND_COLOR,
      textTheme: base.textTheme.apply(
        bodyColor: CONTENT_COLOR,
        displayColor: CONTENT_COLOR,
      ),
    );
  }
}
