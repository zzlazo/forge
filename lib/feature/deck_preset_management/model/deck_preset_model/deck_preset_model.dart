import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/model/model_converter.dart';
import '../../../deck_management/model/deck_model/deck_model.dart';

part 'deck_preset_model.freezed.dart';
part 'deck_preset_model.g.dart';

@freezed
abstract class DeckPresetIndex with _$DeckPresetIndex {
  const DeckPresetIndex._();
  const factory DeckPresetIndex({
    String? deckPresetId,
    DeckType? deckType,

    @Rfc3339DateTimeConverter() DateTime? lastUpdate,
    String? title,
  }) = _DeckPresetIndex;

  factory DeckPresetIndex.fromJson(Map<String, Object?> json) =>
      _$DeckPresetIndexFromJson(json);

  bool isEqualWithId(DeckPresetIndex other) =>
      deckPresetId == other.deckPresetId;
}

@freezed
abstract class DeckPreset with _$DeckPreset {
  const DeckPreset._();
  const factory DeckPreset({
    @Default([]) List<DeckPresetItem> items,
    DeckPresetIndex? index,
  }) = _DeckPreset;

  factory DeckPreset.fromJson(Map<String, Object?> json) =>
      _$DeckPresetFromJson(json);

  bool isEqualWithId(DeckPreset other) =>
      index?.isEqualWithId(other.index!) ?? false;
}

@freezed
abstract class DeckPresetItem with _$DeckPresetItem {
  const factory DeckPresetItem({Suit? suit, int? number}) = _DeckPresetItem;

  factory DeckPresetItem.fromJson(Map<String, Object?> json) =>
      _$DeckPresetItemFromJson(json);
}
