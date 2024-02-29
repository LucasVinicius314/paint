import 'package:paint/drawers/line/base_line_drawer.dart';

class BresenhamLineDrawer implements BaseLineDrawer {
  @override
  List<(int, int)> draw({
    required (int, int) end,
    required (int, int) start,
  }) {
    final out = <(int, int)>[];

    var dx = (end.$1 - start.$1).abs();
    var dy = (end.$2 - start.$2).abs();

    var xStep = 0;
    var yStep = 0;

    if (dx >= 0) {
      xStep = 1;
    } else {
      xStep = -1;
      dx *= -1;
    }

    if (dy >= 0) {
      yStep = 1;
    } else {
      xStep = -1;
      dy *= -1;
    }

    var x = start.$1;
    var y = start.$2;

    out.add((x, y));

    if (dy < dx) {
      var p = 2 * dy - dx;

      final a = 2 * dy;
      final b = 2 * (dy - dx);

      for (var i = 0; i < dx; i++) {
        x += xStep;

        if (p < 0) {
          p += a;
        } else {
          p += b;
          y += yStep;
        }

        out.add((x, y));
      }
    } else {
      var p = 2 * dx - dy;

      final a = 2 * dx;
      final b = 2 * (dx - dy);

      for (var i = 0; i < dy; i++) {
        y += yStep;

        if (p < 0) {
          p += a;
        } else {
          p += b;
          x += xStep;
        }

        out.add((x, y));
      }
    }

    return out;
  }
}
