import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/icon.dart';

class BaseScaffold extends StatefulWidget {
  final Widget body;
  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;
  final Widget? bottomNavigationBar;
  final Function()? onBack;
  final Color sheetBackgroundColor;
  final bool resizeToAvoidBottomInset;
  final bool disableBackButton;

  const BaseScaffold(
      {Key? key,
      required this.body,
      this.leading,
      this.middle,
      this.trailing,
      this.bottomNavigationBar,
      this.onBack,
      this.sheetBackgroundColor = Colors.white,
      this.resizeToAvoidBottomInset = false,
      this.disableBackButton = false})
      : super(key: key);

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

//NavigationToolbar
class _BaseScaffoldState extends State<BaseScaffold> {
  @override
  Widget build(BuildContext context) {
    final NavigatorState? navigator = Navigator.maybeOf(context);
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: BACKGROUND_COLOR,
      bottomNavigationBar: widget.bottomNavigationBar,
      body: Column(
        children: [
          SizedBox(
              height: kToolbarHeight,
              child: NavigationToolbar(
                centerMiddle: true,
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (navigator != null && navigator.canPop() && widget.disableBackButton == false)
                      _BackButton(onBack: widget.onBack),
                    if (widget.leading != null) widget.leading!,
                  ],
                ),
                middle: widget.middle,
                trailing: widget.trailing,
              )),
          Expanded(
              child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16)),
            child: ColoredBox(
              color: widget.sheetBackgroundColor,
              child: SizedBox(
                width: double.infinity,
                child: SafeArea(
                  top: false,
                  maintainBottomViewPadding: true,
                  child: AnimatedPadding(
                    padding: widget.resizeToAvoidBottomInset
                        ? EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom)
                        : EdgeInsets.zero,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.decelerate,
                    child: Padding(
                      padding: widget.resizeToAvoidBottomInset
                          ? EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom == 0 ? 0 : 8)
                          : EdgeInsets.zero,
                      child: widget.body,
                    ),
                  ),
                )
              ),
            ),
          ))
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(5),
      child: SafeArea(
        child: ColoredBox(
          color: PRIMARY_COLOR,
          child: SizedBox(
            height: 5,
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final Function()? onBack;
  const _BackButton({Key? key, this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onBack?.call();
        Navigator.maybePop(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(
          CustomIcons.back,
          size: 24,
          color: Colors.black,
        ),
      ),
    );
  }
}
