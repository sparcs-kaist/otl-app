import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplanner_mobile/constants/color.dart';
import 'package:timeplanner_mobile/pages/course_detail_page.dart';
import 'package:timeplanner_mobile/pages/dictionary_page.dart';
import 'package:timeplanner_mobile/pages/lecture_detail_page.dart';
import 'package:timeplanner_mobile/pages/main_page.dart';
import 'package:timeplanner_mobile/pages/review_page.dart';
import 'package:timeplanner_mobile/pages/timetable_page.dart';
import 'package:timeplanner_mobile/pages/user_page.dart';
import 'package:timeplanner_mobile/providers/search_model.dart';
import 'package:timeplanner_mobile/widgets/backdrop.dart';

class TimeplannerHome extends StatefulWidget {
  @override
  _TimeplannerHomeState createState() => _TimeplannerHomeState();
}

class _TimeplannerHomeState extends State<TimeplannerHome> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      actions: <Widget>[
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Backdrop.of(context).show(0);
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () {
            showAboutDialog(
                context: context,
                applicationName: "",
                applicationIcon: Image.asset("assets/logo.png", height: 48.0),
                children: <Widget>[
                  Text(
                    "Online Timeplanner with Lectures",
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "E. ghwhsbsb@kaist.ac.kr\n(본 모바일 앱이 아닌 OTL 서비스 자체에 대한 문의는 SPARCS로 해주시기 바랍니다.)",
                    style: const TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                ]);
          },
        ),
      ],
      bottomNavigationBar: _buildBottomNavigationBar(),
      isExpanded: _currentIndex == 0,
      expandedWidget: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            "assets/bg.4556cdee.jpg",
            fit: BoxFit.cover,
            color: const Color(0xFF9B4810).withOpacity(0.2),
            colorBlendMode: BlendMode.srcATop,
          ),
          _buildSearch(),
        ],
      ),
      frontLayer: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          MainPage(),
          TimetablePage(),
          DictionaryPage(),
          ReviewPage(),
        ],
      ),
      backLayers: <Widget>[
        UserPage(),
        CourseDetailPage(),
        LectureDetailPage(),
      ],
    );
  }

  Widget _buildSearch() {
    return Card(
      margin: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          onSubmitted: (value) {
            setState(() {
              context.read<SearchModel>().courseSearch(value);
              _currentIndex = 2;
            });
          },
          style: const TextStyle(fontSize: 14.0),
          decoration: const InputDecoration(
            hintText: "검색",
            icon: Icon(
              Icons.search,
              color: PRIMARY_COLOR,
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "홈",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_chart_outlined),
          label: "시간표",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books_outlined),
          label: "과목사전",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rate_review_outlined),
          label: "과목후기",
        ),
      ],
    );
  }
}
