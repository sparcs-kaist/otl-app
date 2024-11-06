import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/extensions/semester.dart';
import 'package:otlplus/pages/course_search_page.dart';
import 'package:otlplus/pages/lecture_detail_page.dart';
import 'package:otlplus/pages/people_page.dart';
import 'package:otlplus/pages/privacy_page.dart';
import 'package:otlplus/pages/settings_page.dart';
import 'package:otlplus/pages/user_page.dart';
import 'package:otlplus/providers/course_search_model.dart';
import 'package:otlplus/providers/lecture_detail_model.dart';
import 'package:otlplus/widgets/responsive_button.dart';
import 'package:otlplus/utils/navigator.dart';
import 'package:otlplus/widgets/otl_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/models/semester.dart';
import 'package:otlplus/models/timetable.dart';
import 'package:otlplus/models/user.dart';
import 'package:otlplus/providers/info_model.dart';
import 'package:otlplus/widgets/timetable_block.dart';
import 'package:otlplus/widgets/today_timetable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import '../models/lecture.dart';

class MainPage extends StatefulWidget {
  static String route = 'main_page';
  final Function(int index) changeIndex;
  const MainPage({required this.changeIndex, Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final channel = MethodChannel('org.sparcs.otlplus.watchkitapp');

  @override
  void initState() {
    super.initState();
    initWidgetKitData();
    initWatchOSData();
  }

  Future<void> initWidgetKitData() async {
    try {
      final cookieManager = WebviewCookieManager();
      final cookies = await cookieManager.getCookies('https://otl.sparcs.org');
      for (var cookie in cookies) {
        if (cookie.name == 'refreshToken') {
          WidgetKit.setItem(
              'refreshToken', cookie.value, 'group.org.sparcs.otl');
          WidgetKit.reloadAllTimelines();
        }

        if (cookie.name == 'csrftoken') {
          WidgetKit.setItem('csrftoken', cookie.value, 'group.org.sparcs.otl');
          WidgetKit.reloadAllTimelines();
        }

        if (cookie.name == 'accessToken') {
          WidgetKit.setItem(
              'accessToken', cookie.value, 'group.org.sparcs.otl');
          WidgetKit.reloadAllTimelines();
        }
      }
      final infoModel = InfoModel();
      await infoModel.getInfo();
      if (infoModel.hasData) {
        WidgetKit.setItem(
            'uid', infoModel.user.id.toString(), 'group.org.sparcs.otl');
        WidgetKit.reloadAllTimelines();
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future<void> initWatchOSData() async {
    try {
      final cookieManager = WebviewCookieManager();
      final cookies = await cookieManager.getCookies('https://otl.sparcs.org');
      for (var cookie in cookies) {
        if (cookie.name == 'sessionid') {
          await channel.invokeMethod("flutterToWatch", {"method": "sendSessionID", "data": cookie.value});
        }
      }
      final infoModel = InfoModel();
      await infoModel.getInfo();
      if (infoModel.hasData) {
        await channel.invokeMethod("flutterToWatch", {"method": "sendUserID", "data": infoModel.user.id.toString()});
      }
    } catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final infoModel = context.watch<InfoModel>();
    final semester = infoModel.semesters.firstWhere(
      (semester) =>
          semester.beginning.isBefore(now) && semester.end.isAfter(now),
      orElse: () => infoModel.semesters.last,
    );
    return OTLLayout(
      extendBodyBehindAppBar: true,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Image.asset(
          "assets/images/logo.png",
          height: 27.0,
        ),
      ),
      trailing: Row(
        children: [
          IconTextButton(
            onTap: () => OTLNavigator.push(context, UserPage(),
                transition: OTLNavigatorTransition.downUp),
            icon: 'assets/icons/person.svg',
            iconSize: 24,
            color: OTLColor.pinksMain,
            tapEffect: ButtonTapEffect.darken,
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
          ),
          IconTextButton(
            onTap: () => OTLNavigator.push(context, SettingsPage(),
                transition: OTLNavigatorTransition.downUp),
            icon: 'assets/icons/gear.svg',
            iconSize: 24,
            color: OTLColor.pinksMain,
            tapEffect: ButtonTapEffect.darken,
            padding: EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 16.0),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            "assets/images/bg.4556cdee.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            constraints: const BoxConstraints.expand(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width / 1296 * 865 - 16,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: BackgroundButton(
                            tapEffectColorRatio: 0.04,
                            onTap: () {
                              context
                                  .read<CourseSearchModel>()
                                  .resetCourseFilter();
                              OTLNavigator.push(context, CourseSearchPage())
                                  .then((e) {
                                if (e == true) {
                                  widget.changeIndex(2);
                                }
                              });
                            },
                            tapEffect: ButtonTapEffect.darken,
                            color: OTLColor.grayF,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/icons/search.svg',
                                      height: 24.0,
                                      width: 24.0,
                                      colorFilter: ColorFilter.mode(
                                          OTLColor.pinksMain, BlendMode.srcIn)),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: Text(
                                      "common.search_hint".tr(),
                                      style: bodyRegular.copyWith(
                                          color: OTLColor.grayA, height: 1.24),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
                Flexible(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                    child: Container(
                        color: OTLColor.grayF,
                        constraints: const BoxConstraints.expand(),
                        child: CustomScrollView(
                          reverse: true,
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: ColoredBox(
                                color: OTLColor.grayF,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 16.0,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          _buildTimetable(
                                              infoModel.user, semester, now),
                                          const SizedBox(height: 24.0),
                                          _buildDivider(),
                                          const SizedBox(height: 24.0),
                                          _buildSchedule(
                                              now, infoModel.currentSchedule),
                                          const SizedBox(height: 24.0),
                                          _buildDivider(),
                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        children: <Widget>[
                                          _buildLogo(),
                                          const SizedBox(height: 4.0),
                                          _buildCopyRight(),
                                          _buildTextButtons(context),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )

                        // SingleChildScrollView(
                        //   child: ColoredBox(
                        //     color: Colors.white,
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //         horizontal: 16.0,
                        //         vertical: 16.0,
                        //       ),
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Column(
                        //             children: <Widget>[
                        //               _buildTimetable(infoModel.user, semester, now),
                        //               const SizedBox(height: 24.0),
                        //               _buildDivider(),
                        //               const SizedBox(height: 24.0),
                        //               _buildSchedule(now, infoModel.currentSchedule),
                        //               const SizedBox(height: 24.0),
                        //               _buildDivider(),
                        //             ],
                        //           ),
                        //           Column(
                        //             children: <Widget>[
                        //               _buildLogo(),
                        //               const SizedBox(height: 4.0),
                        //               _buildCopyRight(),
                        //               _buildTextButtons(context),
                        //             ],
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: OTLColor.gray0.withOpacity(0.25));
  }

  Widget _buildTextButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconTextButton(
          onTap: () {
            OTLNavigator.push(context, PrivacyPage(),
                transition: OTLNavigatorTransition.downUp);
          },
          text: 'title.privacy'.tr(),
          textStyle: labelRegular.copyWith(color: OTLColor.gray75),
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          tapEffect: ButtonTapEffect.lighten,
        ),
        IconTextButton(
          onTap: () {
            OTLNavigator.push(context, PeoplePage(),
                transition: OTLNavigatorTransition.downUp);
          },
          text: 'title.credit'.tr(),
          textStyle: labelRegular.copyWith(color: OTLColor.gray75),
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          tapEffect: ButtonTapEffect.lighten,
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      "assets/sparcs.png",
      height: 27,
    );
  }

  Widget _buildCopyRight() {
    return Text.rich(
      TextSpan(
        style: labelRegular.copyWith(color: OTLColor.gray75),
        children: [
          TextSpan(text: 'otlplus@sparcs.org'),
          TextSpan(text: '\n'),
          TextSpan(text: '© 2023 SPARCS OTL Team'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  List<String> getRemainedTime(Duration timeDiff) {
    final days = timeDiff.inDays;
    final hours = timeDiff.inHours - timeDiff.inDays * 24;
    final minutes = timeDiff.inMinutes - timeDiff.inHours * 60;
    return [days.toString(), hours.toString(), minutes.toString()];
  }

  Widget _buildSchedule(DateTime now, Map<String, dynamic>? currentSchedule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          (currentSchedule == null)
              ? "common.no_info".tr()
              : "home.schedule.remained_datetime".tr(
                  args: getRemainedTime(
                      currentSchedule["time"].difference(now) as Duration)),
          style: titleRegular,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4.0),
        (currentSchedule == null)
            ? Text('-', style: bodyBold)
            : Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    '${(currentSchedule["semester"] as Semester).title} ${(currentSchedule["name"] as String).tr()}',
                    style: bodyBold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat("yyyy.MM.dd")
                        .format(currentSchedule["time"].toLocal()),
                    style: bodyRegular,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildTimetable(User user, Semester semester, DateTime now) {
    List<Lecture> myLecturesList = user.myTimetableLectures
        .where((lecture) =>
            lecture.year == semester.year &&
            lecture.semester == semester.semester)
        .toList();
    Timetable timetable = Timetable(id: 0, lectures: myLecturesList);
    return Container(
      height: 76,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: TodayTimetable(
          lectures: timetable.lectures,
          now: now,
          builder: (lecture, classTimeIndex) => TimetableBlock(
            lecture: lecture,
            classTimeIndex: classTimeIndex,
            onTap: () {
              context.read<LectureDetailModel>().loadLecture(lecture.id, false);
              OTLNavigator.push(context, LectureDetailPage());
            },
          ),
        ),
      ),
    );
  }
}
