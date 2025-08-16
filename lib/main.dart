import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:path_provider/path_provider.dart";
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_theme/provider/app_theme_provider.dart';
import 'core/application/provider/core_provider.dart';
import 'core/router/provider/router_provider.dart';
import 'shared/presentation/loading_indicator/shared_loading_indicator.dart';
import 'shared/presentation/snack_bar/shared_snack_bar.dart';
import 'shared/provider/shared_provider.dart';
import 'shared/shared_utility.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferencesWithCache sharedPreferencesWithCache =
      await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(
          allowList: SharedPrefKey.values.map((e) => e.prefKey).toSet(),
        ),
      );
  final bool isInitialized =
      sharedPreferencesWithCache.getBool(
        SharedPrefKey.isAppInitialized.prefKey,
      ) ==
      true;

  final Directory localDirectory = await getApplicationDocumentsDirectory();
  final String localPath = localDirectory.path;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferencesWithCache),
        isAppInitializedWhenOpenedProvider.overrideWithValue(isInitialized),
        directoryPathProvider.overrideWithValue(localPath),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      theme: ref.watch(themeDataProvider),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => _GlobalWidget(child: child),
    );
  }
}

class _GlobalWidget extends ConsumerWidget {
  const _GlobalWidget({
    // ignore: unused_element_parameter
    super.key,
    required this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(applicationExceptionStateNotifierProvider, (previous, next) {
      ScaffoldMessenger.of(context).showSnackBar(
        SharedErrorSnackBar(message: next.exception?.message ?? "Error"),
      );
    });
    return Stack(
      children: [
        if (child != null) child!,
        if (ref.watch(globalLoadingCounterNotifierProvider) > 0)
          _LoadingOverlay(),
      ],
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay({
    // ignore: unused_element_parameter
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(dismissible: false),
        Center(child: SharedLoadingIndicator()),
      ],
    );
  }
}
