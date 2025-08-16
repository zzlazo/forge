import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/presentation/base_screen/shared_app_bar.dart';
import '../../../../shared/presentation/base_screen/shared_base_screen.dart';
import '../../../../shared/presentation/snack_bar/shared_snack_bar.dart';
import '../../application/provider/deck_management_provider.dart';
import '../../model/deck_model/deck_model.dart';
import '../../presentation/go_to_export_button.dart';
import '../../presentation/update_deck_form.dart';

class CreateDeckScreen extends ConsumerWidget {
  const CreateDeckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? deckId = ref.read(selectDeckIndexNotifierProvider)?.deckId;
    final formProvider = deckFormStateNotifierProvider(id: deckId);
    ref.listen(updateDeckRequestNotifierProvider, (previous, next) {
      switch (next) {
        case AsyncData _:
          ScaffoldMessenger.of(context).showSnackBar(
            SharedInformationSnackBar(message: "Deck created successfully"),
          );
      }
    });
    return SharedBaseScreen(
      body: UpdateDeckForm(formProvider: formProvider),
      appBar: SharedAppBar(
        title: "Create Deck",
        actions: [
          GoToExportButton(),
          _CreateDeckSaveButton(formProvider: formProvider),
        ],
      ),
    );
  }
}

class _CreateDeckSaveButton extends ConsumerWidget {
  const _CreateDeckSaveButton({
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
              deck.cards.isNotEmpty
          ? () async {
              if (deck.onceSaved) {
                await ref
                    .read(updateDeckRequestNotifierProvider.notifier)
                    .update(
                      deckId: ref
                          .read(selectDeckIndexNotifierProvider)!
                          .deckId!,
                      title: deck.deckTitle!,
                      type: DeckType.playingCard,
                      cards: deck.cards,
                    );
              } else {
                await ref
                    .read(createDeckRequestNotifierProvider.notifier)
                    .create(
                      title: deck.deckTitle!,
                      type: DeckType.playingCard,
                      cards: deck.cards,
                    );
                if (ref
                        .read(createDeckRequestNotifierProvider)
                        .valueOrNull
                        ?.index !=
                    null) {
                  ref
                      .read(selectDeckIndexNotifierProvider.notifier)
                      .set(
                        ref
                            .read(createDeckRequestNotifierProvider)
                            .valueOrNull!
                            .index!,
                      );
                }
              }
            }
          : null,
    );
  }
}
