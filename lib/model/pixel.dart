import 'package:flutter/material.dart';

class Pixel {
  Pixel({
    required this.r,
    required this.g,
    required this.b,
  });

  int r;
  int g;
  int b;

  factory Pixel.fromColor(Color color) {
    return Pixel(r: color.red, g: color.green, b: color.blue);
  }
}
