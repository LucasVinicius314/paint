import 'package:flutter/material.dart';
import 'package:paint/controllers/selection_controller.dart';
import 'package:paint/enums/selection_mode.dart';

class SelectionPainter extends CustomPainter {
  const SelectionPainter({
    required this.controller,
    required this.paddingOffset,
    required this.scale,
  }) : super(repaint: controller);

  final SelectionController controller;
  final double paddingOffset;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    if (controller.selectionData == null) {
      return;
    }

    canvas.drawRect(
      Rect.fromPoints(
        Offset(
          controller.selectionData!.start.$1 * scale,
          controller.selectionData!.start.$2 * scale,
        ),
        Offset(
          controller.selectionData!.end.$1 * scale,
          controller.selectionData!.end.$2 * scale,
        ),
      ),
      Paint()
        ..color = controller.selectionData!.selectionMode ==
                SelectionMode.vectorClipping
            ? Colors.green.shade700
            : Colors.red.shade700
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
