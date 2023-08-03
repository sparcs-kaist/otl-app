import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconTextButton extends StatefulWidget {
  const IconTextButton({
    Key? key,
    this.color = const Color(0xFF000000),
    this.icon,
    this.iconSize = 24,
    this.spaceBetween = 0,
    this.text,
    this.textStyle = const TextStyle(),
    this.padding,
    this.onTap,
    this.tapEffect = 'lighten',
    this.tapEffectColorRatio = 0.48,
    this.direction = 'row',
  })  : assert(icon is IconData || icon is String || icon == null),
        assert(icon != null || iconSize == 24),
        assert(text != null || textStyle == const TextStyle()),
        assert(tapEffect == 'none' ||
            tapEffect == 'darken' ||
            tapEffect == 'lighten'),
        assert(direction == 'row' ||
            direction == 'column' ||
            direction == 'row-reversed' ||
            direction == 'column-reversed'),
        super(key: key);
  final Color? color;
  final dynamic icon; // IconData or String or null
  final double iconSize;
  final double spaceBetween;
  final String? text;
  final TextStyle textStyle;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final String? tapEffect;
  final double tapEffectColorRatio;
  final String direction;

  @override
  State<IconTextButton> createState() => _IconTextButtonState();
}

class _IconTextButtonState extends State<IconTextButton> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, Map>> children = [
      if (widget.icon != null)
        if (widget.icon is IconData)
          {
            'Icon': {
              'arg': widget.icon,
              'size': widget.iconSize,
              'color': widget.color
            }
          }
        else if (widget.icon is String)
          {
            'SvgPicture.asset': {
              'arg': widget.icon,
              'height': widget.iconSize,
              'width': widget.iconSize,
              'color': widget.color
            }
          },
      widget.direction.startsWith('row')
          ? {
              'SizedBox': {
                'width': widget.spaceBetween,
              }
            }
          : {
              'SizedBox': {
                'height': widget.spaceBetween,
              }
            },
      if (widget.text != null)
        {
          'Text': {
            'arg': widget.text!,
            'style': widget.textStyle
                .copyWith(color: widget.textStyle.color ?? widget.color)
          }
        }
    ];
    Map<String, Map> child = widget.direction.startsWith('row')
        ? {
            'Row': {
              'children': widget.direction.endsWith('reversed')
                  ? children.reversed.toList()
                  : children
            }
          }
        : {
            'Column': {
              'children': widget.direction.endsWith('reversed')
                  ? children.reversed.toList()
                  : children
            }
          };
    return IconTextButtonRaw(
      data: widget.padding != null
          ? {
              'Padding': {'padding': widget.padding!, 'child': child}
            }
          : {
              'Center': {'child': child}
            },
      onTap: widget.onTap,
      tapEffect: widget.tapEffect,
      tapEffectColorRatio: widget.tapEffectColorRatio,
    );
  }
}

Widget renderRawResponsiveWidget(BuildContext context, Map<String, Map> data,
    String tapEffect, double tapEffectColorRatio, bool isTapDowned) {
  if (data.keys.length != 1) return const Placeholder();
  String widget = data.keys.first;
  Map args = data[widget]!;
  switch (widget) {
    case 'Row':
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: (args['children'] as List<Map<String, Map>>? ?? [])
            .map((e) => renderRawResponsiveWidget(
                context, e, tapEffect, tapEffectColorRatio, isTapDowned))
            .toList(),
      );
    case 'Row-reversed':
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: (args['children'] as List<Map<String, Map>>? ?? [])
            .map((e) => renderRawResponsiveWidget(
                context, e, tapEffect, tapEffectColorRatio, isTapDowned))
            .toList()
            .reversed
            .toList(),
      );
    case 'Column':
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: (args['children'] as List<Map<String, Map>>? ?? [])
            .map((e) => renderRawResponsiveWidget(
                context, e, tapEffect, tapEffectColorRatio, isTapDowned))
            .toList(),
      );
    case 'Column-reversed':
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: (args['children'] as List<Map<String, Map>>? ?? [])
            .map((e) => renderRawResponsiveWidget(
                context, e, tapEffect, tapEffectColorRatio, isTapDowned))
            .toList()
            .reversed
            .toList(),
      );
    case 'Icon':
      return Icon(args['arg'] ?? null,
          size: args['size'] ?? 24.0,
          color: Color.lerp(
              args['color'] ?? const Color(0xFF000000),
              tapEffect == 'darken'
                  ? const Color(0xFF000000)
                  : tapEffect == 'lighten'
                      ? const Color(0xFFFFFFFF)
                      : args['color'] ?? const Color(0xFF000000),
              isTapDowned ? tapEffectColorRatio : 0));
    case 'SvgPicture.asset':
      return SvgPicture.asset(args['arg'] ?? null,
          width: args['width'] ?? 24.0,
          height: args['height'] ?? 24.0,
          colorFilter: ColorFilter.mode(
              Color.lerp(
                  args['color'] ?? const Color(0xFF000000),
                  tapEffect == 'darken'
                      ? const Color(0xFF000000)
                      : tapEffect == 'lighten'
                          ? const Color(0xFFFFFFFF)
                          : args['color'] ?? const Color(0xFF000000),
                  isTapDowned ? tapEffectColorRatio : 0)!,
              BlendMode.srcIn));
    case 'SizedBox':
      return SizedBox(
          width: args['width'],
          height: args['height'],
          child: args['child'] != null
              ? renderRawResponsiveWidget(context, args['child'] ?? {},
                  tapEffect, tapEffectColorRatio, isTapDowned)
              : null);
    case 'Spacer':
      return Spacer(flex: args['flex'] ?? 1);
    case 'Text':
      return Text(args['arg'] ?? '',
          style: ((args['style'] ?? const TextStyle()) as TextStyle).copyWith(
              color: Color.lerp(
                  (args['style'] ?? const TextStyle()).color ??
                      const Color(0xFF000000),
                  tapEffect == 'darken'
                      ? const Color(0xFF000000)
                      : tapEffect == 'lighten'
                          ? const Color(0xFFFFFFFF)
                          : (args['style'] ?? const TextStyle()).color ??
                              const Color(0xFF000000),
                  isTapDowned ? tapEffectColorRatio : 0)));
    case 'Padding':
      return Padding(
          padding: args['padding'] ?? EdgeInsets.zero,
          child: renderRawResponsiveWidget(context, args['child'] ?? {},
              tapEffect, tapEffectColorRatio, isTapDowned));
    case 'Center':
      return Center(
          child: renderRawResponsiveWidget(context, args['child'] ?? {},
              tapEffect, tapEffectColorRatio, isTapDowned));
    default:
      return const Placeholder();
  }
}

