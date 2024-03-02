import 'package:flutter/material.dart';
import 'package:paint/enums/vector_polygon_mode.dart';

class VectorPolygonModePicker extends StatelessWidget {
  const VectorPolygonModePicker({
    super.key,
    required this.contentPadding,
    required this.groupValue,
    required this.onChanged,
  });

  final EdgeInsets? contentPadding;
  final VectorPolygonMode groupValue;
  final void Function(VectorPolygonMode vectorPolygonMode) onChanged;

  static const modes = <(VectorPolygonMode, String)>[
    (VectorPolygonMode.closed, 'Closed'),
    (VectorPolygonMode.open, 'Open'),
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
