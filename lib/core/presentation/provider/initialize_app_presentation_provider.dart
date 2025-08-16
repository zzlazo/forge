import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application/provider/core_provider.dart';

part 'initialize_app_presentation_provider.g.dart';

@riverpod
void initializeAppKeepAlive(Ref ref) {
  ref.watch(listenInitializeProvider);
}
