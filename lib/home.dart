import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:otlplus/pages/settings_page.dart';
import 'package:otlplus/providers/bottom_sheet_model.dart';
import 'package:otlplus/widgets/bottom_search_sheet/bottom_search_sheet.dart';
import 'package:otlplus/widgets/bottom_search_sheet/search_sheet_body.dart';
import 'package:otlplus/widgets/bottom_search_sheet/search_sheet_header.dart';
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
import 'package:easy_localization/easy_localization.dart';
import 'package:sheet/sheet.dart';

class OTLHome extends StatefulWidget {
  @override
  _OTLHomeState createState() => _OTLHomeState();
}

class _OTLHomeState extends State<OTLHome> {
  int _currentIndex = 0;
  late SheetController sheetScrollController;

  @override
  void initState() {
    sheetScrollController = context.read<BottomSheetModel>().scrollController;
    super.initState();
  }
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
      frontLayer: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
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
                height: 68,
                color: Colors.white,
              ),
              Container(
                height: kBottomNavigationBarHeight + MediaQuery.of(context).viewPadding.bottom,
                color: Colors.white,
              )
            ],
          ),
          BottomSearchSheet(),
          AnimatedBuilder(
            animation: sheetScrollController,
            builder: (_, child) { 
              return Transform.translate(
                offset: Offset(0, max(0, min(sheetScrollController.animation.value * 5 - 2, 1)) * (kBottomNavigationBarHeight + MediaQuery.of(context).viewPadding.bottom)),
                child: child,
              );
            },
            child: Wrap(
              children: <Widget>[
                _buildBottomNavigationBar(),
              ],
            ),
          ),
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
