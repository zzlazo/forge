import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/presentation/loading_indicator/shared_loading_indicator.dart';
import '../../application/provider/deck_management_provider.dart';
import '../../model/deck_model/deck_model.dart';

class SaveDeckDialog extends ConsumerWidget {
  const SaveDeckDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DeckExportProgress progress = ref.watch(
      deckExportProgressNotifierProvider,
    );
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                SharedLoadingIndicator(),
                Text(
                  "${progress.current}/${progress.total} cards was exported",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
