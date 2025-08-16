import 'package:freezed_annotation/freezed_annotation.dart';

part 'deck_management_data_source_model.freezed.dart';

@freezed
abstract class DeckManagementDataSourceConfig
    with _$DeckManagementDataSourceConfig {
  factory DeckManagementDataSourceConfig({
    required String fileExtension,
    required String directoryPath,
    required String indexFileTitle,
  }) = _DeckManagementDataSourceConfig;
}
