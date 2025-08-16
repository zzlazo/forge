import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/presentation/async_state_builder/shared_async_state_builder.dart';
import '../application/provider/core_provider.dart';
import 'provider/initialize_app_presentation_provider.dart';

class InitializeAppScreen extends ConsumerWidget {
  const InitializeAppScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(initializeAppKeepAliveProvider);
    return SharedAsyncStateBuilder(
      asyncValue: ref.watch(initializeAppProvider),
      builder: (value) => SizedBox.shrink(),
    );
  }
}
