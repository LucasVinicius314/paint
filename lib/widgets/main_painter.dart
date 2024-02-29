import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paint/model/paint_data.dart';

class MainPainter extends CustomPainter {
  const MainPainter({
    required this.paintData,
  });

  final PaintData paintData;

  @override
  void paint(Canvas canvas, Size size) {
    for (final (x, column) in paintData.pixels.indexed) {
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
