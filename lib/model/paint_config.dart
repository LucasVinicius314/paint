import 'package:paint/enums/line_drawing_mode.dart';
import 'package:paint/enums/paint_tool_mode.dart';

class PaintConfig {
  var canvasDimensions = (0, 0);
  var canvasScale = 1;

  var paintToolMode = PaintToolMode.pointer;

  // TODO: parametrize and add tool config tray
  var lineDrawingMode = LineDrawingMode.bresenham;
}
