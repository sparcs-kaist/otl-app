import 'package:flutter/material.dart';

class OTLNavigator {
  static List<Route> _rightleftTransitionHistory = [];
  static List<Route> _downupTransitionHistory = [];
  //0 for right-left, 1 for down-up, 2 for immediate, 3 for dialog
  static List<int> _history = [];

  static void _removeLastHistory() {
    switch (_history.removeLast()) {
      case 0:
        _rightleftTransitionHistory.removeLast();
        break;
      case 1:
      case 2:
        _downupTransitionHistory.removeLast();
        break;
      case 3:
        break;
    }
  }

  static void _removeLastUntil(bool Function(int mode) predicate) {
    while (!predicate(_history.last)) {
      _removeLastHistory();
    }
    _removeLastHistory();
  }

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
      _history.add(2);
    }
    return Navigator.of(context).push(_route);
  }

  static Future<T?> pushRoot<T extends Object?>(
      BuildContext context, Widget page,
      {String transition = "immediate"}) {
    assert(transition == "down-up" ||
        transition == "right-left" ||
        transition == "immediate");
    _rightleftTransitionHistory.clear();
    _downupTransitionHistory.clear();
    _history.clear();
    Route<T> _route;
    if (transition == "right-left") {
      _route = buildRightLeftPageRoute<T>(page);
    } else if (transition == "down-up") {
      _route = buildDownUpPageRoute<T>(page);
    } else {
      _route = buildImmediatePageRoute<T>(page);
    }
    return Navigator.of(context)
        .pushAndRemoveUntil(_route, (Route<dynamic> route) => false);
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
      _removeLastHistory();
      return navigator.pop(result);
    } else if (transition == "right-left") {
      assert(_rightleftTransitionHistory.isNotEmpty);
      navigator.popUntil((Route<dynamic> route) =>
          _rightleftTransitionHistory.last == route || route.isFirst);
      _removeLastUntil((mode) => mode == 0);
      return navigator.pop(result);
    } else {
      assert(_downupTransitionHistory.isNotEmpty);
      navigator.popUntil((Route<dynamic> route) =>
          _downupTransitionHistory.last == route || route.isFirst);
      _removeLastUntil((mode) => (mode == 1 || mode == 2));
      return navigator.pop(result);
    }
  }

  static bool get canPop => _history.isNotEmpty;

  static bool get canPopRightLeft => _rightleftTransitionHistory.isNotEmpty;
  static bool get canPopDownUp => _downupTransitionHistory.isNotEmpty;

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
