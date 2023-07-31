import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconTextButton extends StatefulWidget {
  const IconTextButton({
    Key? key,
    this.icon,
    this.iconSize = 24,
    this.iconColor = const Color(0xFF000000),
    this.spaceBetween = 0,
    this.text,
    this.textStyle = const TextStyle(),
    this.padding = EdgeInsets.zero,
    this.onTap,
    this.pressedEffect = 'lighten',
    this.pressedEffectColorRatio = 0.48,
    this.direction = 'row',
  }) : assert(icon is IconData || icon is String || icon == null),
    assert(icon != null || (iconSize == 24 && iconColor == const Color(0xFF000000))), 
    assert(text != null || textStyle == const TextStyle()),
    assert(pressedEffect == 'none' || pressedEffect == 'darken' || pressedEffect == 'lighten'),
    assert(direction == 'row' || direction == 'column'),
    super(key: key);
  final dynamic icon; // IconData or String or null
  final double iconSize;
  final Color iconColor;
  final double spaceBetween;
  final String? text;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? pressedEffect;
  final double pressedEffectColorRatio;
  final String direction;

  @override
  State<IconTextButton> createState() => _IconTextButtonState();
}

class _IconTextButtonState extends State<IconTextButton> {
  bool _isPressed = false;
  bool _canUnPress = false;
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      if(widget.icon != null) 
        if(widget.icon is IconData)
          Icon(
            widget.icon,
            size: widget.iconSize,
            color: Color.lerp(
              widget.iconColor,
              widget.pressedEffect == 'darken' ? Color(0xFF000000) : 
              widget.pressedEffect == 'lighten' ? Color(0xFFFFFFFF) : 
              widget.iconColor,
              _isPressed ? widget.pressedEffectColorRatio : 0
            )
          )
        else if(widget.icon is String)
          SvgPicture.asset(
            widget.icon,
            height: 24.0,
            width: 24.0,
            colorFilter: ColorFilter.mode(
              Color.lerp(
                widget.iconColor,
                widget.pressedEffect == 'darken' ? Color(0xFF000000) : 
                widget.pressedEffect == 'lighten' ? Color(0xFFFFFFFF) : 
                widget.iconColor,
                _isPressed ? widget.pressedEffectColorRatio : 0
              )!, BlendMode.srcIn
            )
          ),
      widget.direction == 'row' ? SizedBox(width: widget.spaceBetween) : SizedBox(height: widget.spaceBetween),
      if(widget.text != null)
        Text(
          widget.text!,
          style: widget.textStyle.copyWith(
            color: Color.lerp(
              widget.textStyle.color ?? Color(0xFF000000),
              widget.pressedEffect == 'darken' ? Color(0xFF000000) : 
              widget.pressedEffect == 'lighten' ? Color(0xFFFFFFFF) : 
              widget.iconColor,
              _isPressed ? widget.pressedEffectColorRatio : 0
            )
          ),
        )
    ];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
        _canUnPress = false;
        Future.delayed(const Duration(milliseconds: 128), () {
          _canUnPress = true;
          if(_isPressed == false)
            setState(() {
              _isPressed = false;
            });
        });
      },
      onTapUp: (_) {
        if(_isPressed && widget.onTap != null) {
          widget.onTap!();
        }
        if(_canUnPress)
          setState(() {
            _isPressed = false;
          });
        else
          _isPressed = false;
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Center(
        child: Padding(
          padding: widget.padding,
          child: widget.direction == 'row' ?
            Row(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ) :
            Column(
              mainAxisSize: MainAxisSize.min,
              children: children
            )
        ),
      )
    );
  }
}

class BackgroundButton extends StatefulWidget {
  const BackgroundButton({
    Key? key,
    this.color = const Color(0x00FFFFFF),
    this.onTap,
    this.pressedEffect = 'darken',
    this.pressedEffectColorRatio = 0.08,
    required this.child
  }) : assert(pressedEffect == 'none' || pressedEffect == 'darken' || pressedEffect == 'lighten'),
    super(key: key);
  final Color color;
  final VoidCallback? onTap;
  final String? pressedEffect;
  final double pressedEffectColorRatio;
  final Widget child;

  @override
  State<BackgroundButton> createState() => _BackgroundButtonState();
}

class _BackgroundButtonState extends State<BackgroundButton> {
  bool _isPressed = false;
  bool _canUnPress = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
        _canUnPress = false;
        Future.delayed(const Duration(milliseconds: 128), () {
          _canUnPress = true;
          if(_isPressed == false)
            setState(() {
              _isPressed = false;
            });
        });
      },
      onTapUp: (_) {
        if(_isPressed && widget.onTap != null) {
          widget.onTap!();
        }
        if(_canUnPress)
          setState(() {
            _isPressed = false;
          });
        else
          _isPressed = false;
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: ColoredBox(
        color: Color.lerp(
          widget.color,
          widget.pressedEffect == 'darken' ? Color(0xFF000000) : 
          widget.pressedEffect == 'lighten' ? Color(0xFFFFFFFF) : 
          widget.color,
          _isPressed ? widget.pressedEffectColorRatio : 0
        )!,
        child: widget.child,
      )
    );
  }
}