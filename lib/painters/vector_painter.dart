import 'package:flutter/material.dart';
import 'package:paint/controllers/paint_controller.dart';
import 'package:paint/controllers/selection_controller.dart';
import 'package:paint/enums/vector_polygon_mode.dart';
import 'package:paint/model/vector_node.dart';
import 'package:paint/utils/constants.dart';
import 'package:paint/utils/utils.dart';

class VectorPainter extends CustomPainter {
  const VectorPainter({
    required this.paddingOffset,
    required this.paintController,
    required this.scale,
    required this.selectionController,
  }) : super(repaint: paintController);

  final double paddingOffset;
  final PaintController paintController;
  final double scale;
  final SelectionController selectionController;

  @override
  void paint(Canvas canvas, Size size) {
    if (paintController.paintData == null) {
      return;
    }

    final edgePaint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = Constants.vectorEdgeWidth;

    for (var vector in paintController.paintData!.vectors) {
      VectorNode? lastNode;

      for (var node in [
        ...vector.nodes,
        if (vector.vectorPolygonMode == VectorPolygonMode.closed)
          vector.nodes.first,
      ]) {
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
        final x = node.coordinates.$1.toDouble();
        final y = node.coordinates.$2.toDouble();

        final color = selectionController.selectionData != null &&
                    Utils.isPointInsideRect(
                      end: selectionController.selectionData!.end,
                      point: (x, y),
                      start: selectionController.selectionData!.start,
                    ) ||
                selectionController.selectedNodes.contains(node)
            ? Colors.red.shade700
            : Colors.blue.shade700;

        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(x, y) * scale,
            width: Constants.vectorNodeSize,
            height: Constants.vectorNodeSize,
          ),
          Paint()
            ..color = color
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 2,
        );
      }
    }

    final clippingRect = paintController.paintData!.clippingRect;

    if (clippingRect != null) {
      canvas.drawRect(
        Rect.fromPoints(
          Offset(clippingRect.$1.$1.toDouble(), clippingRect.$1.$2.toDouble()) *
              scale,
          Offset(clippingRect.$2.$1.toDouble(), clippingRect.$2.$2.toDouble()) *
              scale,
        ),
        Paint()
          ..color = Colors.green
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
