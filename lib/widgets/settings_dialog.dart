import 'package:flutter/material.dart';
import 'package:paint/enums/line_drawing_mode.dart';
import 'package:paint/model/paint_config.dart';
import 'package:paint/widgets/base_dialog.dart';
import 'package:paint/widgets/line_drawing_mode_picker.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    super.key,
    required this.paintConfig,
    required this.onVectorLineDrawingModeChanged,
  });

  final PaintConfig paintConfig;
  final void Function(LineDrawingMode lineDrawingMode)
      onVectorLineDrawingModeChanged;

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late var _vectorLineDrawingMode = widget.paintConfig.vectorLineDrawingMode;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Vector line mode',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
          LineDrawingModePicker(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            groupValue: _vectorLineDrawingMode,
            onChanged: (lineDrawingMode) {
              widget.onVectorLineDrawingModeChanged(lineDrawingMode);

              setState(() {
                _vectorLineDrawingMode = lineDrawingMode;
              });
            },
          ),
        ],
      ),
    );
  }
}
