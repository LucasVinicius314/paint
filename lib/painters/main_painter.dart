import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paint/controllers/paint_controller.dart';
import 'package:paint/model/pixel.dart';

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

    final paintData = controller.paintData!;

    final tempLayer = List.generate(
      paintData.pixels.length,
      (index) => List.generate(
        paintData.pixels[0].length,
        (index) => Pixel(r: 0, g: 0, b: 0),
      ),
    );

    for (final (x, column) in paintData.pixels.indexed) {
      for (final (y, pixel) in column.indexed) {
        tempLayer[x][y] = pixel;
      }
    }

    // TODO: fix, raster vectors

    for (final (x, column) in tempLayer.indexed) {
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
