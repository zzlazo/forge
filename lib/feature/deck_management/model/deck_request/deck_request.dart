import 'package:freezed_annotation/freezed_annotation.dart';

import '../deck_model/deck_model.dart';

part 'deck_request.freezed.dart';
part 'deck_request.g.dart';

@freezed
abstract class CreateDeckRequest with _$CreateDeckRequest {
  const factory CreateDeckRequest({
    required List<CreateDeckRequestItem> items,
  }) = _CreateDeckRequest;
}

@freezed
abstract class CreateDeckRequestItem with _$CreateDeckRequestItem {
  const factory CreateDeckRequestItem({
    required String deckTitle,
    required DeckType deckType,
    required List<CardData> cards,
  }) = _CreateDeckRequestItem;
}

@freezed
abstract class UpdateDeckRequest with _$UpdateDeckRequest {
  const factory UpdateDeckRequest({
    required List<UpdateDeckRequestItem> items,
  }) = _UpdateDeckRequest;
}

@freezed
abstract class UpdateDeckRequestItem with _$UpdateDeckRequestItem {
  const factory UpdateDeckRequestItem({
    required String deckId,
    required String deckTitle,
    required DeckType deckType,
    required List<CardData> cards,
  }) = _UpdateDeckRequestItem;
}

@freezed
abstract class GetDeckRequest with _$GetDeckRequest {
  const factory GetDeckRequest({required String deckId}) = _GetDeckRequest;

  factory GetDeckRequest.fromJson(Map<String, dynamic> json) =>
      _$GetDeckRequestFromJson(json);
}

@freezed
abstract class DeleteDeckRequest with _$DeleteDeckRequest {
  const factory DeleteDeckRequest({required Set<String> deckIds}) =
      _DeleteDeckRequest;

  factory DeleteDeckRequest.fromJson(Map<String, dynamic> json) =>
      _$DeleteDeckRequestFromJson(json);
}
