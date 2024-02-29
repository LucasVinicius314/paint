import 'package:flutter/material.dart';
import 'package:paint/model/paint_data.dart';
import 'package:paint/model/pixel.dart';

class PaintController extends ChangeNotifier {
  PaintData? paintData;

  void setPaintData(PaintData newpaintData) {
    paintData = newpaintData;

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
