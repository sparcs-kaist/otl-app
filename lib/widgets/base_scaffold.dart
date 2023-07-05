import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';

class BaseScaffold extends StatefulWidget {
  final Widget body;
  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;
  final Widget? bottomNavigationBar;

  const BaseScaffold({
    Key? key,
    required this.body,
    this.leading,
    this.middle,
    this.trailing,
    this.bottomNavigationBar,
  }) : super(key: key);

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
                  if(navigator != null && navigator.canPop()) _BackButton(),
                  if(widget.leading != null) widget.leading!,
                ],
              ),
              middle: widget.middle,
              trailing: widget.trailing,
            )
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: ColoredBox(
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: widget.body,
                  )
                )
              ),
            )
          )
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
  const _BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.maybePop(context);
      }, 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(IconData(0xe800, fontFamily: 'BackButton', fontPackage: null), size: 24, color: Colors.black,),
      ),
    );
  }
}