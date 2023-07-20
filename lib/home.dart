import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:otlplus/constants/icon.dart';
import 'package:otlplus/providers/course_search_model.dart';
import 'package:otlplus/pages/course_search_page.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/pages/dictionary_page.dart';
import 'package:otlplus/pages/main_page.dart';
import 'package:otlplus/pages/review_page.dart';
import 'package:otlplus/pages/timetable_page.dart';
import 'package:easy_localization/easy_localization.dart';

class OTLHome extends StatefulWidget {
  static String route = 'home';

  @override
  _OTLHomeState createState() => _OTLHomeState();
}

class _OTLHomeState extends State<OTLHome> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool get frontLayerVisible =>
      _controller.status == AnimationStatus.completed ||
      _controller.status == AnimationStatus.forward;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor:
          _currentIndex == 0 ? const Color(0xFF9B4810) : BACKGROUND_COLOR,
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: LayoutBuilder(builder: _buildStack),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  PreferredSizeWidget _buildHomeAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(
        MediaQuery.of(context).size.width / 1296 * 865 + 5,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          appBarTheme: AppBarTheme(
            color: BACKGROUND_COLOR,
            elevation: 0.0,
            actionsIconTheme: IconThemeData(color: Colors.white70),
          ),
        ),
        child: AppBar(
          title: Image.asset(
            "assets/logo.png",
            height: 27,
          ),
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Container(
                  color: PRIMARY_COLOR,
                  height: 5,
                ),
                _buildExpandedWidget(),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            PlatformIconButton(
              onPressed: () {
                Navigator.push(context, buildUserPageRoute());
              },
              materialIcon: Icon(Icons.person),
              cupertinoIcon: Icon(CupertinoIcons.person),
            ),
            PlatformIconButton(
              onPressed: () =>
                  {Navigator.push(context, buildSettingsPageRoute())},
              materialIcon: Icon(Icons.settings),
              cupertinoIcon: Icon(
                CupertinoIcons.gear,
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTimeTableAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Theme(
        data: Theme.of(context).copyWith(
          appBarTheme: AppBarTheme(
            color: BACKGROUND_COLOR,
            elevation: 0.0,
            actionsIconTheme: IconThemeData(
              color: CONTENT_COLOR,
            ),
          ),
        ),
        child: AppBar(
          title: Image.asset(
            "assets/logo.png",
            height: 27,
          ),
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Container(
                  color: PRIMARY_COLOR,
                  height: 5,
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            PlatformIconButton(
              onPressed: () {
                Navigator.push(context, buildUserPageRoute());
              },
              materialIcon: Icon(Icons.person),
              cupertinoIcon: Icon(CupertinoIcons.person),
            ),
            PlatformIconButton(
              onPressed: () =>
                  {Navigator.push(context, buildSettingsPageRoute())},
              materialIcon: Icon(Icons.settings),
              cupertinoIcon: Icon(
                CupertinoIcons.gear,
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildDictionaryAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Theme(
        data: Theme.of(context).copyWith(
          appBarTheme: AppBarTheme(
            color: BACKGROUND_COLOR,
            elevation: 0.0,
            actionsIconTheme: IconThemeData(
              color: CONTENT_COLOR,
            ),
          ),
        ),
        child: AppBar(
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Container(
                  color: PRIMARY_COLOR,
                  height: 5,
                ),
              ],
            ),
          ),
          leading: Icon(
            CustomIcons.search,
            color: PRIMARY_COLOR,
          ),
          title: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CourseSearchPage(openKeyboard: false),
                ),
              );
            },
            child: context.watch<CourseSearchModel>().courseSearchquery,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildReviewAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Theme(
        data: Theme.of(context).copyWith(
          appBarTheme: AppBarTheme(
            color: BACKGROUND_COLOR,
            elevation: 0.0,
            actionsIconTheme: IconThemeData(
              color: CONTENT_COLOR,
            ),
          ),
        ),
        child: AppBar(
          title: Image.asset(
            "assets/logo.png",
            height: 27,
          ),
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Container(
                  color: PRIMARY_COLOR,
                  height: 5,
                ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            PlatformIconButton(
              onPressed: () {
                Navigator.push(context, buildUserPageRoute());
              },
              materialIcon: Icon(Icons.person),
              cupertinoIcon: Icon(CupertinoIcons.person),
            ),
            PlatformIconButton(
              onPressed: () =>
                  {Navigator.push(context, buildSettingsPageRoute())},
              materialIcon: Icon(Icons.settings),
              cupertinoIcon: Icon(
                CupertinoIcons.gear,
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeAppBar();
      case 1:
        return _buildTimeTableAppBar();
      case 2:
        return _buildDictionaryAppBar();
      case 3:
        return _buildReviewAppBar();
      default:
        return _buildHomeAppBar();
    }
  }

  Widget _buildExpandedWidget() {
    return Stack(
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

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final layerTop = constraints.biggest.height;
    final layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0, layerTop, 0, -layerTop),
      end: RelativeRect.fromLTRB(0, 0, 0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    return Stack(
      children: <Widget>[
        PositionedTransition(
          rect: layerAnimation,
          child: AnimatedOpacity(
            child: IndexedStack(
              index: _currentIndex,
              children: <Widget>[
                MainPage(),
                TimetablePage(),
                DictionaryPage(),
                ReviewPage(),
              ],
            ),
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            opacity: frontLayerVisible ? 1.0 : 0.0,
          ),
        ),
      ],
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
