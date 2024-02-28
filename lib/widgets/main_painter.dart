import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paint/model/pixel.dart';

class MainPainter extends CustomPainter {
  const MainPainter({
    required this.pixels,
  });

  final List<List<Pixel>> pixels;

  @override
  void paint(Canvas canvas, Size size) {
    for (final (x, column) in pixels.indexed) {
      for (final (y, pixel) in column.indexed) {
        canvas.drawPoints(
          PointMode.points,
          [Offset(x.toDouble(), y.toDouble())],
          Paint()
            ..color = Color.fromARGB(255, pixel.r, pixel.g, pixel.b)
            ..strokeWidth = 1,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
