import '../../../shared/data_source/data_source_exception.dart';
import '../../../shared/data_source/model/request/shared_request.dart';
import '../../../shared/data_source/shared_data_source_utils.dart';
import '../../../shared/data_source/shared_local_data_source_utils.dart';
import '../model/deck_preset_model/deck_preset_model.dart';
import '../model/deck_preset_request/deck_preset_request.dart';
import 'model/deck_preset_management_data_source_model.dart';

abstract class DeckPresetManagementDataSource {
  Future<void> createAllDeckPreset(CreateDeckPresetRequest request);
  Future<void> updateAllDeckPreset(UpdateDeckPresetRequest request);
  Future<void> deleteDeckPreset(DeleteDeckPresetRequest request);
  Future<List<DeckPresetIndex>> getIndexes();
  Future<DeckPreset> getDeckPreset(GetDeckPresetRequest request);
  Future<List<DeckPreset>> getInitialDeckPresets();
}

class DeckPresetManagementDataSourceImpl
    implements DeckPresetManagementDataSource {
  final DeckPresetManagementDataSourceConfig config;
  final SharedLocalDataSourceUtils localUtils;

  const DeckPresetManagementDataSourceImpl({
    required this.config,
    required this.localUtils,
  });

  String getFullFileName(String fileTitle) {
    return "$fileTitle.${config.fileExtension}";
  }

  static String _newDeckId(DateTime lastUpdate) {
    return lastUpdate.toIso8601String();
  }

  @override
  Future<void> createAllDeckPreset(CreateDeckPresetRequest request) async {
    final DateTime lastUpdate = DateTime.now();

    final List<DeckPresetIndex> indexes = [];
    for (CreateDeckPresetRequestItem item in request.items) {
      final String deckId = _newDeckId(lastUpdate);
      final DeckPresetIndex deckIndex = DeckPresetIndex(
        deckPresetId: deckId,
        lastUpdate: lastUpdate,
        title: item.deckPresetTitle,
        deckType: item.deckType,
      );
      indexes.add(deckIndex);
      final DeckPreset deckPresetData = DeckPreset(
        index: deckIndex,
        items: item.items,
      );
      await _saveDeckPresetData(deckPresetData);
    }
    await _updateIndexes(indexes);
  }

  @override
  Future<void> updateAllDeckPreset(UpdateDeckPresetRequest request) async {
    final DateTime lastUpdate = DateTime.now();

    final List<DeckPresetIndex> indexes = [];
    for (UpdateDeckPresetRequestItem item in request.items) {
      final String deckId = item.deckPresetId;
      final DeckPresetIndex deckIndex = DeckPresetIndex(
        deckPresetId: deckId,
        deckType: item.deckType,
        title: item.deckPresetTitle,
        lastUpdate: lastUpdate,
      );
      indexes.add(deckIndex);
      final DeckPreset deckPreset = DeckPreset(
        index: deckIndex,
        items: item.items,
      );
      await _saveDeckPresetData(deckPreset);
    }
    await _updateIndexes(indexes);
  }

  Future<void> _updateIndexes(List<DeckPresetIndex> newIndexes) async {
    final List<DeckPresetIndex> saveIndexes = await getIndexes();
    for (DeckPresetIndex deckIndex in newIndexes) {
      final int index = saveIndexes.indexWhere(
        (element) => element.deckPresetId == deckIndex.deckPresetId,
      );
      if (index == -1) {
        saveIndexes.add(deckIndex);
      } else {
        saveIndexes[index] = deckIndex;
      }
    }
    await _saveIndexes(saveIndexes);
  }

  Future<void> _saveIndexes(List<DeckPresetIndex> deckIndexes) async {
    return await localUtils.saveJsonFile(
      SaveJsonFileLocalRequest(
        json: deckIndexes.map((e) => e.toJson()).toList(),
        directoryPath: config.directoryPath,
        fileName: getFullFileName(config.indexFileTitle),
      ),
    );
  }

  Future<void> _saveDeckPresetData(DeckPreset deckPresetData) async {
    final String? deckPresetId = deckPresetData.index?.deckPresetId;
    if (deckPresetId != null) {
      await localUtils.saveJsonFile(
        SaveJsonFileLocalRequest(
          json: deckPresetData.toJson(),
          directoryPath: config.directoryPath,
          fileName: getFullFileName(deckPresetId),
        ),
      );
    }
  }

  @override
  Future<void> deleteDeckPreset(DeleteDeckPresetRequest request) async {
    final String fileName = getFullFileName(request.deckId);
    await localUtils.deleteFile(
      DeleteLocalFileRequest(
        items: [
          DeleteLocalFileItem(
            fileName: fileName,
            directoryPath: config.directoryPath,
          ),
        ],
      ),
    );
    final List<DeckPresetIndex> indexes = await getIndexes();
    indexes.removeWhere((e) => e.deckPresetId == request.deckId);
    await _saveIndexes(indexes);
  }

  @override
  Future<List<DeckPresetIndex>> getIndexes() async {
    try {
      return await localUtils.loadFileAsModelList<DeckPresetIndex>(
        LoadLocalFileAsModelRequest(
          fileName: getFullFileName(config.indexFileTitle),
          directoryPath: config.directoryPath,
          fromJson: DeckPresetIndex.fromJson,
        ),
      );
    } on FileNotFoundException catch (_) {
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeckPreset> getDeckPreset(GetDeckPresetRequest request) async {
    return await localUtils.loadFileAsModel<DeckPreset>(
      LoadLocalFileAsModelRequest(
        fileName: getFullFileName(request.deckId),
        directoryPath: config.directoryPath,
        fromJson: DeckPreset.fromJson,
      ),
    );
  }

  @override
  Future<List<DeckPreset>> getInitialDeckPresets() async {
    final List<dynamic>? jsonData = await localUtils
        .loadJsonAsset<List<dynamic>>(
          LoadAssetRequest(
            fileName: "deck_preset.json",
            directoryPath: "presets",
          ),
        );

    return jsonData?.isNotEmpty == true
        ? jsonData!
              .map(
                (e) => SharedDataSourceUtils.wrapParseJsonToModel<DeckPreset>(
                  () => DeckPreset.fromJson(e as Map<String, dynamic>),
                ),
              )
              .toList()
        : [];
  }
}
