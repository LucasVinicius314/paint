import 'package:paint/enums/selection_mode.dart';

class SelectionData {
  SelectionData({
    required this.end,
    required this.selectionMode,
    required this.start,
  });

  (double, double) end;
  SelectionMode selectionMode;
  (double, double) start;
}
