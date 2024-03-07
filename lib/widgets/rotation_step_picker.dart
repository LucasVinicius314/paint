import 'package:flutter/material.dart';
import 'package:paint/enums/rotation_step.dart';

class RotationStepPicker extends StatelessWidget {
  const RotationStepPicker({
    super.key,
    required this.contentPadding,
    required this.groupValue,
    required this.onChanged,
  });

  final EdgeInsets? contentPadding;
  final RotationStep groupValue;
  final void Function(RotationStep rotationStep) onChanged;

  static const modes = <(RotationStep, String)>[
    (RotationStep.n1, '1°'),
    (RotationStep.n10, '10°'),
    (RotationStep.n15, '15°'),
    (RotationStep.n30, '30°'),
    (RotationStep.n60, '60°'),
    (RotationStep.n90, '90°'),
    (RotationStep.n180, '180°'),
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
