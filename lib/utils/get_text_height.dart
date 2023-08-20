import 'package:flutter/material.dart';

Size getTextSize(
  BuildContext context, {
  required String text,
  required TextStyle style,
  double maxWidth = double.infinity,
}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    textScaleFactor: MediaQuery.of(context).textScaleFactor,
  )..layout(minWidth: 0, maxWidth: maxWidth);
  return textPainter.size;
}

double singleHeight(BuildContext context, TextStyle style) {
  return style.fontSize! *
      style.height! *
      MediaQuery.of(context).textScaleFactor;
}
