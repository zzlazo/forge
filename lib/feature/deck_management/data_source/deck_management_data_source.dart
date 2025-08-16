import '../../../shared/data_source/data_source_exception.dart';
import '../../../shared/data_source/model/request/shared_request.dart';
import '../../../shared/data_source/shared_local_data_source_utils.dart';
import '../../../shared/shared_utility.dart';
import '../model/deck_model/deck_model.dart';
import '../model/deck_request/deck_request.dart';
import 'model/deck_management_data_source_model.dart';

abstract class DeckManagementDataSource {
  Future<List<DeckData>> createAllDeck(CreateDeckRequest request);
  Future<void> updateAllDeck(UpdateDeckRequest request);
  Future<void> deleteDeck(DeleteDeckRequest request);
  Future<List<DeckIndex>> getIndexes();
  Future<DeckData> getDeck(GetDeckRequest request);
  Future<void> exportDeck(ZipLocalFileRequest request);
}

class DeckManagementDataSourceImpl implements DeckManagementDataSource {
  final DeckManagementDataSourceConfig config;
  final SharedLocalDataSourceUtils localUtils;

  const DeckManagementDataSourceImpl({
    required this.config,
    required this.localUtils,
  });

  static String _newDeckId(DateTime lastUpdate) {
    return SharedUtility.onlyNumberAlphabet(lastUpdate.toIso8601String());
  }

  String getFullFileName(String fileTitle) {
    return "$fileTitle.${config.fileExtension}";
  }

  @override
  Future<List<DeckData>> createAllDeck(CreateDeckRequest request) async {
    final List<DeckIndex> indexes = [];
    final List<DeckData> decks = [];
    for (CreateDeckRequestItem item in request.items) {
      final DateTime lastUpdate = DateTime.now();

      final String deckId = _newDeckId(lastUpdate);
      final DeckIndex deckIndex = DeckIndex(
        deckId: deckId,
        lastUpdate: lastUpdate,
        title: item.deckTitle,
        deckType: item.deckType,
      );
      indexes.add(deckIndex);
      final DeckData deckData = DeckData(index: deckIndex, cards: item.cards);
      await _saveDeckData(deckData);
      decks.add(deckData);
    }
    await _updateIndexes(indexes);
    return decks;
  }

  @override
  Future<void> updateAllDeck(UpdateDeckRequest request) async {
    final DateTime lastUpdate = DateTime.now();

    final List<DeckIndex> indexes = [];
    for (UpdateDeckRequestItem item in request.items) {
      final String deckId = item.deckId;
      final DeckIndex deckIndex = DeckIndex(
        deckId: deckId,
        deckType: item.deckType,
        title: item.deckTitle,
        lastUpdate: lastUpdate,
      );
      indexes.add(deckIndex);
      final DeckData deck = DeckData(index: deckIndex, cards: item.cards);
      await _saveDeckData(deck);
    }
    await _updateIndexes(indexes);
  }

  Future<void> _updateIndexes(List<DeckIndex> newIndexes) async {
    final List<DeckIndex> saveIndexes = await getIndexes();
    for (DeckIndex deckIndex in newIndexes) {
      final int index = saveIndexes.indexWhere(
        (element) => element.deckId == deckIndex.deckId,
      );
      if (index == -1) {
        saveIndexes.add(deckIndex);
      } else {
        saveIndexes[index] = deckIndex;
      }
    }
    await _saveIndexes(saveIndexes);
  }

  Future<void> _saveIndexes(List<DeckIndex> deckIndexes) async {
    await localUtils.saveJsonFile(
      SaveJsonFileLocalRequest(
        json: deckIndexes.map((e) => e.toJson()).toList(),
        directoryPath: config.directoryPath,
        fileName: getFullFileName(config.indexFileTitle),
      ),
    );
  }

  Future<void> _saveDeckData(DeckData deckData) async {
    final String? deckId = deckData.index?.deckId;
    if (deckId != null) {
      await localUtils.saveJsonFile(
        SaveJsonFileLocalRequest(
          json: deckData.toJson(),
          directoryPath: config.directoryPath,
          fileName: getFullFileName(deckId),
        ),
      );
    }
  }

  @override
  Future<void> deleteDeck(DeleteDeckRequest request) async {
    List<DeleteLocalFileItem> items = [];
    final List<DeckIndex> saveIndexes = await getIndexes();
    final List<DeckIndex> newIndexes = saveIndexes
        .where((e) => !request.deckIds.contains(e.deckId))
        .toList();
    await _saveIndexes(newIndexes);
    for (String deckId in request.deckIds) {
      final String fileName = getFullFileName(deckId);
      items.add(
        DeleteLocalFileItem(
          fileName: fileName,
          directoryPath: config.directoryPath,
        ),
      );
    }
    await localUtils.deleteFile(DeleteLocalFileRequest(items: items));
  }

  @override
  Future<List<DeckIndex>> getIndexes() async {
    try {
      return await localUtils.loadFileAsModelList<DeckIndex>(
        LoadLocalFileAsModelRequest(
          fileName: getFullFileName(config.indexFileTitle),
          directoryPath: config.directoryPath,
          fromJson: DeckIndex.fromJson,
        ),
      );
    } on FileNotFoundException catch (_) {
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DeckData> getDeck(GetDeckRequest request) async {
    return await localUtils.loadFileAsModel<DeckData>(
      LoadLocalFileAsModelRequest(
        fileName: getFullFileName(request.deckId),
        directoryPath: config.directoryPath,
        fromJson: DeckData.fromJson,
      ),
    );
  }

  @override
  Future<void> exportDeck(ZipLocalFileRequest request) async {
    await localUtils.createAndSaveZipFromBytes(request);
  }
}
