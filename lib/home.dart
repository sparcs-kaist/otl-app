import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/pages/dictionary_page.dart';
import 'package:timeplanner_mobile/pages/main_page.dart';
import 'package:timeplanner_mobile/pages/timetable_page.dart';
import 'package:timeplanner_mobile/pages/user_page.dart';
import 'package:timeplanner_mobile/widgets/custom_appbar.dart';

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
            CustomAppBar(
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.language),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserPage()));
                  },
                ),
              ],
            ),
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
