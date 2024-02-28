import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paint/enums/paint_tool_mode.dart';

class PaintToolbar extends StatelessWidget {
  const PaintToolbar({
    super.key,
    required this.paintToolMode,
    required this.onPaintToolModeSelected,
    required this.onCleared,
    required this.onZoomedIn,
    required this.onZoomedOut,
  });

  final PaintToolMode paintToolMode;
  final void Function(PaintToolMode paintToolMode) onPaintToolModeSelected;
  final void Function() onCleared;
  final void Function() onZoomedIn;
  final void Function() onZoomedOut;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
            color: paintToolMode == PaintToolMode.pointer ? primaryColor : null,
            icon: Icon(MdiIcons.cursorDefault),
            onPressed: () {
              onPaintToolModeSelected(PaintToolMode.pointer);
            },
            tooltip: 'None (\')',
          ),
          const SizedBox(height: 8),
          IconButton(
            color: paintToolMode == PaintToolMode.brush ? primaryColor : null,
            icon: Icon(MdiIcons.brush),
            onPressed: () {
              onPaintToolModeSelected(PaintToolMode.brush);
            },
            tooltip: 'Brush (B)',
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          IconButton(
            icon: Icon(MdiIcons.magnifyPlus),
            onPressed: onZoomedIn,
            tooltip: 'Zoom in (Ctrl + \'+\')',
          ),
          const SizedBox(height: 8),
          IconButton(
            icon: Icon(MdiIcons.magnifyMinus),
            onPressed: onZoomedOut,
            tooltip: 'Zoom out (Ctrl + \'-\')',
          ),
          const SizedBox(height: 8),
          IconButton(
            icon: Icon(MdiIcons.close),
            onPressed: onCleared,
            tooltip: 'Clear canvas (Ctrl + Delete)',
          ),
        ],
      ),
    );
  }
}
