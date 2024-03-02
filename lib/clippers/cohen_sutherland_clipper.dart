import 'package:paint/clippers/base_clipper.dart';

class CohenSutherlandClipper implements BaseClipper {
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

    var ok = false;

    while (true) {
      final c1 = _regionCode(x: x1, y: y1, max: max, min: min);
      final c2 = _regionCode(x: x2, y: y2, max: max, min: min);

      if (c1 == 0 && c2 == 0) {
        ok = true;
        break;
      } else if ((c1 & c2) != 0) {
        break;
      } else {
        final cOut = c1 != 0 ? c1 : c2;

        var out = (0.0, 0.0);

        if (_isBitSet(cOut, 0x1)) {
          out = (
            min.$1.toDouble(),
            y1 + (y2 - y1) * (min.$1 - x1) / (x2 - x1),
          );
        } else if (_isBitSet(cOut, 0x2)) {
          out = (
            max.$1.toDouble(),
            y1 + (y2 - y1) * (max.$1 - x1) / (x2 - x1),
          );
        } else if (_isBitSet(cOut, 0x4)) {
          out = (
            x1 + (x2 - x1) * (min.$2 - y1) / (y2 - y1),
            min.$2.toDouble(),
          );
        } else if (_isBitSet(cOut, 0x8)) {
          out = (
            x1 + (x2 - x1) * (max.$2 - y1) / (y2 - y1),
            max.$2.toDouble(),
          );
        }

        if (c1 == cOut) {
          x1 = out.$1;
          y1 = out.$2;
        } else {
          x2 = out.$1;
          y2 = out.$2;
        }
      }
    }

    return ok ? ((x1.round(), y1.round()), (x2.round(), y2.round())) : null;
  }

  bool _isBitSet(int number, int mask) => (number & mask) != 0;

  int _regionCode({
    required (int, int) max,
    required (int, int) min,
    required double x,
    required double y,
  }) {
    var out = 0;

    if (x < min.$1) {
      out++;
    }

    if (x > max.$1) {
      out += 2;
    }

    if (y < min.$2) {
      out += 4;
    }

    if (y > max.$2) {
      out += 8;
    }

    return out;
  }
}
