import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/presentation/item_selector/model/shared_item_selector_model.dart';
import '../../../shared/presentation/item_selector/shared_item_selector_widget.dart';
import '../../../shared/presentation/text_field/model/shared_text_field_model.dart';
import '../../../shared/presentation/text_field/shared_text_field.dart';
import '../application/provider/deck_management_provider.dart';
import '../model/deck_model/deck_model.dart';

class UpdateDeckForm extends ConsumerWidget {
  const UpdateDeckForm({super.key, required this.formProvider});

  final DeckFormStateNotifierProvider formProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CardData> cards = ref.watch(formProvider.select((e) => e.cards));
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        spacing: 10,
        children: [
          SharedTextFormField(
            config: SharedTextFieldConfig(
              stateProvider: formProvider.select((e) => e.deckTitle ?? ""),
              onChanged: (text) {
                ref.read(formProvider.notifier).editTitle(text);
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final SharedItemSelectorConfig<Suit> suitSelectorConfig =
                    SharedItemSelectorConfig<Suit>(
                      stateProvider: formProvider.select(
                        (value) => SharedItemSelectorState(
                          entries: Suit.values,
                          selectedItem: value.cards[index].index?.suit,
                        ),
                      ),
                      onSelected: (item) {
                        if (item != null) {
                          ref.read(formProvider.notifier).editSuit(item, index);
                        }
                      },
                      label: (item) => PlayingCardDatas.suitSymbols[item],
                    );

                final SharedItemSelectorConfig<int> numberSelectorConfig =
                    SharedItemSelectorConfig<int>(
                      stateProvider: formProvider.select(
                        (value) => SharedItemSelectorState(
                          entries: List<int>.generate(13, (i) => i + 1),
                          selectedItem: value.cards[index].index?.number,
                        ),
                      ),
                      onSelected: (item) {
                        if (item != null) {
                          ref
                              .read(formProvider.notifier)
                              .editNumber(item, index);
                        }
                      },
                      label: (item) => PlayingCardDatas.numberSymbols[item],
                    );

                final SharedTextFieldConfig textFormConfig =
                    SharedTextFieldConfig(
                      maxLines: 5,
                      stateProvider: formProvider.select(
                        (value) => value.cards[index].text ?? "",
                      ),
                      onChanged: (value) {
                        ref.read(formProvider.notifier).editText(value, index);
                      },
                    );

                return _DeckListFormListItem(
                  suitSelectorConfig: suitSelectorConfig,
                  numberSelectorConfig: numberSelectorConfig,
                  textFormConfig: textFormConfig,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DeckListFormListItem extends ConsumerWidget {
  const _DeckListFormListItem({
    // ignore: unused_element_parameter
    super.key,
    required this.suitSelectorConfig,
    required this.numberSelectorConfig,
    required this.textFormConfig,
  });

  final SharedItemSelectorConfig<Suit> suitSelectorConfig;
  final SharedItemSelectorConfig<int> numberSelectorConfig;
  final SharedTextFieldConfig textFormConfig;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SharedItemSelectorWidget(config: numberSelectorConfig),
            SharedItemSelectorWidget(config: suitSelectorConfig),
          ],
        ),
        SharedTextFormField(config: textFormConfig),
      ],
    );
  }
}
