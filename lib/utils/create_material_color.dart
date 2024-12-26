import 'package:flutter/material.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final double r = color.r, g = color.g, b = color.b;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.from(
      red: r + ((ds < 0 ? r : (255 - r)) * ds),
      green: g + ((ds < 0 ? g : (255 - g)) * ds),
      blue: b + ((ds < 0 ? b : (255 - b)) * ds),
      alpha: 1,
    );
  });
  return MaterialColor(color.toHexValue, swatch);
}

extension ColorExtension on Color {
  int get toHexValue {
    final red = (r * 255).toInt().toRadixString(16).padLeft(2, '0');
    final green = (g * 255).toInt().toRadixString(16).padLeft(2, '0');
    final blue = (b * 255).toInt().toRadixString(16).padLeft(2, '0');
    final alpha = (a * 255).toInt().toRadixString(16).padLeft(2, '0');

    return int.parse('$alpha$red$green$blue', radix: 16);
  }
}
