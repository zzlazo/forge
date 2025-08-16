import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../feature/deck_preset_management/application/provider/deck_preset_management_provider.dart';
import '../../../shared/provider/shared_provider.dart';
import '../../../shared/shared_utility.dart';

part 'core_provider.g.dart';

@riverpod
bool isAppInitializedWhenOpened(Ref ref) {
  throw UnimplementedError();
}

@riverpod
class IsAppInitializedNotifier extends _$IsAppInitializedNotifier {
  @override
  bool build() {
    return ref.read(isAppInitializedWhenOpenedProvider);
  }

  void set(bool value) => state = value;
}

@riverpod
Future<void> initializeApp(Ref ref) async {
  await ref
      .read(deckPresetManagementRepositoryProvider)
      .saveInitialDeckPresets();
}

@riverpod
void listenInitialize(Ref ref) {
  ref.listen(initializeAppProvider, (previous, next) async {
    switch (next) {
      case AsyncData _:
        ref.read(isAppInitializedNotifierProvider.notifier).set(true);
        await ref
            .read(sharedPreferencesProvider)
            .setBool(SharedPrefKey.isAppInitialized.prefKey, true);
    }
  });
}
