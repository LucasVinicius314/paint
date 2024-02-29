import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paint/controllers/paint_controller.dart';
import 'package:paint/enums/line_drawing_mode.dart';
import 'package:paint/enums/paint_tool_mode.dart';
import 'package:paint/enums/stroke_mode.dart';
import 'package:paint/model/paint_config.dart';
import 'package:paint/model/paint_data.dart';
import 'package:paint/model/pixel.dart';
import 'package:paint/utils/constants.dart';
import 'package:paint/utils/utils.dart';
import 'package:paint/widgets/main_painter.dart';
import 'package:paint/widgets/paint_toolbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const route = '/';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _paintConfig = PaintConfig();

  final _paintController = PaintController();

  (int, int)? _strokeStartCoordinates;
  (int, int)? _lastStrokeCoordinates;

  void _drawLine({
    required Color color,
    required (int, int) endCoordinates,
    required (int, int) startCoordinates,
  }) {
    _paintController.setLine(
      endCoordinates: endCoordinates,
      lineDrawingMode: _paintConfig.lineDrawingMode,
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

  Widget _getBrushToolToolbar() {
    return _getColorPicker(
      width: Constants.colorPickerSwatchSpacing * 4 +
          Constants.colorPickerSwatchSize * 5,
    );
  }

  Widget _getColorPicker({
    required double width,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: width,
        child: Wrap(
          spacing: Constants.colorPickerSwatchSpacing,
          runSpacing: Constants.colorPickerSwatchSpacing,
          children: Constants.defaultColors.map((e) {
            return SizedBox.fromSize(
              size: const Size.square(Constants.colorPickerSwatchSize),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: e,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  side: BorderSide(
                    color: _paintConfig.paintToolColor == e
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor.withOpacity(.2),
                    width: _paintConfig.paintToolColor == e ? 3 : 1,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _paintConfig.paintToolColor = e;
                    });
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
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
                padding: const EdgeInsets.all(8),
                child: Transform.scale(
                  alignment: Alignment.topLeft,
                  origin: const Offset(-.5, -.5),
                  scale: _paintConfig.canvasScale.toDouble(),
                  transformHitTests: false,
                  child: SizedBox(
                    height: _paintConfig.canvasDimensions.$2.toDouble(),
                    width: _paintConfig.canvasDimensions.$1.toDouble(),
                    child: CustomPaint(
                      painter: MainPainter(controller: _paintController),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: IntrinsicHeight(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${(_paintConfig.canvasScale * 100).toStringAsFixed(0)}%',
                    ),
                    const VerticalDivider(width: 16),
                    Text(
                      '${_paintConfig.canvasDimensions.$1.toStringAsFixed(0)} x ${_paintConfig.canvasDimensions.$2.toStringAsFixed(0)} px',
                    ),
                  ],
                ),
              ),
            ),
          ),
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
          ...[
            (LineDrawingMode.bresenham, 'Bresenham'),
            (LineDrawingMode.dda, 'DDA'),
          ].map((e) {
            return RadioListTile(
              value: e.$1,
              groupValue: _paintConfig.lineDrawingMode,
              title: Text(e.$2),
              onChanged: (value) {
                setState(() {
                  _paintConfig.lineDrawingMode = e.$1;
                });
              },
            );
          }),
          const Divider(height: 1),
          _getColorPicker(
            width: Constants.colorPickerSwatchSpacing * 4 +
                Constants.colorPickerSwatchSize * 5,
          ),
        ],
      ),
    );
  }

  Widget _getRightPanel() {
    Widget? toolToolbar;

    switch (_paintConfig.paintToolMode) {
      case PaintToolMode.brush:
        toolToolbar = _getBrushToolToolbar();
        break;
      case PaintToolMode.line:
        toolToolbar = _getLineToolToolbar();
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
              },
              onPaintToolModeSelected: (paintToolMode) {
                setState(() {
                  _paintConfig.paintToolMode = paintToolMode;
                });
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
  }

  void _handleTapEvent({
    required double dx,
    required double dy,
    required StrokeMode strokeMode,
  }) {
    final x = ((dx - 8) / _paintConfig.canvasScale).floor();
    final y = ((dy - 8) / _paintConfig.canvasScale).floor();

    if (x < 0 ||
        y < 0 ||
        x >= _paintConfig.canvasDimensions.$1 ||
        y >= _paintConfig.canvasDimensions.$2) {
      _lastStrokeCoordinates = null;
      return;
    }

    switch (_paintConfig.paintToolMode) {
      case PaintToolMode.brush:
        if ([StrokeMode.start, StrokeMode.update].contains(strokeMode)) {
          _drawPixel(coordinates: (x, y), color: _paintConfig.paintToolColor);
        }

        break;
      case PaintToolMode.line:
        switch (strokeMode) {
          case StrokeMode.end:
            if (_strokeStartCoordinates == null) {
              return;
            }

            _drawLine(
              color: _paintConfig.paintToolColor,
              endCoordinates: (x, y),
              startCoordinates: (
                ((_strokeStartCoordinates!.$1 - 8) / _paintConfig.canvasScale)
                    .floor(),
                ((_strokeStartCoordinates!.$2 - 8) / _paintConfig.canvasScale)
                    .floor(),
              ),
            );

            _strokeStartCoordinates = null;
          case StrokeMode.start:
            _strokeStartCoordinates = (dx.round(), dy.round());

          case StrokeMode.update:
            _lastStrokeCoordinates = (dx.round(), dy.round());

          default:
        }
      default:
    }
  }

  void _incrementScale(int value) {
    setState(() {
      _paintConfig.canvasScale =
          Utils.clamp(_paintConfig.canvasScale + value, 1, 48).toInt();
    });
  }

  void _setCanvas({
    required int dimensions,
  }) {
    setState(() {
      _paintConfig.canvasDimensions = (dimensions, dimensions);
    });

    _paintController.setPaintData(
      PaintData(
        pixels: List.generate(
          dimensions,
          (index) => List.generate(
            dimensions,
            (index) => Pixel.fromColor(Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _setCanvas(dimensions: 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Constants.appName)),
      body: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.keyB): () {
            setState(() {
              _paintConfig.paintToolMode = PaintToolMode.brush;
            });
          },
          const SingleActivator(LogicalKeyboardKey.keyL): () {
            setState(() {
              _paintConfig.paintToolMode = PaintToolMode.line;
            });
          },
          const SingleActivator(LogicalKeyboardKey.quoteSingle): () {
            setState(() {
              _paintConfig.paintToolMode = PaintToolMode.pointer;
            });
          },
          const SingleActivator(LogicalKeyboardKey.minus, control: true): () {
            _incrementScale(-1);
          },
          const SingleActivator(LogicalKeyboardKey.equal, control: true): () {
            _incrementScale(1);
          },
          const SingleActivator(LogicalKeyboardKey.delete, control: true): () {
            _setCanvas(dimensions: 100);
          },
        },
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerSignal: (pointerSignal) {
            if (pointerSignal is PointerScrollEvent) {
              final controlKeys = [
                LogicalKeyboardKey.controlLeft,
                LogicalKeyboardKey.controlRight,
              ];

              if (RawKeyboard.instance.keysPressed
                  .where((it) => controlKeys.contains(it))
                  .isNotEmpty) {
                if (pointerSignal.scrollDelta.dy > 0) {
                  _incrementScale(-1);
                } else if (pointerSignal.scrollDelta.dy < 0) {
                  _incrementScale(1);
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
