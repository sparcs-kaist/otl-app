import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:otlplus/constants/icon.dart';
import 'package:otlplus/pages/settings_page.dart';
import 'package:otlplus/providers/course_search_model.dart';
import 'package:otlplus/pages/course_search_page.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/pages/course_detail_page.dart';
import 'package:otlplus/pages/dictionary_page.dart';
import 'package:otlplus/pages/lecture_detail_page.dart';
import 'package:otlplus/pages/main_page.dart';
import 'package:otlplus/pages/review_page.dart';
import 'package:otlplus/pages/timetable_page.dart';
import 'package:otlplus/pages/user_page.dart';
import 'package:otlplus/widgets/backdrop.dart';
import 'package:easy_localization/easy_localization.dart';

class OTLHome extends StatefulWidget {
  @override
  _OTLHomeState createState() => _OTLHomeState();
}

class _OTLHomeState extends State<OTLHome> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        BackdropScaffold(
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
          frontLayer: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _currentIndex,
                  children: <Widget>[
                    MainPage(),
                    TimetablePage(),
                    DictionaryPage(),
                    ReviewPage(),
                  ],
                ),
              ),
              Container(
                height: kBottomNavigationBarHeight +
                    MediaQuery.of(context).viewPadding.bottom,
                color: Colors.white,
              )
            ],
          ),
          backLayers: <Widget>[
            UserPage(),
            CourseDetailPage(),
            LectureDetailPage(),
          ],
        ),
        _buildBottomNavigationBar(),
      ],
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(48)),
        child: ColoredBox(
          color: Colors.white,
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  context.read<CourseSearchModel>().resetCourseFilter();
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) =>
                              CourseSearchPage(openKeyboard: true)))
                      .then((e) {
                    setState(() {
                      _currentIndex = 2;
                    });
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 1),
                            child: Icon(
                              CustomIcons.search,
                              color: PRIMARY_COLOR,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        flex: 1,
                        child: Text("과목명, 교수님 성함 등을 검색해 보세요",
                            style: TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 14,
                              height: 1.2,
                            )),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
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
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: tr("main.home"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_chart_outlined),
          label: tr("main.timetable"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books_outlined),
          label: tr("main.dictionary"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rate_review_outlined),
          label: tr("main.review"),
        ),
      ],
    );
  }
}
