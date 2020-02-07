import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<AuthModel>(
        builder: (context, authModel, _) {
          if (!authModel.isLogined) return LoginPage();
          return TimeplannerHome();
        },
      ),
    );
  }
}
