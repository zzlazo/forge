import 'package:freezed_annotation/freezed_annotation.dart';

part 'deck_preset_management_data_source_model.freezed.dart';

@freezed
abstract class DeckPresetManagementDataSourceConfig
    with _$DeckPresetManagementDataSourceConfig {
  const factory DeckPresetManagementDataSourceConfig({
    required String fileExtension,
    required String directoryPath,
    required String indexFileTitle,
  }) = _DeckPresetManagementDataSourceConfig;
}
