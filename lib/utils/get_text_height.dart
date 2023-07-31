import 'package:flutter/material.dart';

double getTextHeight(
  BuildContext context, {
  required String text,
  required TextStyle style,
  double maxWidth = double.infinity,
}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    textScaleFactor: MediaQuery.of(context).textScaleFactor,
  )..layout(maxWidth: maxWidth);
  return textPainter.size.height;
}

double singleHeight(BuildContext context, TextStyle style) {
  return style.fontSize! *
      style.height! *
      MediaQuery.of(context).textScaleFactor;
}
