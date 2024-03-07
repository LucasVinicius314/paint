import 'package:flutter/material.dart';
import 'package:paint/controllers/selection_controller.dart';
import 'package:paint/model/paint_config.dart';

class PaintInfoToolbar extends StatelessWidget {
  const PaintInfoToolbar({
    super.key,
    required this.paintConfig,
    required this.selectionController,
  });

  final PaintConfig paintConfig;
  final SelectionController selectionController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: IntrinsicHeight(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: ListenableBuilder(
              listenable: selectionController,
              builder: (context, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${(paintConfig.canvasScale * 100).toStringAsFixed(0)}%',
                    ),
                    const VerticalDivider(width: 16),
                    Text(
                      '${paintConfig.canvasDimensions.$1.toStringAsFixed(0)} x ${paintConfig.canvasDimensions.$2.toStringAsFixed(0)} px',
                    ),
                    if (selectionController.selectedNodes.isNotEmpty) ...[
                      const VerticalDivider(width: 16),
                      Text(
                        '${selectionController.selectedNodes.length.toStringAsFixed(0)} node${selectionController.selectedNodes.length == 1 ? '' : 's'} selected',
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
