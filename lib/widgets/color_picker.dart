import 'package:flutter/material.dart';
import 'package:paint/model/paint_config.dart';
import 'package:paint/utils/constants.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    super.key,
    required this.onColorPicked,
    required this.paintConfig,
    required this.width,
  });

  final void Function(Color color) onColorPicked;
  final PaintConfig paintConfig;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Color picker',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Container(
            padding: const EdgeInsets.only(top: 8),
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
                        color: paintConfig.paintToolColor == e
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).dividerColor.withOpacity(.2),
                        width: paintConfig.paintToolColor == e ? 3 : 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        onColorPicked(e);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
