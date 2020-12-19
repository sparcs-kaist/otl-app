import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/home.dart';
import 'package:timeplanner_mobile/pages/login_page.dart';
import 'package:timeplanner_mobile/providers/auth_model.dart';
import 'package:timeplanner_mobile/providers/info_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthModel()),
      ChangeNotifierProxyProvider<AuthModel, InfoModel>(
        create: (context) => InfoModel(),
        update: (context, authModel, infoModel) {
          if (authModel.state == AuthState.done) infoModel.getInfo();
          return infoModel;
        },
      ),
      ChangeNotifierProxyProvider<InfoModel, TimetableModel>(
        create: (context) => TimetableModel(),
        update: (context, infoModel, timetableModel) {
          if (infoModel.state == InfoState.done &&
              timetableModel.selectedSemester == null)
            timetableModel.loadTimetable(semester: infoModel.semesters.last);
          return timetableModel;
        },
      )
    ],
    child: TimeplannerApp(),
  ));
}

class TimeplannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Timeplanner Mobile",
      theme: _buildTheme(),
      home: (context.watch<InfoModel>().state == InfoState.done)
          ? TimeplannerHome()
          : LoginPage(),
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  ThemeData _buildTheme() {
    final base = ThemeData(
      primarySwatch: createMaterialColor(PRIMARY_COLOR),
      canvasColor: BACKGROUND_COLOR,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        color: BACKGROUND_COLOR,
        elevation: 0.0,
      ),
      iconTheme: const IconThemeData(color: CONTENT_COLOR),
      primaryIconTheme: const IconThemeData(color: CONTENT_COLOR),
      textTheme: base.textTheme.apply(
        bodyColor: CONTENT_COLOR,
        displayColor: CONTENT_COLOR,
      ),
    );
  }
}
