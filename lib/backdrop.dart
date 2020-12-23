import 'package:flutter/material.dart';
import 'package:timeplanner_mobile/widgets/custom_appbar.dart';

const double _kFlingVelocity = 2.0;

class Backdrop extends InheritedWidget {
  final _BackdropScaffoldState state;

  Backdrop({Key key, @required this.state, @required Widget child})
      : super(key: key, child: child);

  static _BackdropScaffoldState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Backdrop>().state;

  @override
  bool updateShouldNotify(Backdrop oldWidget) => state != oldWidget.state;
}

class BackdropScaffold extends StatefulWidget {
  final Widget frontLayer;
  final Widget bottomNavigationBar;
  final List<Widget> actions;

  BackdropScaffold(
      {@required this.frontLayer, this.bottomNavigationBar, this.actions});

  @override
  _BackdropScaffoldState createState() => _BackdropScaffoldState();
}

class _BackdropScaffoldState extends State<BackdropScaffold>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Widget _backLayer;

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

  bool get frontLayerVisible {
    return _controller.status == AnimationStatus.completed ||
        _controller.status == AnimationStatus.forward;
  }

  void toggleBackdropLayerVisibility([Widget backLayer]) {
    setState(() {
      _backLayer = backLayer;
      _controller.fling(
          velocity: frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
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
          child: _backLayer ?? const SizedBox.expand(),
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
      toggleBackdropLayerVisibility();
      return null;
    }
    return true;
  }

  AppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      actions: frontLayerVisible
          ? widget.actions
          : <Widget>[
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: toggleBackdropLayerVisibility,
              ),
            ],
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
            appBar: _buildAppBar(context),
            bottomNavigationBar: widget.bottomNavigationBar,
            body: LayoutBuilder(builder: _buildStack),
            resizeToAvoidBottomInset: false,
          ),
        ),
      ),
    );
  }
}
