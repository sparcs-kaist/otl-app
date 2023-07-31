import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlplus/providers/lecture_search_model.dart';
import 'package:otlplus/providers/timetable_model.dart';
import 'package:otlplus/utils/build_app_bar.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:otlplus/providers/course_search_model.dart';
import 'package:otlplus/widgets/mode_control.dart';
import 'package:otlplus/widgets/pop_up.dart';
import 'package:otlplus/widgets/semester_picker.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/pages/dictionary_page.dart';
import 'package:otlplus/pages/main_page.dart';
import 'package:otlplus/pages/review_page.dart';
import 'package:otlplus/pages/timetable_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if ((await SharedPreferences.getInstance()).getBool('popup') ?? true) {
          await showDialog(
            context: context,
            builder: (context) => PopUp(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor:
          _currentIndex == 0 ? const Color(0xFF9B4810) : OTLColor.pinksLight,
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
      preferredSize: Size.fromHeight(5),
      child: AppBar(
        flexibleSpace:
            SafeArea(child: Container(color: OTLColor.pinksMain, height: 5.0)),
        backgroundColor: OTLColor.pinksLight,
        foregroundColor: OTLColor.pinksMain,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
    );
  }

  PreferredSizeWidget _buildTimeTableAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight + 5),
      child: SafeArea(
        child: Container(
          color: OTLColor.pinksLight,
          child: Column(
            children: [
              Container(
                color: OTLColor.pinksMain,
                height: 5,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: SemesterPicker(
                        onSemesterChanged: () {
                          context
                              .read<LectureSearchModel>()
                              .setSelectedLecture(null);
                          context.read<LectureSearchModel>().lectureClear();
                        },
                      ),
                    ),
                    ModeControl(
                      dropdownIndex:
                          context.watch<TimetableModel>().selectedMode,
                      onTap: (mode) =>
                          context.read<TimetableModel>().setMode(mode),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildDictionaryAppBar() {
    return AppBar(
      title: appBarPadding(
        GestureDetector(
          onTap: () => Navigator.push(context, buildCourseSearchPageRoute()),
          child: Container(
            decoration: BoxDecoration(
              color: OTLColor.grayF,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/search.svg',
                    height: 24.0,
                    width: 24.0,
                    colorFilter:
                        ColorFilter.mode(OTLColor.pinksMain, BlendMode.srcIn)),
                const SizedBox(width: 12.0),
                Expanded(
                  child: context.watch<CourseSearchModel>().courseSearchquery,
                ),
              ],
            ),
          ),
        ),
      ),
      flexibleSpace:
          SafeArea(child: Container(color: OTLColor.pinksMain, height: 5.0)),
      toolbarHeight: kToolbarHeight + 5.0,
      backgroundColor: OTLColor.pinksLight,
      foregroundColor: OTLColor.gray0,
      elevation: 0.0,
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }

  PreferredSizeWidget _buildReviewAppBar() {
    return AppBar(
      title: appBarPadding(
        Image.asset(
          "assets/images/logo.png",
          height: 27,
        ),
      ),
      actions: <Widget>[
        appBarPadding(
          PlatformIconButton(
            onPressed: () {
              Navigator.push(context, buildUserPageRoute());
            },
            materialIcon: Icon(Icons.person),
            cupertinoIcon: Icon(CupertinoIcons.person),
          ),
        ),
        appBarPadding(
          PlatformIconButton(
            onPressed: () =>
                {Navigator.push(context, buildSettingsPageRoute())},
            materialIcon: Icon(Icons.settings),
            cupertinoIcon: Icon(
              CupertinoIcons.gear,
            ),
          ),
        )
      ],
      flexibleSpace:
          SafeArea(child: Container(color: OTLColor.pinksMain, height: 5.0)),
      toolbarHeight: kToolbarHeight + 5.0,
      backgroundColor: OTLColor.pinksLight,
      foregroundColor: OTLColor.gray0,
      elevation: 0.0,
      automaticallyImplyLeading: false,
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
                MainPage(changeIndex: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                }),
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
          label: tr("title.home"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_chart_outlined),
          label: tr("title.timetable"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books_outlined),
          label: tr("title.dictionary"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rate_review_outlined),
          label: tr("title.review"),
        ),
      ],
    );
  }
}
