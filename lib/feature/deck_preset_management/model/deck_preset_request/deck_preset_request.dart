import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../deck_management/model/deck_model/deck_model.dart';
import '../deck_preset_model/deck_preset_model.dart';

part 'deck_preset_request.freezed.dart';
part 'deck_preset_request.g.dart';

@freezed
abstract class CreateDeckPresetRequest with _$CreateDeckPresetRequest {
  const factory CreateDeckPresetRequest({
    required List<CreateDeckPresetRequestItem> items,
  }) = _CreateDeckPresetRequest;
}

@freezed
abstract class CreateDeckPresetRequestItem with _$CreateDeckPresetRequestItem {
  const factory CreateDeckPresetRequestItem({
    required String? deckPresetTitle,
    required DeckType? deckType,
    required List<DeckPresetItem> items,
  }) = _CreateDeckPresetRequestItem;
}

@freezed
abstract class UpdateDeckPresetRequest with _$UpdateDeckPresetRequest {
  const factory UpdateDeckPresetRequest({
    required List<UpdateDeckPresetRequestItem> items,
  }) = _UpdateDeckPresetRequest;
}

@freezed
abstract class UpdateDeckPresetRequestItem with _$UpdateDeckPresetRequestItem {
  const factory UpdateDeckPresetRequestItem({
    required String deckPresetId,
    required String? deckPresetTitle,
    required DeckType? deckType,
    required List<DeckPresetItem> items,
  }) = _UpdateDeckPresetRequestItem;
}

@freezed
abstract class GetDeckPresetRequest with _$GetDeckPresetRequest {
  const factory GetDeckPresetRequest({required String deckId}) =
      _GetDeckPresetRequest;

  factory GetDeckPresetRequest.fromJson(Map<String, dynamic> json) =>
      _$GetDeckPresetRequestFromJson(json);
}

@freezed
abstract class DeleteDeckPresetRequest with _$DeleteDeckPresetRequest {
  const factory DeleteDeckPresetRequest({required String deckId}) =
      _DeleteDeckPresetRequest;

  factory DeleteDeckPresetRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteDeckPresetRequestFromJson(json);
}
