import '../../../shared/repository/error_converter_mixin.dart';
import '../data_source/deck_preset_management_data_source.dart';
import '../model/deck_preset_model/deck_preset_model.dart';
import '../model/deck_preset_request/deck_preset_request.dart';

abstract class DeckPresetManagementRepository {
  Future<void> createDeckPreset(CreateDeckPresetRequestItem item);
  Future<void> createAllDeckPreset(List<CreateDeckPresetRequestItem> items);

  Future<void> updateDeckPreset(UpdateDeckPresetRequestItem item);

  Future<void> deleteDeckPreset(String deckPresetId);

  Future<List<DeckPresetIndex>> getIndexes();

  Future<DeckPreset> getDeckPreset(String deckPresetId);

  Future<void> saveInitialDeckPresets();
}

class DeckPresetManagementRepositoryImpl
    with ErrorConverterMixin
    implements DeckPresetManagementRepository {
  final DeckPresetManagementDataSource _dataSource;

  const DeckPresetManagementRepositoryImpl(this._dataSource);

  @override
  Future<void> createDeckPreset(CreateDeckPresetRequestItem item) async {
    final CreateDeckPresetRequest request = CreateDeckPresetRequest(
      items: [item],
    );

    await wrapDataSourceCall(() => _dataSource.createAllDeckPreset(request));
  }

  @override
  Future<void> createAllDeckPreset(
    List<CreateDeckPresetRequestItem> items,
  ) async {
    final CreateDeckPresetRequest request = CreateDeckPresetRequest(
      items: items,
    );

    await wrapDataSourceCall(() => _dataSource.createAllDeckPreset(request));
  }

  @override
  Future<void> updateDeckPreset(UpdateDeckPresetRequestItem item) async {
    final UpdateDeckPresetRequest request = UpdateDeckPresetRequest(
      items: [item],
    );

    await wrapDataSourceCall(() => _dataSource.updateAllDeckPreset(request));
  }

  @override
  Future<void> deleteDeckPreset(String deckPresetId) async {
    await wrapDataSourceCall(
      () => _dataSource.deleteDeckPreset(
        DeleteDeckPresetRequest(deckId: deckPresetId),
      ),
    );
  }

  @override
  Future<List<DeckPresetIndex>> getIndexes() async {
    return await wrapDataSourceCall(() => _dataSource.getIndexes());
  }

  @override
  Future<DeckPreset> getDeckPreset(String deckPresetId) async {
    final GetDeckPresetRequest request = GetDeckPresetRequest(
      deckId: deckPresetId,
    );
    return await wrapDataSourceCall(() => _dataSource.getDeckPreset(request));
  }

  @override
  Future<void> saveInitialDeckPresets() async {
    final List<DeckPreset> initialDeckPresets = await _getInitialDeckPresets();

    final List<UpdateDeckPresetRequestItem> items = initialDeckPresets
        .where((e) => e.index?.deckPresetId != null)
        .map(
          (e) => UpdateDeckPresetRequestItem(
            deckPresetTitle: e.index?.title,
            deckType: e.index?.deckType,
            items: e.items,
            deckPresetId: e.index!.deckPresetId!,
          ),
        )
        .toList();
    await _dataSource.updateAllDeckPreset(
      UpdateDeckPresetRequest(items: items),
    );
  }

  Future<List<DeckPreset>> _getInitialDeckPresets() async {
    final List<DeckPreset> initialDeckPresets = await wrapDataSourceCall(
      () => _dataSource.getInitialDeckPresets(),
    );
    return initialDeckPresets;
  }
}
