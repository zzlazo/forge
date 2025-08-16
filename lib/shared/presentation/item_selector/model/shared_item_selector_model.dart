import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_item_selector_model.freezed.dart';

@freezed
abstract class SharedItemSelectorState<T> with _$SharedItemSelectorState<T> {
  const SharedItemSelectorState._();
  const factory SharedItemSelectorState({
    required List<T> entries,
    T? selectedItem,
  }) = _SharedItemSelectorState<T>;
}

@freezed
abstract class SharedItemSelectorConfig<T> with _$SharedItemSelectorConfig<T> {
  const factory SharedItemSelectorConfig({
    required ProviderListenable<SharedItemSelectorState<T>> stateProvider,
    void Function(T? item)? onSelected,
    required String? Function(T item) label,
  }) = _SharedItemSelectorConfig<T>;
}
