import 'package:flutter/material.dart';
import 'package:paint/enums/line_drawing_mode.dart';
import 'package:paint/enums/paint_tool_mode.dart';

class PaintConfig {
  var canvasDimensions = (0, 0);
  var canvasScale = 1;

  var paintToolColor = Colors.black;
  var paintToolMode = PaintToolMode.pointer;

  var lineDrawingMode = LineDrawingMode.bresenham;
}
