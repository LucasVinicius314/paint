import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:paint/controllers/paint_controller.dart';
import 'package:paint/controllers/selection_controller.dart';
import 'package:paint/enums/paint_tool_mode.dart';
import 'package:paint/enums/rotation_step.dart';
import 'package:paint/enums/selection_mode.dart';
import 'package:paint/enums/stroke_mode.dart';
import 'package:paint/model/paint_config.dart';
import 'package:paint/model/paint_data.dart';
import 'package:paint/model/pixel.dart';
import 'package:paint/model/selection_data.dart';
import 'package:paint/model/vector.dart';
import 'package:paint/model/vector_node.dart';
import 'package:paint/painters/main_painter.dart';
import 'package:paint/painters/selection_painter.dart';
import 'package:paint/painters/vector_painter.dart';
import 'package:paint/utils/constants.dart';
import 'package:paint/utils/utils.dart';
import 'package:paint/widgets/color_picker.dart';
import 'package:paint/widgets/line_drawing_mode_picker.dart';
import 'package:paint/widgets/paint_info_toolbar.dart';
import 'package:paint/widgets/paint_toolbar.dart';
import 'package:paint/widgets/rotation_step_picker.dart';
import 'package:paint/widgets/settings_dialog.dart';
import 'package:paint/widgets/vector_polygon_mode_picker.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const route = '/';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _paintConfig = PaintConfig();

  late final _paintController = PaintController(paintConfig: _paintConfig);
  final _selectionController = SelectionController();

  (double, double)? _strokeStartCoordinates;
  (double, double)? _lastStrokeCoordinates;

  Vector? _currentVector;

  void _addVector({
    required Vector vector,
  }) {
    _paintController.addVector(vector: vector);
  }

  void _drawCircle({
    required (int, int) centerCoordinates,
    required Color color,
    required int radius,
  }) {
    _paintController.setCircle(
      centerCoordinates: centerCoordinates,
      pixel: Pixel.fromColor(color),
      radius: radius,
    );
  }

  void _drawLine({
    required Color color,
    required (int, int) endCoordinates,
    required (int, int) startCoordinates,
  }) {
    _paintController.setLine(
      endCoordinates: endCoordinates,
      lineDrawingMode: _paintConfig.rasterLineDrawingMode,
      pixel: Pixel.fromColor(color),
      startCoordinates: startCoordinates,
    );
  }

  void _drawPixel({
    required Color color,
    required (int, int) coordinates,
  }) {
    _paintController.setPixel(
      coordinates: coordinates,
      pixel: Pixel.fromColor(color),
    );
  }

  void _flipHorizontally({
    required List<VectorNode> selectedNodes,
  }) {
    final xCoords = selectedNodes.map((e) => e.coordinates.$1).toList();

    final minX = Utils.min(xCoords);
    final maxX = Utils.max(xCoords);

    for (var node in selectedNodes) {
      node.coordinates = (
        maxX - (node.coordinates.$1 - minX),
        node.coordinates.$2,
      );

      _paintController.notify();
    }
  }

  void _flipVertically({
    required List<VectorNode> selectedNodes,
  }) {
    final yCoords = selectedNodes.map((e) => e.coordinates.$2).toList();

    final minY = Utils.min(yCoords);
    final maxY = Utils.max(yCoords);

    for (var node in selectedNodes) {
      node.coordinates = (
        node.coordinates.$1,
        maxY - (node.coordinates.$2 - minY),
      );

      _paintController.notify();
    }
  }

  Widget _getBrushToolToolbar() {
    return _getColorPicker();
  }

  Widget _getCircleToolToolbar() {
    return _getColorPicker();
  }

  Widget _getColorPicker() {
    return ColorPicker(
      onColorPicked: (color) {
        setState(() {
          _paintConfig.paintToolColor = color;
        });
      },
      paintConfig: _paintConfig,
      width: Constants.colorPickerSwatchSpacing * 4 +
          Constants.colorPickerSwatchSize * 5,
    );
  }

  Widget _getLeftPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanUpdate: (details) {
              _handleTapEvent(
                dx: details.localPosition.dx,
                dy: details.localPosition.dy,
                strokeMode: StrokeMode.update,
              );
            },
            onTapDown: (details) {
              _handleTapEvent(
                dx: details.localPosition.dx,
                dy: details.localPosition.dy,
                strokeMode: StrokeMode.start,
              );
            },
            onTapUp: (details) {
              _handleTapEvent(
                dx: details.localPosition.dx,
                dy: details.localPosition.dx,
                strokeMode: StrokeMode.click,
              );
            },
            onPanEnd: (details) {
              if (_lastStrokeCoordinates == null) {
                return;
              }

              _handleTapEvent(
                dx: _lastStrokeCoordinates!.$1.toDouble(),
                dy: _lastStrokeCoordinates!.$2.toDouble(),
                strokeMode: StrokeMode.end,
              );
            },
            onPanStart: (details) {
              _handleTapEvent(
                dx: details.localPosition.dx,
                dy: details.localPosition.dy,
                strokeMode: StrokeMode.start,
              );
            },
            child: MouseRegion(
              opaque: false,
              cursor: {
                    PaintToolMode.brush: SystemMouseCursors.precise,
                    PaintToolMode.line: SystemMouseCursors.precise,
                  }[_paintConfig.paintToolMode] ??
                  MouseCursor.defer,
              child: Padding(
                padding: const EdgeInsets.all(Constants.canvasPadding),
                child: Stack(
                  children: [
                    Transform.scale(
                      alignment: Alignment.topLeft,
                      origin: const Offset(-.5, -.5),
                      scale: _paintConfig.canvasScale.toDouble(),
                      transformHitTests: false,
                      child: SizedBox(
                        height: _paintConfig.canvasDimensions.$2.toDouble(),
                        width: _paintConfig.canvasDimensions.$1.toDouble(),
                        child: CustomPaint(
                          painter: MainPainter(
                            controller: _paintController,
                            paintConfig: _paintConfig,
                          ),
                        ),
                      ),
                    ),
                    CustomPaint(
                      painter: VectorPainter(
                        selectionController: _selectionController,
                        paintController: _paintController,
                        paddingOffset: Constants.canvasPadding,
                        scale: _paintConfig.canvasScale.toDouble(),
                      ),
                    ),
                    CustomPaint(
                      painter: SelectionPainter(
                        controller: _selectionController,
                        paddingOffset: Constants.canvasPadding,
                        scale: _paintConfig.canvasScale.toDouble(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        PaintInfoToolbar(
          paintConfig: _paintConfig,
          selectionController: _selectionController,
        ),
      ],
    );
  }

  Widget _getLineToolToolbar() {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Line mode',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          LineDrawingModePicker(
            contentPadding: const EdgeInsets.only(right: 8),
            groupValue: _paintConfig.rasterLineDrawingMode,
            onChanged: (lineDrawingMode) {
              setState(() {
                _paintConfig.rasterLineDrawingMode = lineDrawingMode;
              });
            },
          ),
          const Divider(height: 1),
          _getColorPicker(),
        ],
      ),
    );
  }

  Widget _getRightPanel() {
    return ListenableBuilder(
      listenable: _selectionController,
      builder: (context, child) {
        Widget? toolToolbar;

        switch (_paintConfig.paintToolMode) {
          case PaintToolMode.brush:
            toolToolbar = _getBrushToolToolbar();
            break;
          case PaintToolMode.line:
            toolToolbar = _getLineToolToolbar();
            break;
          case PaintToolMode.circle:
            toolToolbar = _getCircleToolToolbar();
            break;
          case PaintToolMode.vectorSelection:
            if (_selectionController.selectedNodes.isNotEmpty) {
              toolToolbar = _getVectorSelectionToolToolbar(
                selectedNodes: _selectionController.selectedNodes,
              );
            }

            break;
          case PaintToolMode.vectorLine:
            toolToolbar = _getVectorLineToolToolbar();
            break;
          case PaintToolMode.vectorPolygon:
            toolToolbar = _getVectorPolygonToolToolbar();
            break;
          default:
        }

        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 100),
                child: Container(
                  child: toolToolbar == null
                      ? null
                      : IntrinsicWidth(child: toolToolbar),
                ),
              ),
              if (toolToolbar != null) const VerticalDivider(width: 1),
              IntrinsicWidth(
                child: PaintToolbar(
                  onCleared: () {
                    _setCanvas(dimensions: 100);

                    _resetCurrentVector();
                  },
                  onPaintToolModeSelected: (paintToolMode) {
                    _setPaintToolMode(paintToolMode);
                  },
                  onZoomedIn: () {
                    _incrementScale(1);
                  },
                  onZoomedOut: () {
                    _incrementScale(-1);
                  },
                  paintToolMode: _paintConfig.paintToolMode,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getVectorLineToolToolbar() {
    return _getColorPicker();
  }

  Widget _getVectorPolygonToolToolbar() {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Polygon mode',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          VectorPolygonModePicker(
            contentPadding: const EdgeInsets.only(right: 8),
            groupValue: _paintConfig.vectorPolygonMode,
            onChanged: (vectorPolygonMode) {
              setState(() {
                _paintConfig.vectorPolygonMode = vectorPolygonMode;
              });
            },
          ),
          const Divider(height: 1),
          _getColorPicker(),
        ],
      ),
    );
  }

  Widget _getVectorSelectionToolToolbar({
    required List<VectorNode> selectedNodes,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Action',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        IconButton(
          icon: Icon(MdiIcons.flipHorizontal),
          onPressed: selectedNodes.length <= 1
              ? null
              : () {
                  _flipHorizontally(selectedNodes: selectedNodes);
                },
          tooltip: 'Flip horizontally',
        ),
        const SizedBox(height: 8),
        IconButton(
          icon: Icon(MdiIcons.flipVertical),
          onPressed: selectedNodes.length <= 1
              ? null
              : () {
                  _flipVertically(selectedNodes: selectedNodes);
                },
          tooltip: 'Flip vertically',
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Rotation step',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        RotationStepPicker(
          contentPadding: const EdgeInsets.only(right: 8),
          groupValue: _paintConfig.rotationStep,
          onChanged: (rotationStep) {
            setState(() {
              _paintConfig.rotationStep = rotationStep;
            });
          },
        ),
      ],
    );
  }

  void _handleTapEvent({
    required double dx,
    required double dy,
    required StrokeMode strokeMode,
  }) {
    // Define x and y as the scaled and offset coordinate that received the mouse event.
    final x = ((dx - Constants.canvasPadding) / _paintConfig.canvasScale);
    final y = ((dy - Constants.canvasPadding) / _paintConfig.canvasScale);

    switch (_paintConfig.paintToolMode) {
      case PaintToolMode.brush:
        if ([StrokeMode.start, StrokeMode.update].contains(strokeMode)) {
          _drawPixel(
            coordinates: (x.floor(), y.floor()),
            color: _paintConfig.paintToolColor,
          );
        }

        break;
      case PaintToolMode.circle:
        switch (strokeMode) {
          case StrokeMode.end:
            if (_strokeStartCoordinates == null) {
              return;
            }

            // Define the circle's center as the scaled position of the first click.
            final center = (
              ((_strokeStartCoordinates!.$1.floor() - Constants.canvasPadding) /
                      _paintConfig.canvasScale)
                  .floor(),
              ((_strokeStartCoordinates!.$2.floor() - Constants.canvasPadding) /
                      _paintConfig.canvasScale)
                  .floor(),
            );

            _drawCircle(
              color: _paintConfig.paintToolColor,
              centerCoordinates: center,
              radius: math
                  .sqrt(math.pow(center.$1 - x, 2) + math.pow(center.$2 - y, 2))
                  .abs()
                  .floor(),
            );

            _strokeStartCoordinates = null;

            break;
          case StrokeMode.start:
            _strokeStartCoordinates = (dx, dy);
            break;
          case StrokeMode.update:
            _lastStrokeCoordinates = (dx, dy);
            break;
          default:
        }

        break;
      case PaintToolMode.line:
        switch (strokeMode) {
          case StrokeMode.end:
            if (_strokeStartCoordinates == null) {
              return;
            }

            // Define the line's starting point coordinates as the scaled first click coordinates.
            final start = (
              ((_strokeStartCoordinates!.$1.floor() - Constants.canvasPadding) /
                      _paintConfig.canvasScale)
                  .floor(),
              ((_strokeStartCoordinates!.$2.floor() - Constants.canvasPadding) /
                      _paintConfig.canvasScale)
                  .floor(),
            );

            _drawLine(
              color: _paintConfig.paintToolColor,
              endCoordinates: (x.floor(), y.floor()),
              startCoordinates: start,
            );

            _strokeStartCoordinates = null;

            break;
          case StrokeMode.start:
            _strokeStartCoordinates = (dx, dy);
            break;
          case StrokeMode.update:
            _lastStrokeCoordinates = (dx, dy);
            break;
          default:
        }

        break;
      case PaintToolMode.vectorClip:
        switch (strokeMode) {
          case StrokeMode.click:
            if (_paintController.paintData == null) {
              return;
            }

            _paintController.paintData!.clippingRect = null;

            break;
          case StrokeMode.end:
            if (_selectionController.selectionData == null ||
                _selectionController.selectionData!.start ==
                    _selectionController.selectionData!.end) {
              return;
            }

            final start = _selectionController.selectionData!.start;
            final end = (x.floor() + .5, y.floor() + .5);

            // Define the clipping area limits as the bounding box's limits.
            final min = (
              (math.min(start.$1, end.$1) - .5).round(),
              (math.min(start.$2, end.$2) - .5).round(),
            );

            final max = (
              (math.max(start.$1, end.$1) + .5).round(),
              (math.max(start.$2, end.$2) + .5).round(),
            );

            _paintController.paintData!.clippingRect = (min, max);

            _selectionController.setSelectionData(null);

            break;
          case StrokeMode.start:
            final coordinates = (x.floor() + .5, y.floor() + .5);

            _selectionController.setSelectionData(
              SelectionData(
                end: coordinates,
                selectionMode: SelectionMode.vectorClipping,
                start: coordinates,
              ),
            );

            _lastStrokeCoordinates = (dx, dy);

            break;
          case StrokeMode.update:
            if (_lastStrokeCoordinates == null) {
              return;
            }

            if (_selectionController.selectionData != null) {
              _selectionController.setSelectionData(
                SelectionData(
                  end: (x.floor() + .5, y.floor() + .5),
                  selectionMode: SelectionMode.vectorClipping,
                  start: _selectionController.selectionData!.start,
                ),
              );
            }

            _lastStrokeCoordinates = (dx, dy);

            break;
          default:
        }

        break;
      case PaintToolMode.vectorSelection:
        switch (strokeMode) {
          case StrokeMode.click:
            _selectionController.setSelectedNodes([]);
            _selectionController.setSelectionData(null);
          case StrokeMode.end:
            if (_selectionController.selectionData == null ||
                _selectionController.selectionData!.start ==
                    _selectionController.selectionData!.end) {
              return;
            }

            final selectedNodes = <VectorNode>[];

            for (final vector
                in _paintController.paintData?.vectors ?? <Vector>[]) {
              for (final node in vector.nodes) {
                if (Utils.isPointInsideRect(
                  end: _selectionController.selectionData!.end,
                  point: node.coordinates,
                  start: _selectionController.selectionData!.start,
                )) {
                  selectedNodes.add(node);
                }
              }
            }

            _selectionController.setSelectedNodes(selectedNodes);
            _selectionController.setSelectionData(null);

            break;
          case StrokeMode.start:
            final coordinates = (x, y);

            _selectionController.setSelectionData(
              SelectionData(
                end: coordinates,
                selectionMode: SelectionMode.vectorSelection,
                start: coordinates,
              ),
            );

            _lastStrokeCoordinates = (dx, dy);

            _strokeStartCoordinates = (dx, dy);

            break;
          case StrokeMode.update:
            if (_lastStrokeCoordinates == null) {
              return;
            }

            if (_selectionController.selectedNodes.isEmpty) {
              if (_selectionController.selectionData != null) {
                _selectionController.setSelectionData(
                  SelectionData(
                    end: (x, y),
                    selectionMode: SelectionMode.vectorSelection,
                    start: _selectionController.selectionData!.start,
                  ),
                );
              }
            } else {
              // Define ddx and xxy as the variation since the last event's coordinates.
              final ddx =
                  (dx - _lastStrokeCoordinates!.$1) / _paintConfig.canvasScale;
              final ddy =
                  (dy - _lastStrokeCoordinates!.$2) / _paintConfig.canvasScale;

              if (_isKeyPressed([
                LogicalKeyboardKey.shiftLeft,
                LogicalKeyboardKey.shiftRight,
              ])) {
                if (_strokeStartCoordinates != null) {
                  _scaleSelection((ddx, ddy));
                }
              } else {
                _moveSelection((ddx, ddy));
              }

              _paintController.notify();
            }

            _lastStrokeCoordinates = (dx, dy);

            break;
          default:
        }

        break;
      case PaintToolMode.vectorLine:
        switch (strokeMode) {
          case StrokeMode.end:
            if (_strokeStartCoordinates == null ||
                _lastStrokeCoordinates == null) {
              return;
            }

            _addVector(
              vector: Vector(
                color: _paintConfig.paintToolColor,
                nodes: [
                  VectorNode.fromTuple(
                    (
                      ((_strokeStartCoordinates!.$1 - Constants.canvasPadding) /
                          _paintConfig.canvasScale),
                      ((_strokeStartCoordinates!.$2 - Constants.canvasPadding) /
                          _paintConfig.canvasScale),
                    ),
                  ),
                  VectorNode.fromTuple((x, y)),
                ],
                vectorPolygonMode: _paintConfig.vectorPolygonMode,
              ),
            );

            _strokeStartCoordinates = null;

            break;
          case StrokeMode.start:
            _strokeStartCoordinates = (dx, dy);
            break;
          case StrokeMode.update:
            _lastStrokeCoordinates = (dx, dy);
            break;
          default:
        }

        break;
      case PaintToolMode.vectorPolygon:
        switch (strokeMode) {
          case StrokeMode.start:
            if (_currentVector == null) {
              final vector = Vector(
                color: _paintConfig.paintToolColor,
                nodes: [VectorNode.fromTuple((x, y))],
                vectorPolygonMode: _paintConfig.vectorPolygonMode,
              );

              setState(() {
                _currentVector = vector;
              });

              _addVector(vector: vector);
            } else {
              _currentVector!.nodes.add(VectorNode.fromTuple((x, y)));

              _paintController.notify();
            }

            break;
          default:
        }

        break;
      default:
    }
  }

  void _incrementScale(int value) {
    setState(() {
      _paintConfig.canvasScale =
          Utils.clamp(_paintConfig.canvasScale + value, 1, 64).toInt();
    });
  }

  bool _isKeyPressed(List<LogicalKeyboardKey> targetKeys) {
    return RawKeyboard.instance.keysPressed
        .where((it) => targetKeys.contains(it))
        .isNotEmpty;
  }

  void _moveSelection((double, double) offset) {
    for (var node in _selectionController.selectedNodes) {
      node.coordinates = (
        node.coordinates.$1 + offset.$1,
        node.coordinates.$2 + offset.$2,
      );
    }
  }

  void _resetCurrentVector() {
    _selectionController.setSelectedNodes([]);
    _selectionController.setSelectionData(null);

    if (_currentVector == null || _currentVector!.nodes.isEmpty) {
      return;
    }

    setState(() {
      _currentVector = null;
    });
  }

  void _rotateSelection(double angle) {
    final radAngle = angle * (math.pi / 180.0);

    final sinAngle = math.sin(radAngle);
    final cosAngle = math.cos(radAngle);

    final xList = _selectionController.selectedNodes
        .map((e) => e.coordinates.$1)
        .toList();
    final yList = _selectionController.selectedNodes
        .map((e) => e.coordinates.$2)
        .toList();

    // Define the rotation center as the average of all points.
    final center = (Utils.avg(xList), Utils.avg(yList));

    for (var node in _selectionController.selectedNodes) {
      final translatedX = node.coordinates.$1 - center.$1;
      final translatedY = node.coordinates.$2 - center.$2;

      node.coordinates = (
        cosAngle * translatedX - sinAngle * translatedY + center.$1,
        sinAngle * translatedX + cosAngle * translatedY + center.$2,
      );
    }

    _paintController.notify();
  }

  void _scaleSelection((double, double) factor) {
    final xList = _selectionController.selectedNodes
        .map((e) => e.coordinates.$1)
        .toList();
    final yList = _selectionController.selectedNodes
        .map((e) => e.coordinates.$2)
        .toList();

    final xMin = Utils.min(xList);
    final yMin = Utils.min(yList);

    final xMax = Utils.max(xList);
    final yMax = Utils.max(yList);

    // Define the scaling center as the true center of the selection's bounding box.
    final center = (xMin + (xMax - xMin) / 2, yMin + (yMax - yMin) / 2);

    for (var node in _selectionController.selectedNodes) {
      final translatedX = node.coordinates.$1 - center.$1;
      final translatedY = node.coordinates.$2 - center.$2;

      node.coordinates = (
        center.$1 + translatedX * (factor.$1 / 100 + 1),
        center.$2 + translatedY * (-factor.$2 / 100 + 1),
      );
    }

    _paintController.notify();
  }

  void _setCanvas({
    required int dimensions,
  }) {
    setState(() {
      _paintConfig.canvasDimensions = (dimensions, dimensions);
    });

    _paintController.setPaintData(
      PaintData(
        clippingRect: null,
        pixels: List.generate(
          dimensions,
          (index) => List.generate(
            dimensions,
            (index) => Pixel.fromColor(Colors.white),
          ),
        ),
        vectors: [],
      ),
    );
  }

  void _setPaintToolMode(PaintToolMode paintToolMode) {
    _resetCurrentVector();

    setState(() {
      _paintConfig.paintToolMode = paintToolMode;
    });
  }

  void _setScale(int value) {
    setState(() {
      _paintConfig.canvasScale = Utils.clamp(value, 1, 64).toInt();
    });
  }

  @override
  void initState() {
    super.initState();

    _setCanvas(dimensions: 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.appName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: 'Settings',
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return SettingsDialog(
                      paintConfig: _paintConfig,
                      onClippingModeChanged: (clippingMode) {
                        setState(() {
                          _paintConfig.clippingMode = clippingMode;
                        });
                      },
                      onVectorLineDrawingModeChanged: (lineDrawingMode) {
                        setState(() {
                          _paintConfig.vectorLineDrawingMode = lineDrawingMode;
                        });
                      },
                    );
                  },
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          // '
          const SingleActivator(LogicalKeyboardKey.quoteSingle): () {
            _setPaintToolMode(PaintToolMode.pointer);
          },
          // B
          const SingleActivator(LogicalKeyboardKey.keyB): () {
            _setPaintToolMode(PaintToolMode.brush);
          },
          // L
          const SingleActivator(LogicalKeyboardKey.keyL): () {
            _setPaintToolMode(PaintToolMode.line);
          },
          // R
          const SingleActivator(LogicalKeyboardKey.keyR): () {
            _setPaintToolMode(PaintToolMode.circle);
          },
          // Ctrl + Q
          const SingleActivator(LogicalKeyboardKey.keyQ, control: true): () {
            _setPaintToolMode(PaintToolMode.vectorSelection);
          },
          // Ctrl + L
          const SingleActivator(LogicalKeyboardKey.keyL, control: true): () {
            _setPaintToolMode(PaintToolMode.vectorLine);
          },
          // Ctrl + P
          const SingleActivator(LogicalKeyboardKey.keyP, control: true): () {
            _setPaintToolMode(PaintToolMode.vectorPolygon);
          },
          // Ctrl + W
          const SingleActivator(LogicalKeyboardKey.keyW, control: true): () {
            _setPaintToolMode(PaintToolMode.vectorClip);
          },
          // Ctrl + +
          const SingleActivator(LogicalKeyboardKey.equal, control: true): () {
            _incrementScale(1);
          },
          // Ctrl + -
          const SingleActivator(LogicalKeyboardKey.minus, control: true): () {
            _incrementScale(-1);
          },
          // Ctrl + 0
          const SingleActivator(LogicalKeyboardKey.digit0, control: true): () {
            _setScale(1);
          },
          // Ctrl + A
          const SingleActivator(LogicalKeyboardKey.keyA, control: true): () {
            if (_paintConfig.paintToolMode == PaintToolMode.vectorSelection) {
              final allNodes = (_paintController.paintData?.vectors ?? [])
                  .map((e) => e.nodes)
                  .expand((element) => element)
                  .toList();

              _selectionController.setSelectedNodes(allNodes);
            }
          },
          // Ctrl + Delete
          const SingleActivator(LogicalKeyboardKey.delete, control: true): () {
            _setCanvas(dimensions: 100);
          },
        },
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerSignal: (pointerSignal) {
            if (pointerSignal is PointerScrollEvent) {
              if (_isKeyPressed([
                LogicalKeyboardKey.controlLeft,
                LogicalKeyboardKey.controlRight,
              ])) {
                if (pointerSignal.scrollDelta.dy > 0) {
                  _incrementScale(-1);
                } else if (pointerSignal.scrollDelta.dy < 0) {
                  _incrementScale(1);
                }
              } else {
                if (pointerSignal.scrollDelta.dy > 0) {
                  _rotateSelection(_paintConfig.rotationStep.toDouble());
                } else if (pointerSignal.scrollDelta.dy < 0) {
                  _rotateSelection(-_paintConfig.rotationStep.toDouble());
                }
              }
            }
          },
          child: Focus(
            autofocus: true,
            child: Container(
              color: Colors.blueGrey.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(height: 1),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _getLeftPanel()),
                        const VerticalDivider(width: 1),
                        _getRightPanel(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
