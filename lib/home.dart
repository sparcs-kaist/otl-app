import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:otlplus/pages/settings_page.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/pages/course_detail_page.dart';
import 'package:otlplus/pages/dictionary_page.dart';
import 'package:otlplus/pages/lecture_detail_page.dart';
import 'package:otlplus/pages/main_page.dart';
import 'package:otlplus/pages/review_page.dart';
import 'package:otlplus/pages/timetable_page.dart';
import 'package:otlplus/pages/user_page.dart';
import 'package:otlplus/providers/search_model.dart';
import 'package:otlplus/widgets/backdrop.dart';

class OTLHome extends StatefulWidget {
  @override
  _OTLHomeState createState() => _OTLHomeState();
}

class _OTLHomeState extends State<OTLHome> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      actions: <Widget>[
        Builder(
          builder: (context) => PlatformIconButton(
            onPressed: () {
              Backdrop.of(context).show(0);
            },
            materialIcon: Icon(Icons.person),
            cupertinoIcon: Icon(CupertinoIcons.person),
          ),
        ),
        PlatformIconButton(
          onPressed: () => {
            Navigator.push(
                context,
                platformPageRoute(
                    context: context, builder: (_) => SettingsPage()))
          },
          materialIcon: Icon(Icons.settings),
          cupertinoIcon: Icon(
            CupertinoIcons.gear,
          ),
        )
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
      showSelectedLabels: true,
      showUnselectedLabels: true,
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
