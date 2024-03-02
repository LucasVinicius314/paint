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

    return IntrinsicWidth(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconButton(
              color:
                  paintToolMode == PaintToolMode.pointer ? primaryColor : null,
              icon: Icon(MdiIcons.cursorDefault),
              onPressed: () {
                onPaintToolModeSelected(PaintToolMode.pointer);
              },
              tooltip: 'None (\')',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Raster',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            // TODO: raster selection tool (Q)
            IconButton(
              color: paintToolMode == PaintToolMode.brush ? primaryColor : null,
              icon: Icon(MdiIcons.brush),
              onPressed: () {
                onPaintToolModeSelected(PaintToolMode.brush);
              },
              tooltip: 'Brush (B)',
            ),
            const SizedBox(height: 8),
            IconButton(
              color: paintToolMode == PaintToolMode.line ? primaryColor : null,
              icon: Icon(MdiIcons.gesture),
              onPressed: () {
                onPaintToolModeSelected(PaintToolMode.line);
              },
              tooltip: 'Line (L)',
            ),
            const SizedBox(height: 8),
            IconButton(
              color:
                  paintToolMode == PaintToolMode.circle ? primaryColor : null,
              icon: Icon(MdiIcons.circleOutline),
              onPressed: () {
                onPaintToolModeSelected(PaintToolMode.circle);
              },
              tooltip: 'Circle (R)',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Vector',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            IconButton(
              color: paintToolMode == PaintToolMode.vectorSelection
                  ? primaryColor
                  : null,
              icon: Icon(MdiIcons.vectorSelection),
              onPressed: () {
                onPaintToolModeSelected(PaintToolMode.vectorSelection);
              },
              tooltip: 'Vector selection (Ctrl + Q)',
            ),
            const SizedBox(height: 8),
            IconButton(
              color: paintToolMode == PaintToolMode.vectorLine
                  ? primaryColor
                  : null,
              icon: Icon(MdiIcons.vectorLine),
              onPressed: () {
                onPaintToolModeSelected(PaintToolMode.vectorLine);
              },
              tooltip: 'Vector line (Ctrl + L)',
            ),
            const SizedBox(height: 8),
            IconButton(
              color: paintToolMode == PaintToolMode.vectorPolygon
                  ? primaryColor
                  : null,
              icon: Icon(MdiIcons.vectorPolygon),
              onPressed: () {
                onPaintToolModeSelected(PaintToolMode.vectorPolygon);
              },
              tooltip: 'Vector polygon (Ctrl + P)',
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
      ),
    );
  }
}
