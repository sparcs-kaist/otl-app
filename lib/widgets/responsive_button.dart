import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconTextButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    List<Map<String, Map>> children = [
      if (icon != null)
        if (icon is IconData)
          {
            'Icon': {'arg': icon, 'size': iconSize, 'color': color}
          }
        else if (icon is String)
          {
            'SvgPicture.asset': {
              'arg': icon,
              'height': iconSize,
              'width': iconSize,
              'color': color
            }
          },
      direction.startsWith('row')
          ? {
              'SizedBox': {
                'width': spaceBetween,
              }
            }
          : {
              'SizedBox': {
                'height': spaceBetween,
              }
            },
      if (text != null)
        {
          'Text': {
            'arg': text!,
            'style': textStyle.copyWith(color: textStyle.color ?? color)
          }
        }
    ];
    Map<String, Map> child = direction.startsWith('row')
        ? {
            'Row': {
              'children': direction.endsWith('reversed')
                  ? children.reversed.toList()
                  : children
            }
          }
        : {
            'Column': {
              'children': direction.endsWith('reversed')
                  ? children.reversed.toList()
                  : children
            }
          };
    return RawResponsiveButton(
      data: padding != null
          ? {
              'Padding': {'padding': padding!, 'child': child}
            }
          : {
              'Center': {'child': child}
            },
      onTap: onTap,
      tapEffect: tapEffect,
      tapEffectColorRatio: tapEffectColorRatio,
    );
  }
}

class BackgroundButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return RawResponsiveButton(
      data: {
        'ColoredBox': {
          'color': color,
          'child': child,
        }
      },
      onTap: onTap,
      onLongPress: onLongPress,
      tapEffect: tapEffect,
      tapEffectColorRatio: tapEffectColorRatio,
    );
  }
}

class RawResponsiveWidget extends StatelessWidget {
  const RawResponsiveWidget(
      {required this.data,
      required this.tapEffect,
      required this.tapEffectColorRatio,
      required this.pressedEffect,
      Key? key})
      : super(key: key);
  final Map<String, Map> data;
  final String tapEffect;
  final double tapEffectColorRatio;
  final ValueNotifier<bool> pressedEffect;

