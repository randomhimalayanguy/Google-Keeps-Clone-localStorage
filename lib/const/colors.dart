import 'package:flutter/material.dart';

Color getColor(int index) {
  return Colors.primaries[index % Colors.primaries.length].shade100;
}

List<Color> getColorList() {
  final List<Color> colors = [
    for (int i = 0; i < 8; i++) Colors.primaries[i].shade100,
  ];

  return colors;
}
