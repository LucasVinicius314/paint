import 'package:flutter/material.dart';
import 'package:paint/enums/line_drawing_mode.dart';

class LineDrawingModePicker extends StatelessWidget {
  const LineDrawingModePicker({
    super.key,
    required this.contentPadding,
    required this.groupValue,
    required this.onChanged,
  });

  final EdgeInsets? contentPadding;
  final LineDrawingMode groupValue;
  final void Function(LineDrawingMode lineDrawingMode) onChanged;

  static const modes = <(LineDrawingMode, String)>[
    (LineDrawingMode.bresenham, 'Bresenham'),
    (LineDrawingMode.dda, 'DDA'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: modes.map((e) {
        return RadioListTile(
          contentPadding: contentPadding,
          dense: true,
          groupValue: groupValue,
          splashRadius: 8,
          title: Text(e.$2),
          value: e.$1,
          onChanged: (_) {
            onChanged(e.$1);
          },
        );
      }).toList(),
    );
  }
}
