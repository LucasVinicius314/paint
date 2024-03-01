import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:paint/controllers/paint_controller.dart';

class VectorPainter extends CustomPainter {
  const VectorPainter({
    required this.controller,
    required this.paddingOffset,
    required this.scale,
  }) : super(repaint: controller);

  final PaintController controller;
  final double paddingOffset;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    if (controller.paintData == null) {
      return;
    }

    final edgePaint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    for (var vector in controller.paintData!.vectors) {
      canvas.drawPoints(
        PointMode.lines,
        vector.nodes.map((e) {
          return Offset(
            e.coordinates.$1.toDouble() * scale + paddingOffset,
            e.coordinates.$2.toDouble() * scale + paddingOffset,
          );
        }).toList(),
        edgePaint,
      );

      for (var node in vector.nodes) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(
              node.coordinates.$1.toDouble() * scale + paddingOffset,
              node.coordinates.$2.toDouble() * scale + paddingOffset,
            ),
            width: 6,
            height: 6,
          ),
          Paint()
            ..color = Colors.blue.shade700
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