  @override
  Widget build(BuildContext context) {
    if (data.keys.length != 1) return const Placeholder();
    String widget = data.keys.first;
    Map args = data[widget]!;
    switch (widget) {
      case 'Row':
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: (args['children'] as List<Map<String, Map>>? ?? [])
              .map((e) => RawResponsiveWidget(
                  data: e,
                  tapEffect: tapEffect,
                  tapEffectColorRatio: tapEffectColorRatio,
                  pressedEffect: pressedEffect))
              .toList(),
        );
      case 'Row-reversed':
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: (args['children'] as List<Map<String, Map>>? ?? [])
              .map((e) => RawResponsiveWidget(
                  data: e,
                  tapEffect: tapEffect,
                  tapEffectColorRatio: tapEffectColorRatio,
                  pressedEffect: pressedEffect))
              .toList()
              .reversed
              .toList(),
        );
      case 'Column':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: (args['children'] as List<Map<String, Map>>? ?? [])
              .map((e) => RawResponsiveWidget(
                  data: e,
                  tapEffect: tapEffect,
                  tapEffectColorRatio: tapEffectColorRatio,
                  pressedEffect: pressedEffect))
              .toList(),
        );
      case 'Column-reversed':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: (args['children'] as List<Map<String, Map>>? ?? [])
              .map((e) => RawResponsiveWidget(
                  data: e,
                  tapEffect: tapEffect,
                  tapEffectColorRatio: tapEffectColorRatio,
                  pressedEffect: pressedEffect))
              .toList()
              .reversed
              .toList(),
        );
      case 'Icon':
        final Color unpressedColor = args['color'] ?? const Color(0xFF000000);
        final Color pressedColor = Color.lerp(
            unpressedColor,
            tapEffect == 'darken'
                ? const Color(0xFF000000)
                : tapEffect == 'lighten'
                    ? const Color(0xFFFFFFFF)
                    : unpressedColor,
            tapEffectColorRatio)!;
        return ValueListenableBuilder<bool>(
            valueListenable: pressedEffect,
            builder: (BuildContext context, bool effect, Widget? child) {
              return Icon(args['arg'] ?? null,
                  size: args['size'] ?? 24.0,
                  color: effect ? pressedColor : unpressedColor);
            });
      case 'SvgPicture.asset':
        final ColorFilter unpressedColorFilter = ColorFilter.mode(
            args['color'] ?? const Color(0xFF000000), BlendMode.srcIn);
        final ColorFilter pressedColorFilter = ColorFilter.mode(
            Color.lerp(
                args['color'] ?? const Color(0xFF000000),
                tapEffect == 'darken'
                    ? const Color(0xFF000000)
                    : tapEffect == 'lighten'
                        ? const Color(0xFFFFFFFF)
                        : args['color'] ?? const Color(0xFF000000),
                tapEffectColorRatio)!,
            BlendMode.srcIn);
        return ValueListenableBuilder<bool>(
            valueListenable: pressedEffect,
            builder: (BuildContext context, bool effect, Widget? child) {
              return SvgPicture.asset(args['arg'] ?? null,
                  width: args['width'] ?? 24.0,
                  height: args['height'] ?? 24.0,
                  colorFilter:
                      effect ? pressedColorFilter : unpressedColorFilter);
            });
      case 'SizedBox':
        return SizedBox(
            width: args['width'],
            height: args['height'],
            child: (args['child'] == null)
                ? null
                : RawResponsiveWidget(
                    data: args['child']!,
                    tapEffect: tapEffect,
                    tapEffectColorRatio: tapEffectColorRatio,
                    pressedEffect: pressedEffect));
      case 'Spacer':
        return Spacer(flex: args['flex'] ?? 1);
      case 'Text':
        final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
        TextStyle unpressedTextStyle =
            defaultTextStyle.style.merge(args['style']);
        if (MediaQuery.boldTextOf(context)) {
          unpressedTextStyle = unpressedTextStyle
              .merge(const TextStyle(fontWeight: FontWeight.bold));
        }
        final TextStyle? pressedTextStyle = unpressedTextStyle.copyWith(
            color: Color.lerp(
                unpressedTextStyle.color ?? const Color(0xFF000000),
                tapEffect == 'darken'
                    ? const Color(0xFF000000)
                    : tapEffect == 'lighten'
                        ? const Color(0xFFFFFFFF)
                        : unpressedTextStyle.color ?? const Color(0xFF000000),
                tapEffectColorRatio));
        return ValueListenableBuilder<bool>(
            valueListenable: pressedEffect,
            builder: (BuildContext context, bool effect, Widget? child) {
              return Text(args['arg'] ?? '',
                  style: effect ? pressedTextStyle : unpressedTextStyle);
            });
      case 'ColoredBox':
        final Color unpressedColor = args['color'] ?? const Color(0x00000000);
        final Color pressedColor = Color.lerp(
            unpressedColor,
            tapEffect == 'darken'
                ? const Color(0xFF000000)
                : tapEffect == 'lighten'
                    ? const Color(0xFFFFFFFF)
                    : unpressedColor,
            tapEffectColorRatio)!;
        return ValueListenableBuilder<bool>(
          valueListenable: pressedEffect,
          builder: (BuildContext context, bool effect, Widget? child) {
            return ColoredBox(
              color: effect ? pressedColor : unpressedColor,
              child: child,
            );
          },
          child: args['child'],
        );
      case 'Padding':
        return Padding(
            padding: args['padding'] ?? EdgeInsets.zero,
            child: (args['child'] == null)
                ? null
                : RawResponsiveWidget(
                    data: args['child'],
                    tapEffect: tapEffect,
                    tapEffectColorRatio: tapEffectColorRatio,
                    pressedEffect: pressedEffect));
      case 'Center':
        return Center(
            child: (args['child'] == null)
                ? null
                : RawResponsiveWidget(
                    data: args['child'] ?? {},
                    tapEffect: tapEffect,
                    tapEffectColorRatio: tapEffectColorRatio,
                    pressedEffect: pressedEffect));
      default:
        return const Placeholder();
    }
  }
}

class RawResponsiveButton extends StatefulWidget {
  const RawResponsiveButton({
    Key? key,
    required this.data,
    this.onTap,
    this.onLongPress,
    this.tapEffect = 'lighten',
    this.tapEffectColorRatio = 0.48,
  }) : super(key: key);
  final Map<String, Map> data;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? tapEffect;
  final double tapEffectColorRatio;

  @override
  State<RawResponsiveButton> createState() => _RawResponsiveButtonState();
}

class _RawResponsiveButtonState extends State<RawResponsiveButton> {
  bool _isDisposed = false;
  bool _isPressed = false;
  bool _delaying = false;
  final ValueNotifier<bool> _pressedEffect = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isDisposed = true;
    _pressedEffect.dispose();
    super.dispose();
  }

  void setPressed(bool value) {
    if (!_isDisposed) _pressedEffect.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) {
          _isPressed = true;
          setPressed(true);
          _delaying = true;
          Future.delayed(const Duration(milliseconds: 128), () {
            _delaying = false;
            if (_isPressed == false) setPressed(false);
            Future.delayed(const Duration(milliseconds: 512), () {
              if (_isPressed) widget.onLongPress?.call();
            });
          });
        },
        onTapUp: (_) {
          if (_isPressed) widget.onTap?.call();
          _isPressed = false;
          if (_delaying == false) setPressed(false);
        },
        onTapCancel: () {
          _isPressed = false;
          if (_delaying == false) setPressed(false);
        },
        child: RawResponsiveWidget(
            data: widget.data,
            tapEffect: widget.tapEffect!,
            tapEffectColorRatio: widget.tapEffectColorRatio,
            pressedEffect: _pressedEffect));
  }
}
