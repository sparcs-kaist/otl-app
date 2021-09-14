import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otlplus/constants/color.dart';

const double _kFlingVelocity = 2.0;

class Backdrop extends InheritedWidget {
  final _BackdropScaffoldState state;

  Backdrop({Key? key, required this.state, required Widget child})
      : super(key: key, child: child);

  static _BackdropScaffoldState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Backdrop>()!.state;

  @override
  bool updateShouldNotify(Backdrop oldWidget) => state != oldWidget.state;
}

class BackdropScaffold extends StatefulWidget {
  final Widget frontLayer;
  final List<Widget> backLayers;
  final Widget? bottomNavigationBar;
  final List<Widget>? actions;
  final Widget? expandedWidget;
  final bool isExpanded;

  BackdropScaffold(
      {required this.frontLayer,
      required this.backLayers,
      this.bottomNavigationBar,
      this.actions,
      this.expandedWidget,
      this.isExpanded = false});

  @override
  _BackdropScaffoldState createState() => _BackdropScaffoldState();
}

class _BackdropScaffoldState extends State<BackdropScaffold>
    with SingleTickerProviderStateMixin {
  bool get isExpanded => widget.isExpanded && frontLayerVisible;
  bool get frontLayerVisible =>
      _controller.status == AnimationStatus.completed ||
      _controller.status == AnimationStatus.forward;

  late AnimationController _controller;
  int _selectedIndex = 0;
  List<int> _indexStack = <int>[];

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
  void didUpdateWidget(BackdropScaffold old) {
    super.didUpdateWidget(old);

    if (!frontLayerVisible) _controller.fling(velocity: _kFlingVelocity);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void show([int index = -1]) {
    setState(() {
      if (index > -1) {
        if (frontLayerVisible)
          _indexStack.clear();
        else
          _indexStack.add(_selectedIndex);
        _indexStack.remove(index);
        _selectedIndex = index;
        _controller.fling(velocity: -_kFlingVelocity);
      } else if (_indexStack.length > 0) {
        _selectedIndex = _indexStack.last;
        _indexStack.removeLast();
        _controller.fling(velocity: -_kFlingVelocity);
      } else {
        _controller.fling(velocity: _kFlingVelocity);
      }
    });
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
        AnimatedOpacity(
          child: IndexedStack(
            index: _selectedIndex,
            children: widget.backLayers,
          ),
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300),
          opacity: frontLayerVisible ? 0.0 : 1.0,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: AnimatedOpacity(
            child: widget.frontLayer,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            opacity: frontLayerVisible ? 1.0 : 0.0,
          ),
        ),
      ],
    );
  }

  Future<bool> _willPop() async {
    if (!frontLayerVisible) {
      show();
      return false;
    }
    return true;
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(isExpanded
          ? MediaQuery.of(context).size.width / 1296 * 865 + 5
          : kToolbarHeight),
      child: Theme(
        data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme(
          color: BACKGROUND_COLOR,
          elevation: 0.0,
          actionsIconTheme: IconThemeData(
            color: isExpanded ? Colors.white70 : CONTENT_COLOR,
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
                if (isExpanded) widget.expandedWidget!,
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          actions: frontLayerVisible
              ? widget.actions
              : <Widget>[
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: isExpanded ? Colors.white70 : null,
                    onPressed: show,
                  ),
                ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      state: this,
      child: Builder(
        builder: (context) => WillPopScope(
          onWillPop: _willPop,
          child: Scaffold(
            appBar: _buildAppBar(),
            backgroundColor:
                isExpanded ? const Color(0xFF9B4810) : BACKGROUND_COLOR,
            bottomNavigationBar: widget.bottomNavigationBar,
            body: LayoutBuilder(builder: _buildStack),
            resizeToAvoidBottomInset: false,
          ),
        ),
      ),
    );
  }
}
