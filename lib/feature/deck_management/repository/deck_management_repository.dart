import '../../../shared/data_source/model/request/shared_request.dart';
import '../../../shared/repository/error_converter_mixin.dart';
import '../../deck_management/model/deck_model/deck_model.dart';
import '../data_source/deck_management_data_source.dart';
import '../model/deck_request/deck_request.dart';

abstract class DeckManagementRepository {
  Future<DeckData> createDeck(CreateDeckRequestItem item);

  Future<void> updateDeck(UpdateDeckRequestItem item);

  Future<void> deleteDeck(Set<String> deckIds);

  Future<List<DeckIndex>> getIndexes();

  Future<DeckData> getDeck(String deckId);

  Future<void> exportDeck(ZipLocalFileRequest request);
}

class DeckManagementRepositoryImpl
    with ErrorConverterMixin
    implements DeckManagementRepository {
  final DeckManagementDataSource _dataSource;

  const DeckManagementRepositoryImpl(this._dataSource);

  @override
  Future<DeckData> createDeck(CreateDeckRequestItem item) async {
    final CreateDeckRequest request = CreateDeckRequest(items: [item]);

    final decks = await wrapDataSourceCall(
      () => _dataSource.createAllDeck(request),
    );
    return decks.first;
  }

  @override
  Future<void> updateDeck(UpdateDeckRequestItem item) async {
    final UpdateDeckRequest request = UpdateDeckRequest(items: [item]);

    await wrapDataSourceCall(() => _dataSource.updateAllDeck(request));
  }

  @override
  Future<void> deleteDeck(Set<String> deckIds) async {
    await wrapDataSourceCall(
      () => _dataSource.deleteDeck(DeleteDeckRequest(deckIds: deckIds)),
    );
  }

  @override
  Future<List<DeckIndex>> getIndexes() async {
    return await wrapDataSourceCall(() => _dataSource.getIndexes());
  }

  @override
  Future<DeckData> getDeck(String deckId) async {
    final GetDeckRequest request = GetDeckRequest(deckId: deckId);
    return await wrapDataSourceCall(() => _dataSource.getDeck(request));
  }

  @override
  Future<void> exportDeck(ZipLocalFileRequest request) async {
    await wrapDataSourceCall(() => _dataSource.exportDeck(request));
  }
}
