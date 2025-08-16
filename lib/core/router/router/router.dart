import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/provider/core_provider.dart';
import 'page.dart';
import 'screens.dart';

part 'router.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<DeleteDeckRoute>(path: "delete-deck"),
    TypedGoRoute<UpdateDeckRoute>(path: 'update-deck'),
    TypedGoRoute<CreateDeckRoute>(path: 'create-deck'),
    TypedGoRoute<ExportDeckRoute>(
      path: "export-deck",
      routes: [
        TypedGoRoute<ExportDeckConfigRoute>(path: "export-deck-config"),
        TypedGoRoute<SaveDeckImageRoute>(path: "save-deck-image"),
      ],
    ),
  ],
)
class HomeRoute extends GoRouteData with _$HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SelectDeckScreen();
}

class UpdateDeckRoute extends GoRouteData with _$UpdateDeckRoute {
  const UpdateDeckRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const UpdateDeckScreen();
}

class CreateDeckRoute extends GoRouteData with _$CreateDeckRoute {
  const CreateDeckRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CreateDeckScreen();
}

class ExportDeckRoute extends GoRouteData with _$ExportDeckRoute {
  const ExportDeckRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ExportDeckScreen();
}

class ExportDeckConfigRoute extends GoRouteData with _$ExportDeckConfigRoute {
  const ExportDeckConfigRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return DialogPage<void>(builder: (context) => ExportDeckConfigDialog());
  }
}

class SaveDeckImageRoute extends GoRouteData with _$SaveDeckImageRoute {
  const SaveDeckImageRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return DialogPage<void>(builder: (context) => SaveDeckDialog());
  }
}

class DeleteDeckRoute extends GoRouteData with _$DeleteDeckRoute {
  const DeleteDeckRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return DialogPage<void>(builder: (context) => DeleteDeckDialog());
  }
}

@TypedGoRoute<InitializeAppRoute>(path: '/initialize')
class InitializeAppRoute extends GoRouteData with _$InitializeAppRoute {
  const InitializeAppRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const InitializeAppScreen();
  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    if (ProviderScope.containerOf(
      context,
    ).read(isAppInitializedNotifierProvider)) {
      return HomeRoute().location;
    }
    return null;
  }
}

FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
  final bool needInitialize =
      ProviderScope.containerOf(
            context,
          ).read(isAppInitializedNotifierProvider) ==
          false &&
      state.path != InitializeAppRoute().location;

  if (needInitialize) {
    return InitializeAppRoute().location;
  }

  return null;
}
