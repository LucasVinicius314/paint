import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paint/controllers/paint_controller.dart';

class MainPainter extends CustomPainter {
  const MainPainter({
    required this.controller,
  }) : super(repaint: controller);

  final PaintController controller;

  @override
  void paint(Canvas canvas, Size size) {
    if (controller.paintData == null) {
      return;
    }

    for (final (x, column) in controller.paintData!.pixels.indexed) {
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
