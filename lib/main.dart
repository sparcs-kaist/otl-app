import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:otlplus/providers/settings_model.dart';
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

import 'firebase_options.dart';

void main() {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    runApp(
      EasyLocalization(
          supportedLocales: [Locale('en'), Locale('ko')],
          path: 'assets/translations',
          fallbackLocale: Locale('en'),
          child: MultiProvider(
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
                  if (infoModel.hasData) {
                    timetableModel?.loadSemesters(
                        user: infoModel.user, semesters: infoModel.semesters);
                  }
                  return (timetableModel is TimetableModel)
                      ? timetableModel
                      : TimetableModel();
                },
              ),
              ChangeNotifierProvider(create: (_) => SearchModel()),
              ChangeNotifierProvider(create: (_) => ReviewModel()),
              ChangeNotifierProvider(create: (_) => CourseDetailModel()),
              ChangeNotifierProvider(create: (_) => LectureDetailModel()),
              ChangeNotifierProvider(create: (_) => SettingsModel())
            ],
            child: OTLFirebaseApp(),
          )),
    );
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class OTLFirebaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    try {
      final sendCrashlytics =
          context.watch<SettingsModel>().getSendCrashlytics();
      final sendCrashlyticsAnonymously =
          context.watch<SettingsModel>().getSendCrashlyticsAnonymously();
      final hasData = context.watch<InfoModel>().hasData;

      FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(sendCrashlytics);
      if (!sendCrashlyticsAnonymously && hasData) {
        FirebaseCrashlytics.instance
            .setUserIdentifier(context.watch<InfoModel>().user.id.toString());
      }
    } on Error {}

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: "OTL",
      home: context.select<InfoModel, bool>((model) => model.hasData)
          ? OTLHome()
          : LoginPage(),
      theme: _buildTheme(),
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
