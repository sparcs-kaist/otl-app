import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/pages/dictionary_page.dart';
import 'package:timeplanner_mobile/pages/main_page.dart';
import 'package:timeplanner_mobile/pages/timetable_page.dart';

class TimeplannerHome extends StatefulWidget {
  @override
  _TimeplannerHomeState createState() => _TimeplannerHomeState();
}

class _TimeplannerHomeState extends State<TimeplannerHome> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildAppBar(),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: <Widget>[
                  MainPage(),
                  DictionaryPage(),
                  TimetablePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Column(
      children: <Widget>[
        Container(
          color: PRIMARY_COLOR,
          height: 5,
        ),
        SizedBox(
          height: 50,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 11, 0, 12),
                child: Image.asset("assets/logo.png"),
              ),
              const Spacer(),
              IconButton(
                color: CONTENT_COLOR,
                icon: const Icon(Icons.menu),
                padding: const EdgeInsets.symmetric(vertical: 13),
                onPressed: () {},
              ),
            ],
          ),
        )
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: BACKGROUND_COLOR,
      currentIndex: _currentIndex,
      unselectedItemColor: CONTENT_COLOR,
      selectedItemColor: PRIMARY_COLOR,
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
          icon: Icon(Icons.library_books),
          title: Text("과목사전"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_chart),
          title: Text("모의시간표"),
        ),
      ],
    );
  }
}
