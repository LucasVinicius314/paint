import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paint/enums/paint_tool_mode.dart';
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
  var _canvasDimensions = (0, 0);
  var _canvasScale = 1;

  var _paintToolMode = PaintToolMode.pointer;

  List<List<Pixel>> _pixels = [];

  void _draw({
    required (int, int) position,
  }) {
    setState(() {
      _pixels[position.$1][position.$2] = Pixel(r: 0, g: 0, b: 0);
    });
  }

  Widget _getLeftPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (details) {
              if (_paintToolMode != PaintToolMode.brush) {
                return;
              }

              final x = ((details.localPosition.dx - 8) / _canvasScale).round();
              final y =
                  (((details.localPosition.dy - 8) / _canvasScale)).round();

              if (x < 0 ||
                  y < 0 ||
                  x >= _canvasDimensions.$1 ||
                  y >= _canvasDimensions.$2) {
                return;
              }

              _draw(position: (x, y));
            },
            onPanUpdate: (details) {
              if (_paintToolMode != PaintToolMode.brush) {
                return;
              }

              final x = ((details.localPosition.dx - 8) / _canvasScale).round();
              final y =
                  (((details.localPosition.dy - 8) / _canvasScale)).round();

              if (x < 0 ||
                  y < 0 ||
                  x >= _canvasDimensions.$1 ||
                  y >= _canvasDimensions.$2) {
                return;
              }

              _draw(position: (x, y));
            },
            child: MouseRegion(
              opaque: false,
              cursor: {
                    PaintToolMode.brush: SystemMouseCursors.precise,
                  }[_paintToolMode] ??
                  MouseCursor.defer,
              child: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.all(8),
                child: Transform.scale(
                  alignment: Alignment.topLeft,
                  scale: _canvasScale.toDouble(),
                  transformHitTests: false,
                  child: SizedBox(
                    height: _canvasDimensions.$2.toDouble(),
                    width: _canvasDimensions.$1.toDouble(),
                    child: CustomPaint(painter: MainPainter(pixels: _pixels)),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(8.0),
          child: Text('${(_canvasScale * 100).toStringAsFixed(0)}%'),
        ),
      ],
    );
  }

  Widget _getRightPanel() {
    return IntrinsicWidth(
      child: PaintToolbar(
        onCleared: () {
          _setCanvas(dimensions: 100);
        },
        onPaintToolModeSelected: (paintToolMode) {
          setState(() {
            _paintToolMode = paintToolMode;
          });
        },
        onZoomedIn: () {
          _incrementScale(1);
        },
        onZoomedOut: () {
          _incrementScale(-1);
        },
        paintToolMode: _paintToolMode,
      ),
    );
  }

  void _incrementScale(int value) {
    setState(() {
      _canvasScale = Utils.clamp(_canvasScale + value, 1, 16).toInt();
    });
  }

  void _setCanvas({
    required int dimensions,
  }) {
    setState(() {
      _canvasDimensions = (dimensions, dimensions);

      _pixels = List.generate(
        dimensions,
        (index) => List.generate(
          dimensions,
          (index) => Pixel(r: 255, g: 255, b: 255),
        ),
      );
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
      appBar: AppBar(title: const Text(Constants.appName)),
      body: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.keyB): () {
            setState(() {
              _paintToolMode = PaintToolMode.brush;
            });
          },
          const SingleActivator(LogicalKeyboardKey.quoteSingle): () {
            setState(() {
              _paintToolMode = PaintToolMode.pointer;
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
