import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/model/model_converter.dart';

part 'deck_model.freezed.dart';
part 'deck_model.g.dart';

@freezed
abstract class DeckIndex with _$DeckIndex {
  const DeckIndex._();
  const factory DeckIndex({
    String? deckId,
    @Rfc3339DateTimeConverter() DateTime? lastUpdate,
    String? title,
    DeckType? deckType,
  }) = _DeckIndex;

  factory DeckIndex.fromJson(Map<String, Object?> json) =>
      _$DeckIndexFromJson(json);

  bool isEqualWithId(DeckIndex other) => deckId == other.deckId;
}

@freezed
abstract class DeckData with _$DeckData {
  const DeckData._();
  const factory DeckData({
    @Default([]) List<CardData> cards,
    DeckIndex? index,
  }) = _DeckData;

  factory DeckData.fromJson(Map<String, Object?> json) =>
      _$DeckDataFromJson(json);

  bool isEqualWithId(DeckData other) =>
      index?.isEqualWithId(other.index!) ?? false;
}

@freezed
abstract class CardData with _$CardData {
  const factory CardData({CardIndex? index, String? text}) = _CardData;

  factory CardData.fromJson(Map<String, Object?> json) =>
      _$CardDataFromJson(json);
}

@freezed
abstract class CardIndex with _$CardIndex {
  const factory CardIndex({Suit? suit, int? number}) = _CardIndex;

  factory CardIndex.fromJson(Map<String, Object?> json) =>
      _$CardIndexFromJson(json);
}

enum Suit { club, diamond, heart, spade }

enum DeckType { playingCard, tarot }

class PlayingCardDatas {
  static const Map<Suit, String> suitSymbols = {
    Suit.club: '♣',
    Suit.diamond: '♦',
    Suit.heart: '♥',
    Suit.spade: '♠',
  };

  static const Map<int, String> numberSymbols = {
    1: 'A',
    2: '2',
    3: '3',
    4: '4',
    5: '5',
    6: '6',
    7: '7',
    8: '8',
    9: '9',
    10: '10',
    11: 'J',
    12: 'Q',
    13: 'K',
  };
}

@freezed
abstract class DeckFormModel with _$DeckFormModel {
  const factory DeckFormModel({
    String? deckTitle,
    @Default(DeckType.playingCard) DeckType deckType,
    @Default([]) List<CardData> cards,
    @Default(false) bool onceSaved,
  }) = _DeckFormModel;
}

@freezed
abstract class CardPainterState with _$CardPainterState {
  const factory CardPainterState({
    @Default(Colors.black) Color backGroundColor,
    @Default(Colors.white) Color textColor,
  }) = _CardPainterState;
}

@freezed
abstract class CardPainterItemConfig with _$CardPainterItemConfig {
  const factory CardPainterItemConfig({
    required String text,
    required Suit? suit,
    required int? number,
    required TextStyle? textStyle,
    required TextStyle? indexStyle,
    required CardPainterState state,
  }) = _CardPainterItemConfig;
}

@freezed
abstract class DeckExportProgress with _$DeckExportProgress {
  const DeckExportProgress._();
  const factory DeckExportProgress({
    @Default(0) int current,
    @Default(0) int total,
  }) = _DeckExportProgress;

  int get percent =>
      total > 0 && current > 0 ? (current / total * 100).floor() : 0;
}

@freezed
abstract class SelectDeckScreenState with _$SelectDeckScreenState {
  const factory SelectDeckScreenState({
    @Default(false) bool showCheckBox,
    @Default({}) Set<String> checkedDecks,
  }) = _SelectDeckScreenState;
}
