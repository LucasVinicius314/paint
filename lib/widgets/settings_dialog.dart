import 'package:flutter/material.dart';
import 'package:paint/enums/clipping_mode.dart';
import 'package:paint/enums/line_drawing_mode.dart';
import 'package:paint/model/paint_config.dart';
import 'package:paint/widgets/base_dialog.dart';
import 'package:paint/widgets/clipping_mode_picker.dart';
import 'package:paint/widgets/line_drawing_mode_picker.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    super.key,
    required this.paintConfig,
    required this.onClippingModeChanged,
    required this.onVectorLineDrawingModeChanged,
  });

  final PaintConfig paintConfig;
  final void Function(ClippingMode clippingMode) onClippingModeChanged;
  final void Function(LineDrawingMode lineDrawingMode)
      onVectorLineDrawingModeChanged;

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late var _clippingMode = widget.paintConfig.clippingMode;
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
              'Clipping mode',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
          ClippingModePicker(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            groupValue: _clippingMode,
            onChanged: (clippingMode) {
              widget.onClippingModeChanged(clippingMode);

              setState(() {
                _clippingMode = clippingMode;
              });
            },
          ),
          const SizedBox(height: 8),
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
