import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

extension WidgetForTest on Widget {
  Widget get material => MaterialApp(home: this);

  Widget get scaffold => MaterialApp(
        home: Scaffold(
          body: this,
        ),
      );

  Widget scaffoldAndNotifier<T extends ChangeNotifier>(T model) {
    return ChangeNotifierProvider<T>(
        create: (_) => model,
        child: MaterialApp(
          home: Scaffold(
            body: this,
          ),
        ));
  }
}
