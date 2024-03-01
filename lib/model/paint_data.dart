import 'package:paint/model/pixel.dart';
import 'package:paint/model/vector.dart';

class PaintData {
  PaintData({
    required this.pixels,
    required this.vectors,
  });

  List<List<Pixel>> pixels;
  List<Vector> vectors;
}
