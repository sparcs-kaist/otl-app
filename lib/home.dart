import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/pages/dictionary_page.dart';
import 'package:timeplanner_mobile/pages/main_page.dart';
import 'package:timeplanner_mobile/pages/timetable_page.dart';
import 'package:timeplanner_mobile/pages/user_page.dart';
import 'package:timeplanner_mobile/providers/auth_model.dart';
import 'package:timeplanner_mobile/providers/timetable_model.dart';
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
            _buildAppBar(context),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: <Widget>[
                  MainPage(),
                  DictionaryPage(),
                  ChangeNotifierProvider(
                    create: (context) => TimetableModel(
                      cookies: Provider.of<AuthModel>(context, listen: false)
                          .cookies,
                    ),
                    child: TimetablePage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.language),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => UserPage()));
          },
        ),
      ],
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
