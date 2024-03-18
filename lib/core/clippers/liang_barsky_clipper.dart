import 'package:paint/core/clippers/base_clipper.dart';

class LiangBarskyClipper implements BaseClipper {
  @override
  ((int, int), (int, int))? clip({
    required (int, int) end,
    required (int, int) max,
    required (int, int) min,
    required (int, int) start,
  }) {
    var x1 = start.$1.toDouble();
    var y1 = start.$2.toDouble();

    var x2 = end.$1.toDouble();
    var y2 = end.$2.toDouble();

    var u1 = 0.0;
    var u2 = 1.0;

    final dx = x2 - x1;
    final dy = y2 - y1;

    /// Calculates intersections by adjusting u1 and u2 from the inside of the
    /// clipping area, returning true if the intersection exists.
    bool clipTest({
      required double p,
      required double q,
    }) {
      if (p < 0) {
        final r = q / p;

        if (r > u2) {
          return false;
        } else if (r > u1) {
          u1 = r;
        }
      } else if (p > 0) {
        final r = q / p;

        if (r < u1) {
          return false;
        } else if (r < u2) {
          u2 = r;
        }
      } else if (q < 0) {
        return false;
      }

      return true;
    }

    // Checks if the line intersects the area by looking at individual
    // intersections using the rect's limits.
    final tests = [
      () => clipTest(p: -dx, q: x1 - min.$1),
      () => clipTest(p: dx, q: max.$1 - x1),
      () => clipTest(p: -dy, q: y1 - min.$2),
      () => clipTest(p: dy, q: max.$2 - y1),
    ];

    if (tests.every((element) => element())) {
      if (u2 < 1) {
        x2 = x1 + (u2 * dx);
        y2 = y1 + (u2 * dy);
      }

      if (u1 > 0) {
        x1 += (u1 * dx);
        y1 += (u1 * dy);
      }

      return ((x1.round(), y1.round()), (x2.round(), y2.round()));
    }

    return null;
  }
}
