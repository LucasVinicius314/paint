import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paint/clippers/base_clipper.dart';
import 'package:paint/clippers/cohen_sutherland_clipper.dart';
import 'package:paint/clippers/liang_barsky_clipper.dart';
import 'package:paint/controllers/paint_controller.dart';
import 'package:paint/drawers/line/base_line_drawer.dart';
import 'package:paint/drawers/line/bresenham_line_drawer.dart';
import 'package:paint/drawers/line/dda_line_drawer.dart';
import 'package:paint/enums/clipping_mode.dart';
import 'package:paint/enums/line_drawing_mode.dart';
import 'package:paint/enums/vector_polygon_mode.dart';
import 'package:paint/model/paint_config.dart';
import 'package:paint/model/pixel.dart';
import 'package:paint/model/vector_node.dart';
import 'package:paint/utils/utils.dart';

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

    BaseLineDrawer lineDrawer;

    switch (paintConfig.vectorLineDrawingMode) {
      case LineDrawingMode.bresenham:
        lineDrawer = BresenhamLineDrawer();
        break;
      case LineDrawingMode.dda:
        lineDrawer = DDALineDrawer();
        break;
      default:
        throw 'Invalid LineDrawingMode [${paintConfig.vectorLineDrawingMode}]';
    }

    BaseClipper clipper;

    switch (paintConfig.clippingMode) {
      case ClippingMode.cohenSutherland:
        clipper = CohenSutherlandClipper();
        break;
      case ClippingMode.liangBarsky:
        clipper = LiangBarskyClipper();
        break;
      default:
        throw 'Invalid ClippingMode [${paintConfig.clippingMode}]';
    }

    for (var vector in paintData.vectors) {
      VectorNode? lastNode;

      for (var node in [
        ...vector.nodes,
        if (vector.vectorPolygonMode == VectorPolygonMode.closed)
          vector.nodes.first,
      ]) {
        if (lastNode != null) {
          final end = (
            node.coordinates.$1.floor(),
            node.coordinates.$2.floor(),
          );

          final start = (
            lastNode.coordinates.$1.floor(),
            lastNode.coordinates.$2.floor(),
          );

          final clippedLine = paintData.clippingRect == null
              ? (start, end)
              : clipper.clip(
                  end: end,
                  max: (
                    paintData.clippingRect!.$2.$1 - 1,
                    paintData.clippingRect!.$2.$2 - 1,
                  ),
                  min: paintData.clippingRect!.$1,
                  start: start,
                );

          if (clippedLine != null) {
            for (var coordinate in lineDrawer.draw(
              end: clippedLine.$2,
              start: clippedLine.$1,
            )) {
              if (Utils.isPointInsideRect(
                end: (
                  paintConfig.canvasDimensions.$1.toDouble() - 1,
                  paintConfig.canvasDimensions.$2.toDouble() - 1,
                ),
                point: (coordinate.$1.toDouble(), coordinate.$2.toDouble()),
                start: (0, 0),
              )) {
                tempLayer[coordinate.$1][coordinate.$2] =
                    Pixel.fromColor(vector.color);
              }
            }
          }
        }

        lastNode = node;
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
