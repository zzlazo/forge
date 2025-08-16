import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:riverpod_annotation/riverpod_annotation.dart";

import '../../../../shared/application/application_exception.dart';
import '../../../../shared/data_source/model/request/shared_request.dart';
import '../../../../shared/data_source/shared_local_data_source_utils.dart';
import '../../../../shared/provider/shared_provider.dart';
import '../../../deck_preset_management/application/provider/deck_preset_management_provider.dart';
import '../../../deck_preset_management/model/deck_preset_model/deck_preset_model.dart';
import '../../data_source/deck_management_data_source.dart';
import '../../data_source/model/deck_management_data_source_model.dart';
import "../../model/deck_model/deck_model.dart";
import '../../model/deck_request/deck_request.dart';
import '../../repository/deck_management_repository.dart';
import '../../sub_feature/export_deck/export_deck_utility.dart';

part 'deck_management_provider.g.dart';

@riverpod
SharedLocalDataSourceUtils sharedLocalDataSourceUtils(Ref ref) {
  return SharedLocalDataSourceUtilsImpl();
}

@riverpod
DeckManagementDataSourceConfig deckManagementDataSourceConfig(Ref ref) {
  return DeckManagementDataSourceConfig(
    directoryPath: ref.read(directoryPathProvider),
    fileExtension: 'json',
    indexFileTitle: 'deckIndex',
  );
}

@riverpod
DeckManagementDataSource deckManagementDataSource(
  Ref ref, {
  required DeckManagementDataSourceConfig config,
  required SharedLocalDataSourceUtils localUtils,
}) {
  return DeckManagementDataSourceImpl(config: config, localUtils: localUtils);
}

@riverpod
DeckManagementRepository deckManagementRepository(Ref ref) {
  return DeckManagementRepositoryImpl(
    ref.read(
      deckManagementDataSourceProvider(
        config: ref.read(deckManagementDataSourceConfigProvider),
        localUtils: ref.read(sharedLocalDataSourceUtilsProvider),
      ),
    ),
  );
}

@riverpod
Future<List<DeckIndex>> getDeckIndexes(Ref ref) async {
  try {
    return await ref.read(deckManagementRepositoryProvider).getIndexes();
  } on DataNotFoundException catch (_) {
    return [];
  } catch (e) {
    rethrow;
  }
}

@riverpod
Future<DeckData> getDeckData(Ref ref) async {
  final String? id = ref.watch(selectDeckIndexNotifierProvider)?.deckId;
  if (id == null) {
    final List<DeckPresetIndex> presets = await ref
        .read(deckPresetManagementRepositoryProvider)
        .getIndexes();
    if (presets.firstOrNull?.deckPresetId != null) {
      final DeckPreset preset = await ref
          .read(deckPresetManagementRepositoryProvider)
          .getDeckPreset(presets.first.deckPresetId!);
      return DeckData(
        cards: preset.items
            .map(
              (e) => CardData(
                index: CardIndex(suit: e.suit, number: e.number),
              ),
            )
            .toList(),
      );
    }
    return DeckData();
  } else {
    return await ref.read(deckManagementRepositoryProvider).getDeck(id);
  }
}

@riverpod
class SelectDeckIndexNotifier extends _$SelectDeckIndexNotifier {
  @override
  DeckIndex? build() {
    return null;
  }

  void set(DeckIndex index) => state = index;
}

@riverpod
class CreateDeckRequestNotifier extends _$CreateDeckRequestNotifier {
  @override
  AsyncValue<DeckData?> build() {
    return AsyncData(null);
  }

  Future<void> create({
    required String title,
    required DeckType type,
    required List<CardData> cards,
  }) async {
    state = AsyncLoading();
    final CreateDeckRequestItem item = CreateDeckRequestItem(
      deckTitle: title,
      deckType: type,
      cards: cards,
    );
    state = await AsyncValue.guard(() async {
      return await ref.read(deckManagementRepositoryProvider).createDeck(item);
    });
  }
}

@riverpod
class UpdateDeckRequestNotifier extends _$UpdateDeckRequestNotifier {
  @override
  AsyncValue<void> build() {
    return AsyncData(null);
  }

  Future<void> update({
    required String deckId,
    required String title,
    required DeckType type,
    required List<CardData> cards,
  }) async {
    state = AsyncLoading();
    final UpdateDeckRequestItem item = UpdateDeckRequestItem(
      deckId: deckId,
      deckTitle: title,
      deckType: type,
      cards: cards,
    );
    state = await AsyncValue.guard(() async {
      await ref.read(deckManagementRepositoryProvider).updateDeck(item);
    });
  }
}

@riverpod
class DeleteDeckRequestNotifier extends _$DeleteDeckRequestNotifier {
  @override
  AsyncValue<void> build() {
    return AsyncData(null);
  }

  Future<void> deleteAll(Set<String> deckIds) async {
    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(deckManagementRepositoryProvider).deleteDeck(deckIds);
    });
  }
}

List<ProviderListenable<AsyncValue>> combineDeckManagementAsyncValue() {
  return [
    createDeckRequestNotifierProvider,
    updateDeckRequestNotifierProvider,
    deleteDeckRequestNotifierProvider,
  ];
}

@riverpod
class SelectDeckScreenStateNotifier extends _$SelectDeckScreenStateNotifier {
  @override
  SelectDeckScreenState build() {
    return SelectDeckScreenState();
  }

