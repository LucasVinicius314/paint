import 'package:paint/drawers/circle/base_circle_drawer.dart';

class BresenhamCircleDrawer implements BaseCircleDrawer {
  @override
  List<(int, int)> draw({
    required (int, int) center,
    required int radius,
  }) {
    final out = <(int, int)>[];

    var x = 0;
    var y = radius;

    var p = 3 - 2 * radius;

    out.addAll(_plot(center: center, x: x, y: y));

    while (x < y) {
      if (p < 0) {
        p += 4 * x + 6;
      } else {
        p += 4 * (x - y) + 10;
        y--;
      }

      x++;

      out.addAll(_plot(center: center, x: x, y: y));
    }

    return out;
  }

  List<(int, int)> _plot({
    required (int, int) center,
    required int x,
    required int y,
  }) {
    return [
      (center.$1 + x, center.$2 + y),
      (center.$1 - x, center.$2 + y),
      (center.$1 + x, center.$2 - y),
      (center.$1 - x, center.$2 - y),
      (center.$1 + y, center.$2 + x),
      (center.$1 - y, center.$2 + x),
      (center.$1 + y, center.$2 - x),
      (center.$1 - y, center.$2 - x),
    ];
  }
}
