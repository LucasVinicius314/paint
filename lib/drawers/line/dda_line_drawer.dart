import 'dart:math' as math;

import 'package:paint/drawers/line/base_line_drawer.dart';

class DDALineDrawer implements BaseLineDrawer {
  @override
  List<(int, int)> draw({
    required (int, int) end,
    required (int, int) start,
  }) {
    final out = <(int, int)>[];

    final dx = end.$1 - start.$1;
    final dy = end.$2 - start.$2;

    final steps = math.max(dx.abs(), dy.abs());

    final xStep = dx / steps;
    final yStep = dy / steps;

    var x = start.$1.toDouble();
    var y = start.$2.toDouble();

    out.add((x.round(), y.round()));

    for (var i = 0; i < steps; i++) {
      x += xStep;
      y += yStep;

      out.add((x.round(), y.round()));
    }

    return out;
  }
}
