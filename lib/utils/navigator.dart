import 'package:flutter/material.dart';

class OTLNavigator {
  static List<Route> _rightleftTransitionHistory = [];
  static List<Route> _downupTransitionHistory = [];
  static List<int> _history =
      []; //0 for right-left, 1 for down-up, 2 for immediate, 3 for dialog

  static Future<T?> push<T extends Object?>(BuildContext context, Widget page,
      {String transition = "right-left"}) {
    assert(transition == "down-up" ||
        transition == "right-left" ||
        transition == "immediate");
    Route<T> _route;
    if (transition == "right-left") {
      _route = buildRightLeftPageRoute<T>(page);
      _rightleftTransitionHistory.add(_route);
      _history.add(0);
    } else if (transition == "down-up") {
      _route = buildDownUpPageRoute<T>(page);
      _downupTransitionHistory.add(_route);
      _history.add(1);
    } else {
      _route = buildImmediatePageRoute<T>(page);
      _downupTransitionHistory.add(_route);
      _history.add(1);
    }
    return Navigator.of(context).push(_route);
  }

  static void pop<T extends Object?>(BuildContext context,
      {String transition = "none", T? result}) {
    assert(transition == "down-up" ||
        transition == "right-left" ||
        transition == "immediate" ||
        transition == "none");
    NavigatorState navigator = Navigator.of(context);
    assert(_history.isNotEmpty);
    if (transition == "none") {
      if (_history.last != 3) {
        if (_history.last == 0)
          _rightleftTransitionHistory.removeLast();
        else
          _downupTransitionHistory.removeLast();
      }
      _history.removeLast();
      return navigator.pop(result);
    } else if (transition == "right-left") {
      assert(_rightleftTransitionHistory.isNotEmpty);
      navigator.popUntil((Route<dynamic> route) =>
          _rightleftTransitionHistory.last == route || route.isFirst);
      _rightleftTransitionHistory.removeLast();
      _history.removeLast();
      return navigator.pop(result);
    } else {
      assert(_downupTransitionHistory.isNotEmpty);
      navigator.popUntil((Route<dynamic> route) =>
          _downupTransitionHistory.last == route || route.isFirst);
      _downupTransitionHistory.removeLast();
      _history.removeLast();
      return navigator.pop(result);
    }
  }

  static bool get canPop => _history.isNotEmpty;

  static Future<T?> pushDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) {
    _history.add(3);
    return showDialog(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior,
    );
  }
}

Route<T> buildRightLeftPageRoute<T extends Object?>(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => page,
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

Route<T> buildDownUpPageRoute<T extends Object?>(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => page,
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

Route<T> buildImmediatePageRoute<T extends Object?>(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}
