import 'package:flutter/material.dart';
import 'package:paint/model/paint_data.dart';
import 'package:paint/model/pixel.dart';
import 'package:paint/utils/drawing.dart';

class PaintController extends ChangeNotifier {
  PaintData? paintData;

  void setPaintData(PaintData newpaintData) {
    paintData = newpaintData;

    notifyListeners();
  }

  void setLine({
    required (int, int) endCoordinates,
    required Pixel pixel,
    required (int, int) startCoordinates,
  }) {
    if (paintData == null) {
      return;
    }

    for (var coordinate
        in Drawing.dda(end: endCoordinates, start: startCoordinates)) {
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
