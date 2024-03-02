import 'package:flutter/material.dart';
import 'package:paint/controllers/paint_controller.dart';
import 'package:paint/model/vector_node.dart';
import 'package:paint/utils/constants.dart';

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
      ..strokeWidth = Constants.vectorEdgeWidth;

    for (var vector in controller.paintData!.vectors) {
      VectorNode? lastNode;

      for (var node in vector.nodes) {
        if (lastNode != null) {
          canvas.drawLine(
            Offset(
              lastNode.coordinates.$1.toDouble() * scale,
              lastNode.coordinates.$2.toDouble() * scale,
            ),
            Offset(
              node.coordinates.$1.toDouble() * scale,
              node.coordinates.$2.toDouble() * scale,
            ),
            edgePaint,
          );
        }

        lastNode = node;
      }

      for (var node in vector.nodes) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(
              node.coordinates.$1.toDouble() * scale,
              node.coordinates.$2.toDouble() * scale,
            ),
            width: Constants.vectorNodeSize,
            height: Constants.vectorNodeSize,
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
