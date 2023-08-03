import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlplus/providers/hall_of_fame_model.dart';
import 'package:otlplus/providers/course_search_model.dart';
import 'package:otlplus/providers/lecture_search_model.dart';
import 'package:otlplus/providers/timetable_model.dart';
import 'package:otlplus/utils/build_app_bar.dart';
import 'package:otlplus/utils/build_page_route.dart';
import 'package:otlplus/widgets/hall_of_fame_control.dart';
import 'package:otlplus/widgets/review_mode_control.dart';
import 'package:otlplus/widgets/timetable_mode_control.dart';
import 'package:otlplus/utils/responsive_button.dart';
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
            builder: (context) => const PopUp(),
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
      preferredSize: const Size.fromHeight(5),
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
      preferredSize: const Size.fromHeight(kToolbarHeight + 5),
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
                    TimetableModeControl(
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
      title: appBarPadding(ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: BackgroundButton(
          tapEffectColorRatio: 0.04,
          onTap: () => Navigator.push(context, buildCourseSearchPageRoute()),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/search.svg',
                    height: 24.0,
                    width: 24.0,
                    colorFilter: const ColorFilter.mode(
                        OTLColor.pinksMain, BlendMode.srcIn)),
                const SizedBox(width: 12.0),
                Expanded(
                  child: context.watch<CourseSearchModel>().courseSearchquery,
                ),
              ],
            ),
          ),
          color: OTLColor.grayF,
        ),
      )),
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
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 5),
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
                    ReviewModeControl(
                      selectedMode:
                          context.watch<HallOfFameModel>().selectedMode,
                    ),
                    Visibility(
                      visible:
                          context.watch<HallOfFameModel>().selectedMode == 0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: HallOfFameControl(),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
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

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final layerTop = constraints.biggest.height;
    final layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(0, layerTop, 0, -layerTop),
      end: const RelativeRect.fromLTRB(0, 0, 0, 0),
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
                const DictionaryPage(),
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
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,
      enableFeedback: false,
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
          icon: const Icon(Icons.home_outlined),
          label: tr("title.home"),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.table_chart_outlined),
          label: tr("title.timetable"),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.library_books_outlined),
          label: tr("title.dictionary"),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.rate_review_outlined),
          label: tr("title.review"),
        ),
      ],
    );
  }
}
