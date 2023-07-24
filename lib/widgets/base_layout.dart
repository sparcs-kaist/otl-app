import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otlplus/constants/color.dart';

class BaseLayout extends StatefulWidget {
  final Widget body;
  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;
  final bool enableBackButton;
  final VoidCallback? onBack;
  final Color sheetBackgroundColor;

  const BaseLayout({
    Key? key,
    required this.body,
    this.leading,
    this.middle,
    this.trailing,
    this.enableBackButton = false,
    this.onBack,
    this.sheetBackgroundColor = Colors.white,
  }) : super(key: key);

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

//NavigationToolbar
class _BaseLayoutState extends State<BaseLayout> {
  @override
  Widget build(BuildContext context) {
    final NavigatorState? navigator = Navigator.maybeOf(context);
    return ColoredBox(
      color: OTLColor.pinksLight,
      child: Column(
        children: [
          SizedBox(
              height: kToolbarHeight,
              child: NavigationToolbar(
                centerMiddle: true,
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (navigator != null &&
                        navigator.canPop() &&
                        widget.enableBackButton)
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
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: ColoredBox(
              color: widget.sheetBackgroundColor,
              child: SizedBox(width: double.infinity, child: widget.body),
            ),
          ))
        ],
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
        child: SvgPicture.asset('assets/icons/back.svg',
            height: 24.0,
            width: 24.0,
            colorFilter: ColorFilter.mode(Color(0xFF000000), BlendMode.srcIn)),
      ),
    );
  }
}
