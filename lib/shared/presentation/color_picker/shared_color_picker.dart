import "package:flex_color_picker/flex_color_picker.dart";
import "package:flutter/material.dart";

import "../widget_title/shared_widget_title.dart";
import "model/shared_color_picker_model.dart";

class SharedColorPicker extends StatelessWidget {
  final SharedColorPickerConfig config;
  const SharedColorPicker({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      title: config.title == null
          ? null
          : SharedWidgetTitle(title: config.title!),
      color: config.initialValue ?? Theme.of(context).colorScheme.primary,
      onColorChanged: config.onColorChanged,
      enableShadesSelection: false,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.wheel: true,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.both: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.customSecondary: false,
      },
    );
  }
}
