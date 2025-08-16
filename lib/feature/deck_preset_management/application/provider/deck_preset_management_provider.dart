import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:riverpod_annotation/riverpod_annotation.dart";

import '../../../../shared/application/application_exception.dart';
import '../../../../shared/data_source/shared_local_data_source_utils.dart';
import '../../../../shared/presentation/item_selector/model/shared_item_selector_model.dart';
import '../../../../shared/provider/shared_provider.dart';
import '../../../deck_management/application/provider/deck_management_provider.dart';
import '../../data_source/deck_preset_management_data_source.dart';
import '../../data_source/model/deck_preset_management_data_source_model.dart';
import "../../model/deck_preset_model/deck_preset_model.dart";
import '../../repository/deck_preset_management_repository.dart';

part 'deck_preset_management_provider.g.dart';

@riverpod
DeckPresetManagementDataSourceConfig deckPresetManagementDataSourceConfig(
  Ref ref,
) {
  return DeckPresetManagementDataSourceConfig(
    directoryPath: ref.read(directoryPathProvider),
    fileExtension: 'json',
    indexFileTitle: 'deckPresetIndex',
  );
}

@riverpod
DeckPresetManagementDataSource deckPresetManagementDataSource(
  Ref ref, {
  required DeckPresetManagementDataSourceConfig config,
  required SharedLocalDataSourceUtils localUtils,
}) {
  return DeckPresetManagementDataSourceImpl(
    config: config,
    localUtils: localUtils,
  );
}

@riverpod
DeckPresetManagementRepository deckPresetManagementRepository(Ref ref) {
  return DeckPresetManagementRepositoryImpl(
    ref.read(
      deckPresetManagementDataSourceProvider(
        config: ref.read(deckPresetManagementDataSourceConfigProvider),
        localUtils: ref.read(sharedLocalDataSourceUtilsProvider),
      ),
    ),
  );
}

@riverpod
Future<List<DeckPresetIndex>> getDeckPresetIndexes(Ref ref) async {
  try {
    return await ref.read(deckPresetManagementRepositoryProvider).getIndexes();
  } on DataNotFoundException catch (_) {
    return [];
  } catch (e) {
    rethrow;
  }
}

@riverpod
Future<DeckPreset?> getDeckPreset(Ref ref) async {
  final String? id = ref
      .watch(selectDeckPresetIndexNotifierProvider)
      ?.deckPresetId;
  if (id != null) {
    return await ref
        .read(deckPresetManagementRepositoryProvider)
        .getDeckPreset(id);
  }
  return null;
}

@riverpod
class SelectDeckPresetIndexNotifier extends _$SelectDeckPresetIndexNotifier {
  @override
  DeckPresetIndex? build() {
    return null;
  }

  void set(DeckPresetIndex index) => state = index;
}

@riverpod
class SelectedDeckPresetIndexNotifier
    extends _$SelectedDeckPresetIndexNotifier {
  @override
  DeckPresetIndex? build() {
    return null;
  }

  void select(DeckPresetIndex index) {
    state = index;
  }

  void deselect() {
    state = null;
  }
}

@riverpod
SharedItemSelectorState<DeckPresetIndex> deckPresetSelectorState(Ref ref) {
  return SharedItemSelectorState<DeckPresetIndex>(
    entries: ref.watch(getDeckPresetIndexesProvider).valueOrNull ?? [],
    selectedItem: ref.watch(selectDeckPresetIndexNotifierProvider),
  );
}
