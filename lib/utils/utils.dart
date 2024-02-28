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
}
