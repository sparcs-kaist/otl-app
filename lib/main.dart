import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/home.dart';

void main() => runApp(TimeplannerApp());

class TimeplannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Timeplanner Mobile",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TimeplannerHome(),
    );
  }
}
