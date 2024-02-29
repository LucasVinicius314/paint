import 'package:flutter/material.dart';
import 'package:paint/controllers/paint_controller.dart';
import 'package:paint/widgets/main_painter.dart';

class PaintView extends StatelessWidget {
  const PaintView({
    super.key,
    required this.controller,
  });

  final PaintController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        if (controller.paintData == null) {
          return Container();
        }

        return CustomPaint(
          painter: MainPainter(paintData: controller.paintData!),
        );
      },
    );
  }
}
