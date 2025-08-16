import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/presentation/alert_dialog/shared_alert_dialog.dart';
import '../../application/provider/deck_management_provider.dart';

class DeleteDeckDialog extends ConsumerWidget {
  const DeleteDeckDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SharedAlertDialog(
      title: "Confirm Delete",
      message:
          "Are you sure you want to delete ${ref.watch(selectDeckScreenStateNotifierProvider.select((e) => e.checkedDecks.length))} decks? This action cannot be undone.",
    );
  }
}
