import 'package:flutter/material.dart';
import 'package:otlplus/pages/course_detail_page.dart';
import 'package:otlplus/pages/course_search_page.dart';
import 'package:otlplus/pages/lecture_detail_page.dart';
import 'package:otlplus/pages/liked_review_page.dart';
import 'package:otlplus/pages/my_review_page.dart';
import 'package:otlplus/pages/privacy_page.dart';
import 'package:otlplus/pages/settings_page.dart';
import 'package:otlplus/pages/user_page.dart';

Route buildCourseDetailPageRoute() {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => CourseDetailPage(),
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final curveTween = CurveTween(curve: Curves.ease);
      final tween = Tween(begin: begin, end: end).chain(curveTween);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Route buildLectureDetailPageRoute() {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => LectureDetailPage(),
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final curveTween = CurveTween(curve: Curves.ease);
      final tween = Tween(begin: begin, end: end).chain(curveTween);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Route buildUserPageRoute() {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => UserPage(),
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      final curveTween = CurveTween(curve: Curves.ease);
      final tween = Tween(begin: begin, end: end).chain(curveTween);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Route buildSettingsPageRoute() {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => SettingsPage(),
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      final curveTween = CurveTween(curve: Curves.ease);
      final tween = Tween(begin: begin, end: end).chain(curveTween);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Route buildMyReviewPageRoute() {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => MyReviewPage(),
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final curveTween = CurveTween(curve: Curves.ease);
      final tween = Tween(begin: begin, end: end).chain(curveTween);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Route buildLikedReviewPageRoute() {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => LikedReviewPage(),
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final curveTween = CurveTween(curve: Curves.ease);
      final tween = Tween(begin: begin, end: end).chain(curveTween);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Route buildCourseSearchPageRoute() {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => CourseSearchPage(openKeyboard: false),
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      final curveTween = CurveTween(curve: Curves.ease);
      final tween = Tween(begin: begin, end: end).chain(curveTween);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Route buildPrivacyPageRoute() {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => PrivacyPage(),
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      final curveTween = CurveTween(curve: Curves.ease);
      final tween = Tween(begin: begin, end: end).chain(curveTween);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
