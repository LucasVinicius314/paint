import 'package:flutter/material.dart';
import 'package:paint/drawers/line/base_line_drawer.dart';
import 'package:paint/drawers/line/bresenham_line_drawer.dart';
import 'package:paint/drawers/line/dda_line_drawer.dart';
import 'package:paint/enums/line_drawing_mode.dart';
import 'package:paint/model/paint_data.dart';
import 'package:paint/model/pixel.dart';
import 'package:paint/model/vector.dart';

class PaintController extends ChangeNotifier {
  PaintData? paintData;

  void setPaintData(PaintData newpaintData) {
    paintData = newpaintData;

    notifyListeners();
  }

  void addVector({
    required Vector vector,
  }) {
    if (paintData == null) {
      return;
    }

    paintData!.vectors.add(vector);

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
      paintData!.pixels[coordinate.$1][coordinate.$2] = pixel;
    }

    notifyListeners();
  }

  void setPixel({
    required (int, int) coordinates,
    required Pixel pixel,
  }) {
    if (paintData == null) {
      return;
    }

    paintData!.pixels[coordinates.$1][coordinates.$2] = pixel;

    notifyListeners();
  }
}
