import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'model/shared_text_field_model.dart';

class SharedTextField extends HookConsumerWidget {
  const SharedTextField({super.key, required this.config});

  final SharedTextFieldConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = useTextEditingController(
      text: ref.read(config.stateProvider),
    );
    ref.listen<String>(config.stateProvider, (previous, next) {
      if (next != controller.text) {
        controller.text = next;
      }
    });
    return TextField(
      controller: controller,
      onChanged: config.onChanged,
      maxLines: config.maxLines,
    );
  }
}

class SharedTextFormField extends HookConsumerWidget {
  const SharedTextFormField({super.key, required this.config});

  final SharedTextFieldConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = useTextEditingController(
      text: ref.read(config.stateProvider),
    );
    ref.listen<String>(config.stateProvider, (previous, next) {
      if (next != controller.text) {
        controller.text = next;
      }
    });
    return TextFormField(
      controller: controller,
      onChanged: config.onChanged,
      maxLines: config.maxLines,
    );
  }
}
