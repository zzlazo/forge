import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../application/provider/core_provider.dart';
import '../router/router.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final ValueNotifier refreshListenable = ValueNotifier(true);
  ref.watch(refreshRouterProvider);
  final sub = ref.listen(routeRefreshNotifierProvider, (previous, next) {
    refreshListenable.value = !refreshListenable.value;
  });

  ref.onDispose(() => sub.close());

  final router = GoRouter(
    routes: $appRoutes,
    debugLogDiagnostics: true,
    refreshListenable: refreshListenable,
    redirect: redirect,
  );
  return router;
}

@riverpod
void refreshRouter(Ref ref) {
  ref.listen(isAppInitializedNotifierProvider, (previous, next) {
    ref.read(routeRefreshNotifierProvider.notifier).refresh();
  });
}

@riverpod
class RouteRefreshNotifier extends _$RouteRefreshNotifier {
  @override
  bool build() {
    return true;
  }

  void refresh() => state = !state;
}
