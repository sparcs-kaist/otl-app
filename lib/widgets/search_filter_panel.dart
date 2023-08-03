import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart' as _;
import 'package:flutter/material.dart';
import 'package:otlplus/constants/color.dart';
import 'package:otlplus/constants/text_styles.dart';
import 'package:otlplus/models/filter.dart';
import 'package:otlplus/utils/responsive_button.dart';

class SearchFilterPanel extends StatefulWidget {
  final Map<String, FilterGroupInfo> filter;
  final Function(String varient, String code, bool selected) setFilter;

  SearchFilterPanel({
    Key? key,
    required this.filter,
    required this.setFilter,
  }) : super(key: key);

  @override
  State<SearchFilterPanel> createState() => _SearchFilterPanelState();
}

class _SearchFilterPanelState extends State<SearchFilterPanel> {
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OTLColor.grayF,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: GestureDetector(
        onTapDown: (e) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scrollbar(
          controller: _scrollController,
          child: ListView.separated(
              controller: _scrollController,
              itemCount: widget.filter.entries.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Selector(
                    title: widget.filter.values.elementAt(index).label,
                    selectList: widget.filter.values.elementAt(index).options,
                    type: widget.filter.values.elementAt(index).type,
                    isMultiSelect:
                        widget.filter.values.elementAt(index).isMultiSelect,
                    setFilter: (String code, bool selected) {
                      widget.setFilter(
                          widget.filter.keys.elementAt(index), code, selected);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8)),
        ),
      ),
    );
  }
}

class Selector extends StatefulWidget {
  final String title;
  final List<List<CodeLabelPair>> selectList;
  final String type;
  final bool isMultiSelect;
  final Function(String code, bool selected) setFilter;

  const Selector({
    Key? key,
    required this.title,
    required this.selectList,
    required this.type,
    this.isMultiSelect = true,
    required this.setFilter,
  }) : super(key: key);

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.title,
                      style: titleBold,
                    ),
                    const SizedBox(width: 8),
                    Visibility(
                      visible: widget.isMultiSelect,
                      child: Text.rich(
                        TextSpan(
                          children: widget.selectList
                                      .expand((i) => i)
                                      .where((i) => i.selected)
                                      .length ==
                                  0
                              ? [TextSpan(text: "common.all_selected".tr())]
                              : [
                                  TextSpan(
                                    text: widget.selectList
                                        .expand((i) => i)
                                        .where((i) => i.selected)
                                        .length
                                        .toString(),
                                  ),
                                  TextSpan(text: "common.num_selected".tr()),
                                ],
                          style: bodyRegular,
                        ),
                      ),
                    )
                  ],
                ),
                Visibility(
                  visible: widget.isMultiSelect &&
                      !widget.selectList.every(
                        (v) => v.every((w) => w.selected == false),
                      ),
                  child: IconTextButton(
                    onTap: () {
                      widget.selectList.forEach((v) {
                        v.forEach((w) {
                          widget.setFilter(w.code, false);
                        });
                      });
                    },
                    text: "common.reset".tr(),
                    textStyle: bodyRegular.copyWith(
                      color: OTLColor.pinksMain,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: Builder(builder: (context) {
              switch (widget.type) {
                case "radio":
                  return RadioSelection(
                    selectList: widget.selectList,
                    isMultiSelect: widget.isMultiSelect,
                    setFilter: widget.setFilter,
                  );
                case "slider":
                  return SilderSelection(
                    selectList: widget.selectList,
                    isMultiSelect: widget.isMultiSelect,
                    setFilter: widget.setFilter,
                  );
                default:
                  return Container();
              }
            }),
          ),
        ],
      ),
    );
  }
}

class RadioSelection extends StatefulWidget {
  const RadioSelection({
    required this.selectList,
    this.isMultiSelect = true,
    required this.setFilter,
    Key? key,
  }) : super(key: key);
  final List<List<CodeLabelPair>> selectList;
  final bool isMultiSelect;
  final Function(String code, bool selected) setFilter;

  @override
  State<RadioSelection> createState() => _RadioSelectionState();
}

