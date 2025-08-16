import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/presentation/base_screen/shared_app_bar.dart';
import '../../../../shared/presentation/base_screen/shared_base_screen.dart';
import '../../../../shared/presentation/snack_bar/shared_snack_bar.dart';
import '../../application/provider/deck_management_provider.dart';
import '../../model/deck_model/deck_model.dart';
import '../../presentation/go_to_export_button.dart';
import '../../presentation/update_deck_form.dart';

class UpdateDeckScreen extends ConsumerWidget {
  const UpdateDeckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? deckId = ref.read(selectDeckIndexNotifierProvider)?.deckId;
    final formProvider = deckFormStateNotifierProvider(id: deckId);
    ref.listen(updateDeckRequestNotifierProvider, (previous, next) {
      switch (next) {
        case AsyncData _:
          ScaffoldMessenger.of(context).showSnackBar(
            SharedInformationSnackBar(message: "Deck updated successfully"),
          );
      }
    });
    ref.listen(getDeckDataProvider, (previous, next) {
      switch (next) {
        case AsyncData(:final value):
          ref
              .read(formProvider.notifier)
              .initialize(
                DeckFormModel(
                  deckTitle: value.index?.title,
                  cards: value.cards,
                  deckType: value.index?.deckType ?? DeckType.playingCard,
                ),
              );
      }
    });

    return SharedBaseScreen(
      body: UpdateDeckForm(formProvider: formProvider),
      appBar: SharedAppBar(
        title: "Update Deck",
        actions: [
          GoToExportButton(),
          _UpdateDeckSaveButton(formProvider: formProvider),
        ],
      ),
    );
  }
}

class _UpdateDeckSaveButton extends ConsumerWidget {
  const _UpdateDeckSaveButton({
    // ignore: unused_element_parameter
    super.key,
    required this.formProvider,
  });

  final DeckFormStateNotifierProvider formProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DeckFormModel deck = ref.watch(formProvider);
    return SharedAppBarSaveButton(
      onPressed:
          deck.deckTitle != null &&
              deck.deckTitle!.isNotEmpty &&
              deck.cards.isNotEmpty &&
              ref.read(selectDeckIndexNotifierProvider)?.deckId != null
          ? () async {
              await ref
                  .read(updateDeckRequestNotifierProvider.notifier)
                  .update(
                    deckId: ref.read(selectDeckIndexNotifierProvider)!.deckId!,
                    title: deck.deckTitle!,
                    type: DeckType.playingCard,
                    cards: deck.cards,
                  );
              ref.read(formProvider.notifier).save();
            }
          : null,
    );
  }
}
