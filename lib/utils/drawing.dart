import 'dart:math';

class Drawing {
  static List<(int, int)> dda({
    required (int, int) end,
    required (int, int) start,
  }) {
    final out = <(int, int)>[];

    final dx = end.$1 - start.$1;
    final dy = end.$2 - start.$2;

    final steps = max(dx.abs(), dy.abs());

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
