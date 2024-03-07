import 'package:flutter/material.dart';
import 'package:paint/enums/clipping_mode.dart';
import 'package:paint/enums/line_drawing_mode.dart';
import 'package:paint/enums/paint_tool_mode.dart';
import 'package:paint/enums/rotation_step.dart';
import 'package:paint/enums/vector_polygon_mode.dart';

class PaintConfig {
  var canvasDimensions = (0, 0);
  var canvasScale = 1;

  var clippingMode = ClippingMode.cohenSutherland;

  var paintToolColor = Colors.black;
  var paintToolMode = PaintToolMode.pointer;

  var rasterLineDrawingMode = LineDrawingMode.bresenham;

  var rotationStep = RotationStep.n1;

  var vectorLineDrawingMode = LineDrawingMode.bresenham;
  var vectorPolygonMode = VectorPolygonMode.open;
}
