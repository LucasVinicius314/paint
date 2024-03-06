import 'package:flutter/material.dart';
import 'package:paint/enums/clipping_mode.dart';

class ClippingModePicker extends StatelessWidget {
  const ClippingModePicker({
    super.key,
    required this.contentPadding,
    required this.groupValue,
    required this.onChanged,
  });

  final EdgeInsets? contentPadding;
  final ClippingMode groupValue;
  final void Function(ClippingMode clippingMode) onChanged;

  static const modes = <(ClippingMode, String)>[
    (ClippingMode.cohenSutherland, 'Cohen Sutherland'),
    (ClippingMode.liangBarsky, 'Liang Barsky'),
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
