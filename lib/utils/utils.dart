class Utils {
  static num clamp(num value, num min, num max) {
    if (value < min) {
      return min;
    }

    if (value > max) {
      return max;
    }

    return value;
  }

  static bool isPointInsideRect({
    required (double, double) end,
    required (double, double) point,
    required (double, double) start,
  }) {
    final xPos = start.$1 <= point.$1 && point.$1 <= end.$1;
    final xNeg = start.$1 >= point.$1 && point.$1 >= end.$1;

    final yPos = start.$2 <= point.$2 && point.$2 <= end.$2;
    final yNeg = start.$2 >= point.$2 && point.$2 >= end.$2;

    return (xPos || xNeg) && (yPos || yNeg);
  }
}
