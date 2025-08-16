import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/presentation/color_picker/model/shared_color_picker_model.dart';
import '../../../../shared/presentation/color_picker/shared_color_picker.dart';
import '../../../../shared/presentation/widget_title/shared_widget_title.dart';
import '../../application/provider/deck_management_provider.dart';

class ExportDeckConfigDialog extends ConsumerWidget {
  const ExportDeckConfigDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: SharedWidgetTitle(title: "Color Picker"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SharedColorPicker(
            config: SharedColorPickerConfig(
              title: "BackGroud Color",
              initialValue: ref
                  .read(cardPainterStateNotifierProvider)
                  .backGroundColor,
              onColorChanged: (Color color) {
                ref
                    .read(cardPainterStateNotifierProvider.notifier)
                    .editBackGroundColor(color);
              },
            ),
          ),
          SharedColorPicker(
            config: SharedColorPickerConfig(
              title: "Text Color",
              initialValue: ref
                  .read(cardPainterStateNotifierProvider)
                  .textColor,
              onColorChanged: (Color color) {
                ref
                    .read(cardPainterStateNotifierProvider.notifier)
                    .editTextColor(color);
              },
            ),
          ),
        ],
      ),
    );
  }
}
