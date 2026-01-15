import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/routing/app_router.dart';
import 'src/theme/app_theme.dart';
import 'src/shared/services/notification_service.dart';

void main() async {
  // Ensure binding initialized if needed for async start (e.g. Hive/Isar init later)
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize container to access services before app root if strictly needed,
  // or just use Consumer in App. But for async init, doing it here is cleaner.
  final container = ProviderContainer();
  await container.read(notificationServiceProvider).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ZyphastioApp(),
    ),
  );
}

class ZyphastioApp extends ConsumerWidget {
  const ZyphastioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Zyphastio',
      debugShowCheckedModeBanner: false,
      // Theming - Enforced Dark Mode
      theme: AppTheme
          .darkTheme, // Use dark theme logic even for 'light' slot to be safe, or just darkTheme
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      // Routing
      routerConfig: goRouter,
    );
  }
}