class IconTextButtonRaw extends StatefulWidget {
  const IconTextButtonRaw({
    Key? key,
    required this.data,
    this.onTap,
    this.tapEffect = 'lighten',
    this.tapEffectColorRatio = 0.48,
  }) : super(key: key);
  final Map<String, Map> data;
  final VoidCallback? onTap;
  final String? tapEffect;
  final double tapEffectColorRatio;

  @override
  State<IconTextButtonRaw> createState() => _IconTextButtonRawState();
}

class _IconTextButtonRawState extends State<IconTextButtonRaw> {
  bool _isTapDowned = false;
  bool _delaying = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          setState(() {
            _isTapDowned = true;
          });
          _delaying = false;
          Future.delayed(const Duration(milliseconds: 128), () {
            _delaying = true;
            if (_isTapDowned == false)
              setState(() {
                _isTapDowned = false;
              });
          });
        },
        onTapUp: (_) {
          if (_isTapDowned && widget.onTap != null) {
            widget.onTap!();
          }
          if (_delaying)
            setState(() {
              _isTapDowned = false;
            });
          else
            _isTapDowned = false;
        },
        onTapCancel: () {
          setState(() {
            _isTapDowned = false;
          });
        },
        child: renderRawResponsiveWidget(context, widget.data,
            widget.tapEffect!, widget.tapEffectColorRatio, _isTapDowned));
  }
}

class BackgroundButton extends StatefulWidget {
  const BackgroundButton(
      {Key? key,
      this.color = const Color(0x00000000),
      this.onTap,
      this.onLongPress,
      this.tapEffect = 'darken',
      this.tapEffectColorRatio = 0.12,
      required this.child})
      : assert(tapEffect == 'none' ||
            tapEffect == 'darken' ||
            tapEffect == 'lighten'),
        super(key: key);
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? tapEffect;
  final double tapEffectColorRatio;
  final Widget child;

  @override
  State<BackgroundButton> createState() => _BackgroundButtonState();
}

class _BackgroundButtonState extends State<BackgroundButton> {
  bool _isTapDowned = false;
  bool _delaying = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          setState(() {
            _isTapDowned = true;
          });
          _delaying = false;
          Future.delayed(const Duration(milliseconds: 128), () {
            _delaying = true;
            if (_isTapDowned == false)
              setState(() {
                _isTapDowned = false;
              });
          });
        },
        onTapUp: (_) {
          if (_isTapDowned && widget.onTap != null) {
            widget.onTap!();
          }
          if (_delaying)
            setState(() {
              _isTapDowned = false;
            });
          else
            _isTapDowned = false;
        },
        onTapCancel: () {
          setState(() {
            _isTapDowned = false;
          });
        },
        onLongPress: widget.onLongPress,
        child: ColoredBox(
          color: Color.lerp(
              widget.color,
              widget.tapEffect == 'darken'
                  ? const Color(0xFF000000)
                  : widget.tapEffect == 'lighten'
                      ? const Color(0xFFFFFFFF)
                      : widget.color,
              _isTapDowned ? widget.tapEffectColorRatio : 0)!,
          child: widget.child,
        ));
  }
}
