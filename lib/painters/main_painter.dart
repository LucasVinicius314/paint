import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paint/controllers/paint_controller.dart';
import 'package:paint/drawers/line/base_line_drawer.dart';
import 'package:paint/drawers/line/bresenham_line_drawer.dart';
import 'package:paint/drawers/line/dda_line_drawer.dart';
import 'package:paint/enums/line_drawing_mode.dart';
import 'package:paint/model/paint_config.dart';
import 'package:paint/model/pixel.dart';
import 'package:paint/model/vector_node.dart';

class MainPainter extends CustomPainter {
  const MainPainter({
    required this.controller,
    required this.paintConfig,
  }) : super(repaint: controller);

  final PaintController controller;
  final PaintConfig paintConfig;

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

    // TODO: add ctrl + z
    // TODO: add panning

    BaseLineDrawer lineDrawer;

    switch (paintConfig.vectorLineDrawingMode) {
      case LineDrawingMode.bresenham:
        lineDrawer = BresenhamLineDrawer();
        break;
      case LineDrawingMode.dda:
        lineDrawer = DDALineDrawer();
        break;
      default:
        throw 'Invalid LineDrawingMode [$paintConfig.vectorLineDrawingMode]';
    }

    for (var vector in paintData.vectors) {
      VectorNode? lastNode;

      for (var node in vector.nodes) {
        if (lastNode == null) {
          lastNode = node;
          continue;
        }

        for (var coordinate in lineDrawer.draw(
          end: (node.coordinates.$1.floor(), node.coordinates.$2.floor()),
          start: (
            lastNode.coordinates.$1.floor(),
            lastNode.coordinates.$2.floor(),
          ),
        )) {
          tempLayer[coordinate.$1][coordinate.$2] =
              Pixel.fromColor(vector.color);
        }
      }
    }

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
