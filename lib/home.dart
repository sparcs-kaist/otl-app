import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/backdrop.dart';
import 'package:timeplanner_mobile/layers/user_layer.dart';
import 'package:timeplanner_mobile/pages/dictionary_page.dart';
import 'package:timeplanner_mobile/pages/main_page.dart';
import 'package:timeplanner_mobile/pages/timetable_page.dart';
import 'package:timeplanner_mobile/providers/auth_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';

class TimeplannerHome extends StatefulWidget {
  @override
  _TimeplannerHomeState createState() => _TimeplannerHomeState();
}

class _TimeplannerHomeState extends State<TimeplannerHome> {
  final _userLayer = UserLayer();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.language),
          onPressed: () {},
        ),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Backdrop.of(context).toggleBackdropLayerVisibility(_userLayer);
            },
          ),
        ),
      ],
      frontLayer: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          MainPage(),
          ChangeNotifierProvider(
            create: (context) => TimetableModel(
              cookies: Provider.of<AuthModel>(context, listen: false).cookies,
            ),
            child: TimetablePage(),
          ),
          DictionaryPage(),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("홈"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_chart),
          title: Text("시간표"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          title: Text("과목사전"),
        ),
      ],
    );
  }
}
