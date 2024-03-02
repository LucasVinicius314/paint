import 'package:flutter/material.dart';

import 'package:paint/drawers/circle/bresenham_circle_drawer.dart';
import 'package:paint/drawers/line/base_line_drawer.dart';
import 'package:paint/drawers/line/bresenham_line_drawer.dart';
import 'package:paint/drawers/line/dda_line_drawer.dart';
import 'package:paint/enums/line_drawing_mode.dart';
import 'package:paint/model/paint_config.dart';
import 'package:paint/model/paint_data.dart';
import 'package:paint/model/pixel.dart';
import 'package:paint/model/vector.dart';
import 'package:paint/utils/utils.dart';

class PaintController extends ChangeNotifier {
  PaintController({
    required this.paintConfig,
  });

  PaintConfig paintConfig;
  PaintData? paintData;

  void addVector({
    required Vector vector,
  }) {
    if (paintData == null) {
      return;
    }

    paintData!.vectors.add(vector);

    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  void setCircle({
    required (int, int) centerCoordinates,
    required Pixel pixel,
    required int radius,
  }) {
    if (paintData == null) {
      return;
    }

    final circleDrawer = BresenhamCircleDrawer();

    for (var coordinate in circleDrawer.draw(
      center: centerCoordinates,
      radius: radius,
    )) {
      _alterPixel(coordinates: coordinate, pixel: pixel);
    }

    notifyListeners();
  }

  void setLine({
    required (int, int) endCoordinates,
    required LineDrawingMode lineDrawingMode,
    required Pixel pixel,
    required (int, int) startCoordinates,
  }) {
    if (paintData == null) {
      return;
    }

    BaseLineDrawer lineDrawer;

    switch (lineDrawingMode) {
      case LineDrawingMode.bresenham:
        lineDrawer = BresenhamLineDrawer();
        break;
      case LineDrawingMode.dda:
        lineDrawer = DDALineDrawer();
        break;
      default:
        throw 'Invalid LineDrawingMode [$lineDrawingMode]';
    }

    for (var coordinate in lineDrawer.draw(
      end: endCoordinates,
      start: startCoordinates,
    )) {
      _alterPixel(coordinates: coordinate, pixel: pixel);
    }

    notifyListeners();
  }

  void setPaintData(PaintData newpPaintData) {
    paintData = newpPaintData;

    notifyListeners();
  }

  void setPixel({
    required (int, int) coordinates,
    required Pixel pixel,
  }) {
    if (paintData == null) {
      return;
    }

    _alterPixel(coordinates: coordinates, pixel: pixel);

    notifyListeners();
  }

  void _alterPixel({
    required (int, int) coordinates,
    required Pixel pixel,
  }) {
    if (paintData == null) {
      return;
    }

    if (Utils.isPointInsideRect(
      end: (
        paintConfig.canvasDimensions.$1.toDouble() - 1,
        paintConfig.canvasDimensions.$2.toDouble() - 1,
      ),
      point: (coordinates.$1.toDouble(), coordinates.$2.toDouble()),
      start: (0, 0),
    )) {
      paintData!.pixels[coordinates.$1][coordinates.$2] = pixel;
    }
  }
}
