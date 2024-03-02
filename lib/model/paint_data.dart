import 'package:paint/model/pixel.dart';
import 'package:paint/model/vector.dart';

class PaintData {
  PaintData({
    required this.clippingRect,
    required this.pixels,
    required this.vectors,
  });

  ((int, int), (int, int))? clippingRect;
  List<List<Pixel>> pixels;
  List<Vector> vectors;
}
