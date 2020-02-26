import 'package:flutter/material.dart';

class CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget Function(double) builder;
  final double height;
  final EdgeInsetsGeometry padding;
  final void Function(double) onTap;

  CustomHeaderDelegate(
      {@required this.builder,
      @required this.height,
      this.padding,
      this.onTap});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: padding,
      transform: Matrix4.translationValues(0, -1, 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(shrinkOffset),
          child: builder(shrinkOffset),
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