  void showCheckBox() {
    state = state.copyWith(showCheckBox: true);
  }

  void hideCheckBox() {
    state = state.copyWith(showCheckBox: false);
  }

  void addChecks(Set<String> deckIds) {
    state = state.copyWith(checkedDecks: {...state.checkedDecks, ...deckIds});
  }

  void setCheck(Set<String> deckIds) {
    state = state.copyWith(checkedDecks: deckIds);
  }

  void removedChecks(Set<String> deckIds) {
    state = state.copyWith(
      checkedDecks: Set.from(state.checkedDecks)..removeAll(deckIds),
    );
  }
}

void coodinateDeckProvider(WidgetRef ref) {
  coordinateAsyncProviders(
    ref,
    combineDeckManagementAsyncValue(),
    onData: () {
      ref.invalidate(getDeckIndexesProvider);
      ref.invalidate(getDeckDataProvider);
    },
  );
}

@riverpod
void deckManagementKeepAlive(Ref ref) {
  ref.watch(selectDeckScreenStateNotifierProvider);
  ref.watch(selectDeckIndexNotifierProvider);
}

@riverpod
class DeckFormStateNotifier extends _$DeckFormStateNotifier {
  @override
  DeckFormModel build({String? id}) {
    return DeckFormModel(
      cards: PlayingCardDatas.suitSymbols.keys
          .expand(
            (suit) => PlayingCardDatas.numberSymbols.keys.map(
              (number) => CardData(
                index: CardIndex(suit: suit, number: number),
              ),
            ),
          )
          .toList(),
    );
  }

  void initialize(DeckFormModel deckFormModel) {
    state = deckFormModel;
  }

  void addCard() {
    state = state.copyWith(cards: [...state.cards, CardData()]);
  }

  void removeCardAt(int index) {
    state = state.copyWith(cards: List.from(state.cards)..removeAt(index));
  }

  void editTitle(String title) {
    state = state.copyWith(deckTitle: title);
  }

  void editSuit(Suit suit, int index) {
    state = state.copyWith(
      cards: state.cards.map((card) {
        if (card == state.cards[index]) {
          return card.copyWith(
            index: (card.index ?? CardIndex()).copyWith(suit: suit),
          );
        }
        return card;
      }).toList(),
    );
  }

  void editNumber(int number, int index) {
    state = state.copyWith(
      cards: state.cards.map((card) {
        if (card == state.cards[index]) {
          return card.copyWith(
            index: (card.index ?? CardIndex()).copyWith(number: number),
          );
        }
        return card;
      }).toList(),
    );
  }

  void editText(String text, int index) {
    state = state.copyWith(
      cards: state.cards.map((card) {
        if (card == state.cards[index]) {
          return card.copyWith(text: text);
        }
        return card;
      }).toList(),
    );
  }

  void save() {
    state = state.copyWith(onceSaved: true);
  }
}

@riverpod
class CardPainterStateNotifier extends _$CardPainterStateNotifier {
  @override
  CardPainterState build() {
    return CardPainterState();
  }

  void editBackGroundColor(Color color) {
    state = state.copyWith(backGroundColor: color);
  }

  void editTextColor(Color color) {
    state = state.copyWith(textColor: color);
  }
}

const String exportDeckExtension = "png";

@riverpod
class ExportDeckImageNotifier extends _$ExportDeckImageNotifier {
  @override
  AsyncValue<List<FileItem>> build() {
    return AsyncData([]);
  }

  Future<void> export({
    required Map<String, Widget> cards,
    required double pixelRatio,
  }) async {
    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      final List<FileItem> files = await ExportDeckUtility.getDeckImages(
        cards,
        pixelRatio,
        ref.read(cardPainterStateNotifierProvider),
        () => ref.read(deckExportProgressNotifierProvider.notifier).increment(),
      );
      return files;
    });
  }
}

@riverpod
class SaveDeckZipNotifier extends _$SaveDeckZipNotifier {
  @override
  AsyncValue<void> build() {
    return AsyncData(null);
  }

  Future<void> export({
    required List<FileItem> files,
    required String fileName,
  }) async {
    state = AsyncLoading();
    state = await AsyncValue.guard(() async {
      final ZipLocalFileRequest request = ZipLocalFileRequest(
        files: files,
        fileName: fileName,
      );
      await ref.read(deckManagementRepositoryProvider).exportDeck(request);
    });
  }
}

@riverpod
class DeckExportProgressNotifier extends _$DeckExportProgressNotifier {
  @override
  DeckExportProgress build() {
    return DeckExportProgress(
      total: (ref.read(getDeckDataProvider).valueOrNull?.cards ?? []).length,
    );
  }

  void increment() {
    state = state.copyWith(current: state.current + 1);
  }
}

@riverpod
void coodinateExportDeck(Ref ref) {
  ref.listen(exportDeckImageNotifierProvider, (previous, next) async {
    switch (next) {
      case AsyncData(:final value):
        if (value.isNotEmpty &&
            ref.read(selectDeckIndexNotifierProvider)?.title != null) {
          await ref
              .read(saveDeckZipNotifierProvider.notifier)
              .export(
                files: value,
                fileName: ref.read(selectDeckIndexNotifierProvider)!.title!,
              );
        }
    }
  });
}

@riverpod
void exportDeckKeepAlive(Ref ref) {
  ref.watch(coodinateExportDeckProvider);
}
