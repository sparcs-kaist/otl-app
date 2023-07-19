import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/pages/dictionary_page.dart';
import 'package:otlplus/pages/main_page.dart';
import 'package:otlplus/pages/review_page.dart';
import 'package:otlplus/pages/timetable_page.dart';
import 'package:otlplus/providers/search_model.dart';
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

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(_currentIndex == 0
          ? MediaQuery.of(context).size.width / 1296 * 865 + 5
          : kToolbarHeight),
      child: Theme(
        data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme(
          color: BACKGROUND_COLOR,
          elevation: 0.0,
          actionsIconTheme: IconThemeData(
            color: _currentIndex == 0 ? Colors.white70 : CONTENT_COLOR,
          ),
        )),
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
                  if (_currentIndex == 0) _buildExpandedWidget(),
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
            ]),
      ),
    );
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
          decoration: InputDecoration(
            hintText: tr("main.search"),
            icon: Icon(
              Icons.search,
              color: PRIMARY_COLOR,
            ),
          ),
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
