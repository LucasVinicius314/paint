abstract class BaseClipper {
  ((int, int), (int, int))? clip({
    required (int, int) end,
    required (int, int) max,
    required (int, int) min,
    required (int, int) start,
  });
}
