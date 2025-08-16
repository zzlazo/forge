import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/router/router.dart';
import '../../../../shared/model/shared_model.dart';
import '../../../../shared/presentation/async_state_builder/shared_async_state_builder.dart';
import '../../../../shared/presentation/base_screen/shared_app_bar.dart';
import '../../../../shared/presentation/base_screen/shared_base_screen.dart';
import '../../application/provider/deck_management_provider.dart';
import 'create_deck_button.dart';
import 'deck_list_view.dart';

class SelectDeckScreen extends ConsumerWidget {
  const SelectDeckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showCheck = ref.watch(
      selectDeckScreenStateNotifierProvider.select((e) => e.showCheckBox),
    );
    final Set<String> checkedIds = ref.watch(
      selectDeckScreenStateNotifierProvider.select((e) => e.checkedDecks),
    );
    coodinateDeckProvider(ref);
    ref.watch(deckManagementKeepAliveProvider);
    return SharedBaseScreen(
      title: "Decks",
      floatingActionButton: showCheck ? null : CreateDeckButton(),
      appBar: SharedAppBar(
        title: "Decks",
        leading: showCheck
            ? IconButton(
                onPressed: () {
                  ref
                      .read(selectDeckScreenStateNotifierProvider.notifier)
                      .hideCheckBox();
                },
                icon: Icon(Icons.arrow_back),
              )
            : null,
        actions: [
          if (showCheck && checkedIds.isNotEmpty)
            IconButton(
              onPressed: () async {
                final result = await DeleteDeckRoute().push(context);
                if (result == DialogAction.ok) {
                  ref
                      .read(selectDeckScreenStateNotifierProvider.notifier)
                      .hideCheckBox();
                  final Set<String> deckIds = ref
                      .read(selectDeckScreenStateNotifierProvider)
                      .checkedDecks;
                  if (deckIds.isNotEmpty) {
                    await ref
                        .read(deleteDeckRequestNotifierProvider.notifier)
                        .deleteAll(deckIds);
                  }
                }
              },
              icon: Icon(Icons.delete),
            ),
          if (showCheck)
            IconButton(
              onPressed: () {
                if (ref
                    .read(selectDeckScreenStateNotifierProvider)
                    .checkedDecks
                    .isEmpty) {
                  final Set<String> deckIds =
                      ref
                          .watch(getDeckIndexesProvider)
                          .valueOrNull
                          ?.map((e) => e.deckId)
                          .nonNulls
                          .toSet() ??
                      {};
                  ref
                      .read(selectDeckScreenStateNotifierProvider.notifier)
                      .setCheck(deckIds);
                } else {
                  ref
                      .read(selectDeckScreenStateNotifierProvider.notifier)
                      .setCheck({});
                }
              },
              icon: Icon(Icons.select_all),
            ),
        ],
      ),
      body: SharedAsyncStateBuilder(
        asyncValue: ref.watch(getDeckIndexesProvider),
        builder: (value) => DeckListView(
          deckIndexes: value,
          showCheckBox: showCheck,
          checkedIndexes: checkedIds,
          onTap: (deckIndex) async {
            if (deckIndex.deckId != null) {
              if (ref
                  .read(selectDeckScreenStateNotifierProvider)
                  .showCheckBox) {
                final Set<String> checkedDecks = ref
                    .read(selectDeckScreenStateNotifierProvider)
                    .checkedDecks;
                if (checkedDecks.contains(deckIndex.deckId)) {
                  ref
                      .read(selectDeckScreenStateNotifierProvider.notifier)
                      .removedChecks({deckIndex.deckId!});
                } else {
                  ref
                      .read(selectDeckScreenStateNotifierProvider.notifier)
                      .addChecks({deckIndex.deckId!});
                }
              } else {
                ref
                    .read(selectDeckIndexNotifierProvider.notifier)
                    .set(deckIndex);
                await UpdateDeckRoute().push(context);
              }
            }
          },
          onLongPress: (deckIndex) {
            if (deckIndex.deckId != null) {
              ref.read(selectDeckScreenStateNotifierProvider.notifier).setCheck(
                {deckIndex.deckId!},
              );
              ref
                  .read(selectDeckScreenStateNotifierProvider.notifier)
                  .showCheckBox();
            }
          },
        ),
      ),
    );
  }
}
