import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared_utility.dart';
import 'model/shared_item_selector_model.dart';

class SharedItemSelectorWidget<T> extends HookConsumerWidget {
  const SharedItemSelectorWidget({super.key, required this.config});

  final SharedItemSelectorConfig<T> config;

  String _getLabelText(T? selectedItem) {
    return selectedItem == null
        ? SharedUtility.nullText
        : config.label(selectedItem) ?? SharedUtility.nullText;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labelController = useTextEditingController();
    ref.listen(config.stateProvider.select((e) => e.selectedItem), (
      previous,
      next,
    ) {
      labelController.text = _getLabelText(next);
    });
    return DropdownMenu<T>(
      initialSelection: ref.read(config.stateProvider).selectedItem,
      onSelected: config.onSelected,
      controller: labelController,
      dropdownMenuEntries: ref
          .watch(config.stateProvider)
          .entries
          .map((e) => DropdownMenuEntry<T>(value: e, label: _getLabelText(e)))
          .toList(),
    );
  }
}
