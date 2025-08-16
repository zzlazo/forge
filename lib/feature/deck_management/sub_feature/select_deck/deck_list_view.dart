import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/shared_utility.dart';
import '../../model/deck_model/deck_model.dart';

class DeckListView extends ConsumerWidget {
  final List<DeckIndex> deckIndexes;
  const DeckListView({
    super.key,
    required this.deckIndexes,
    this.checkedIndexes = const {},
    this.onTap,
    this.onLongPress,
    this.showCheckBox = false,
  });
  final Set<String> checkedIndexes;
  final void Function(DeckIndex deckIndex)? onTap;
  final void Function(DeckIndex deckIndex)? onLongPress;
  final bool showCheckBox;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: deckIndexes.length,
      itemBuilder: (context, index) {
        final DeckIndex deckIndex = deckIndexes[index];
        return _DeckTile(
          isChecked: checkedIndexes.contains(deckIndex.deckId),
          showCheckBox: showCheckBox,
          onLongPress: () => onLongPress?.call(deckIndex),
          title: deckIndex.title,
          updateTime: deckIndex.lastUpdate,
          onTap: () => onTap?.call(deckIndex),
        );
      },
    );
  }
}

class _DeckTile extends StatelessWidget {
  const _DeckTile({
    // ignore: unused_element_parameter
    super.key,
    required this.title,
    required this.updateTime,
    required this.onTap,
    this.isChecked = false,
    this.onLongPress,
    this.showCheckBox = false,
  });
  final void Function()? onTap;
  final String? title;
  final DateTime? updateTime;
  final bool isChecked;
  final bool showCheckBox;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    return ListTile(
      title: Text(title ?? "No Title"),
      onLongPress: onLongPress,
      leading: showCheckBox
          ? Checkbox(value: isChecked, onChanged: null)
          : null,
      subtitle: updateTime == null
          ? null
          : Text(
              "Updated: ${SharedUtility.formatViewDateTime(updateTime!, now)} ",
            ),
      onTap: onTap,
    );
  }
}
