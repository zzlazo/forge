import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../application/application_exception.dart';
import '../model/shared_model.dart';

part 'shared_provider.g.dart';

@Riverpod(keepAlive: true)
String directoryPath(Ref ref) {
  throw UnimplementedError('directoryPathProvider must be overridden in main');
}

@riverpod
SharedPreferencesWithCache sharedPreferences(Ref ref) {
  throw UnimplementedError();
}

@riverpod
class GlobalLoadingCounterNotifier extends _$GlobalLoadingCounterNotifier {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state = state + 1;
  }

  void decrement() {
    state = max(0, state - 1);
  }
}

@riverpod
class ApplicationExceptionStateNotifier
    extends _$ApplicationExceptionStateNotifier {
  @override
  ApplicationExceptionState build() {
    return ApplicationExceptionState();
  }

  void notify(ApplicationException exception) {
    state = state.copyWith(exception: exception, notifier: !state.notifier);
  }
}

void coordinateAsyncProviders(
  WidgetRef ref,
  List<ProviderListenable<AsyncValue>> providers, {
  void Function()? onData,
}) {
  final globalLoadingCounter = ref.read(
    globalLoadingCounterNotifierProvider.notifier,
  );
  final appExceptionNotifier = ref.read(
    applicationExceptionStateNotifierProvider.notifier,
  );
  for (final provider in providers) {
    ref.listen(provider, (previous, next) {
      if (next.isLoading && previous?.isLoading != true) {
        globalLoadingCounter.increment();
      } else if (!next.isLoading) {
        globalLoadingCounter.decrement();
      }
      if (next.hasError) {
        final exceptionToNotify = next.error is ApplicationException
            ? next.error as ApplicationException
            : InternalErrorException(
                'An unexpected error occurred: ${next.error}',
                next.error,
              );
        appExceptionNotifier.notify(exceptionToNotify);
      }
      if (providers.map((e) => ref.watch(e)).every((e) => e.hasValue)) {
        onData?.call();
      }
    });
  }
}
