import 'package:freezed_annotation/freezed_annotation.dart';

import '../application/application_exception.dart';

part 'shared_model.freezed.dart';

@freezed
abstract class ApplicationExceptionState with _$ApplicationExceptionState {
  const factory ApplicationExceptionState({
    ApplicationException? exception,
    @Default(true) bool notifier,
  }) = _ApplicationExceptionState;
}

enum DialogAction { cancel, ok }
