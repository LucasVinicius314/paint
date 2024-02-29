import 'package:paint/drawers/line/base_line_drawer.dart';

class BresenhamLineDrawer implements BaseLineDrawer {
  @override
  List<(int, int)> draw({
    required (int, int) end,
    required (int, int) start,
  }) {
    final out = <(int, int)>[];

    var x0 = start.$1;
    var y0 = start.$2;

    var x1 = end.$1;
    var y1 = end.$2;

    final steep = (y1 - y0).abs() > (x1 - x0).abs();

    if (steep) {
      var temp = x0;
      x0 = y0;
      y0 = temp;

      temp = x1;
      x1 = y1;
      y1 = temp;
    }

    if (x0 > x1) {
      var temp = x0;
      x0 = x1;
      x1 = temp;

      temp = y0;
      y0 = y1;
      y1 = temp;
    }

    final dx = x1 - x0;
    final dy = (y1 - y0).abs();

    final ystep = (y0 < y1) ? 1 : -1;

    var error = dx ~/ 2;

    for (var x = x0, y = y0; x <= x1; x++) {
      if (steep) {
        out.add((y, x));
      } else {
        out.add((x, y));
      }

      error -= dy;

      if (error < 0) {
        y += ystep;
        error += dx;
      }
    }

    return out;
  }
}
