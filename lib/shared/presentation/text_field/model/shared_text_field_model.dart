import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_text_field_model.freezed.dart';

@freezed
abstract class SharedTextFieldConfig with _$SharedTextFieldConfig {
  const factory SharedTextFieldConfig({
    String? hintText,
    required ProviderListenable<String> stateProvider,
    required void Function(String text)? onChanged,
    @Default(1) int maxLines,
  }) = _SharedTextFieldConfig;
}
