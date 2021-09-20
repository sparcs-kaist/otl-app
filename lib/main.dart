import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/home.dart';
import 'package:otlplus/pages/login_page.dart';
import 'package:otlplus/providers/auth_model.dart';
import 'package:otlplus/providers/course_detail_model.dart';
import 'package:otlplus/providers/info_model.dart';
import 'package:otlplus/providers/lecture_detail_model.dart';
import 'package:otlplus/providers/review_model.dart';
import 'package:otlplus/providers/search_model.dart';
import 'package:otlplus/providers/timetable_model.dart';
import 'package:otlplus/utils/create_material_color.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthModel()),
      ChangeNotifierProxyProvider<AuthModel, InfoModel>(
        create: (context) => InfoModel(),
        update: (context, authModel, infoModel) {
          if (authModel.isLogined) infoModel?.getInfo();
          return (infoModel is InfoModel) ? infoModel : InfoModel();
        },
      ),
      ChangeNotifierProxyProvider<InfoModel, TimetableModel>(
        create: (context) => TimetableModel(),
        update: (context, infoModel, timetableModel) {
          if (infoModel.hasData)
            timetableModel?.loadSemesters(
                user: infoModel.user, semesters: infoModel.semesters);
          return (timetableModel is TimetableModel)
              ? timetableModel
              : TimetableModel();
        },
      ),
      ChangeNotifierProvider(create: (context) => SearchModel()),
      ChangeNotifierProvider(create: (context) => ReviewModel()),
      ChangeNotifierProvider(create: (context) => CourseDetailModel()),
      ChangeNotifierProvider(create: (context) => LectureDetailModel()),
    ],
    child: OTLFirebaseApp(),
  ));
}

class OTLFirebaseApp extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _OTLFirebaseAppState createState() => _OTLFirebaseAppState();
}

class _OTLFirebaseAppState extends State<OTLFirebaseApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error during initializing Firebase");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return OTLMaterialApp();
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class OTLMaterialApp extends StatelessWidget {
  final analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "OTL",
      theme: _buildTheme(),
      home: context.select<InfoModel, bool>((model) => model.hasData)
          ? TimeplannerHome()
          : LoginPage(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }

  ThemeData _buildTheme() {
    final base = ThemeData(
      primarySwatch: createMaterialColor(PRIMARY_COLOR),
      canvasColor: Colors.white,
      iconTheme: const IconThemeData(color: CONTENT_COLOR),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(),
        isDense: true,
        hintStyle: TextStyle(
          color: PRIMARY_COLOR,
          fontSize: 14.0,
        ),
      ),
    );

    return base.copyWith(
      cardTheme: base.cardTheme.copyWith(margin: const EdgeInsets.only()),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: BLOCK_COLOR,
        pressElevation: 0.0,
        secondarySelectedColor: SELECTED_COLOR,
        labelStyle: const TextStyle(
          color: CONTENT_COLOR,
          fontSize: 12.0,
        ),
        secondaryLabelStyle: const TextStyle(
          color: CONTENT_COLOR,
          fontSize: 12.0,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: CONTENT_COLOR,
        displayColor: CONTENT_COLOR,
      ),
    );
  }
}
