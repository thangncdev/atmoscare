import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/core/theme.dart';
import 'presentation/core/router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AirCareApp(),
    ),
  );
}

class AirCareApp extends ConsumerWidget {
  const AirCareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'AirCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