class _RadioSelectionState extends State<RadioSelection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.selectList.map(
        (v) {
          return Row(
            children: List.generate(
              4,
              (i) => Expanded(
                child: i < v.length
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: RadioSelectButton(
                          option: v[i],
                          setOption: (b) {
                            if (!widget.isMultiSelect) {
                              b = true;
                              widget.selectList.forEach((e) => e.forEach(
                                  (c) => widget.setFilter(c.code, false)));
                            }
                            widget.setFilter(v[i].code, b);
                          },
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

class RadioSelectButton extends StatefulWidget {
  final CodeLabelPair option;
  final Function(bool) setOption;

  const RadioSelectButton(
      {Key? key, required this.option, required this.setOption})
      : super(key: key);

  @override
  State<RadioSelectButton> createState() => _RadioSelectButtonState();
}

class _RadioSelectButtonState extends State<RadioSelectButton> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: BackgroundButton(
        onTap: () => widget.setOption(!widget.option.selected),
        color: widget.option.selected ? OTLColor.pinksSub : OTLColor.grayE,
        child: SizedBox(
          height: 32.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.option.label,
                  style: labelRegular.copyWith(
                    color: widget.option.selected
                        ? OTLColor.gray0
                        : OTLColor.grayA,
                  ),
                ),
                widget.option.selected
                    ? const Icon(Icons.check, size: 16.0, color: OTLColor.gray0)
                    : const Icon(Icons.add, size: 16.0, color: OTLColor.grayA)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SilderSelection extends StatefulWidget {
  const SilderSelection(
      {required this.selectList,
      this.isMultiSelect = true,
      required this.setFilter,
      Key? key})
      : super(key: key);
  final List<List<CodeLabelPair>> selectList;
  final bool isMultiSelect;
  final Function(String code, bool selected) setFilter;

  @override
  State<SilderSelection> createState() => _SilderSelectionState();
}

class _SilderSelectionState extends State<SilderSelection> {
  double _textWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.rtl,
        textScaleFactor: MediaQuery.of(context).textScaleFactor)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }

  double _value = 0;

  TextStyle labelTextStyle = const TextStyle(
    fontSize: 12,
  );
  @override
  void initState() {
    super.initState();
    _value = widget.selectList.reversed
        .toList()
        .indexWhere((e) => e.first.selected == true)
        .toDouble();
    if (_value < 0) _value = 0;
  }

  @override
  Widget build(BuildContext context) {
    final divisions = widget.selectList.length - 1;
    return Padding(
      padding: const EdgeInsets.only(left: 2, right: 10),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double leftPadding = _textWidth(
                widget.selectList.reversed.first.first.label, labelTextStyle) /
            2;
        double rightPadding = _textWidth(
                widget.selectList.reversed.last.first.label, labelTextStyle) /
            2;
        double divisionWidth =
            (constraints.maxWidth - leftPadding - rightPadding) / divisions;
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: leftPadding - 8, right: rightPadding - 8),
              child: SliderTheme(
                data: SliderThemeData(
                    thumbShape: const CustomSliderThumbShape(
                        outerThumbRadius: 10,
                        innerThumbRadius: 7,
                        outerThumbColor: Color(0xFFF6C5CD),
                        innerThumbColor: Colors.white),
                    trackHeight: 5.0,
                    trackShape: const RoundRectangularSliderTrackShape(),
                    tickMarkShape: SliderTickMarkShape.noTickMark,
                    overlayShape: SliderComponentShape.noThumb),
                child: Slider(
                  value: _value,
                  min: 0.0,
                  max: divisions.toDouble(),
                  divisions: divisions,
                  activeColor: const Color(0xFFF6C5CD),
                  inactiveColor: const Color(0xFFEEEEEE),
                  onChanged: (double value) {
                    setState(() {
                      _value = value;
                    });
                  },
                  onChangeEnd: ((double value) {
                    if (!widget.isMultiSelect) {
                      widget.selectList.forEach((e) =>
                          e.forEach((c) => widget.setFilter(c.code, false)));
                    }
                    widget.setFilter(
                        widget.selectList.reversed
                            .elementAt(value.toInt())
                            .first
                            .code,
                        true);
                  }),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  divisions * 2 + 1,
                  (index) => index % 2 == 0
                      ? Column(
                          children: [
                            Text(
                              widget.selectList.reversed
                                  .elementAt(index ~/ 2)
                                  .first
                                  .label,
                              style: labelTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Spacer(
                          flex: (divisionWidth -
                                  (_textWidth(
                                              widget.selectList.reversed
                                                  .elementAt(index ~/ 2)
                                                  .first
                                                  .label,
                                              labelTextStyle) +
                                          _textWidth(
                                              widget.selectList.reversed
                                                  .elementAt((index ~/ 2) + 1)
                                                  .first
                                                  .label,
                                              labelTextStyle)) /
                                      2)
                              .toInt(),
                        )),
            ),
          ],
        );
      }),
    );
  }
}

class RoundRectangularSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const RoundRectangularSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    if (sliderTheme.trackHeight! <= 0) {
      return;
    }

    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Radius trackRadius = Radius.circular(trackRect.height / 2);

    final RRect leftTrackSegment = RRect.fromLTRBR(trackRect.left,
        trackRect.top, thumbCenter.dx, trackRect.bottom, trackRadius);
    if (!leftTrackSegment.isEmpty) {
      context.canvas.drawRRect(leftTrackSegment, leftTrackPaint);
    }
    final RRect rightTrackSegment = RRect.fromLTRBR(thumbCenter.dx,
        trackRect.top, trackRect.right, trackRect.bottom, trackRadius);
    if (!rightTrackSegment.isEmpty) {
      context.canvas.drawRRect(rightTrackSegment, rightTrackPaint);
    }
  }
}

class CustomSliderThumbShape extends SliderComponentShape {
  const CustomSliderThumbShape({
    this.outerThumbRadius = 10.0,
    this.innerThumbRadius = 10.0,
    this.outerThumbColor = Colors.white,
    this.innerThumbColor = Colors.white,
    this.elevation = 0.0,
    this.pressedElevation = 0.0,
  });
  final double outerThumbRadius;
  final double innerThumbRadius;
  final Color outerThumbColor;
  final Color innerThumbColor;
  final double elevation;
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(outerThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation =
        elevationTween.evaluate(activationAnimation);
    final Path path = Path()
      ..addArc(
          Rect.fromCenter(
              center: center,
              width: 2 * outerThumbRadius,
              height: 2 * outerThumbRadius),
          0,
          math.pi * 2);

    bool paintShadows = true;

    if (paintShadows) {
      canvas.drawShadow(path, Colors.black, evaluatedElevation, true);
    }

    canvas
      ..drawCircle(
        center,
        outerThumbRadius,
        Paint()..color = outerThumbColor,
      )
      ..drawCircle(
        center,
        innerThumbRadius,
        Paint()..color = innerThumbColor,
      );
  }
}
