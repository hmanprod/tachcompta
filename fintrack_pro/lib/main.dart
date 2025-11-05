import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/database/database.dart';
import 'shared/providers/database_providers.dart';
import 'shared/providers/repository_providers.dart';
import 'routes/app_router.dart';
import 'styles/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        databaseProvider.overrideWithValue(AppDatabase()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observer l'initialisation de la base de données
    final databaseInit = ref.watch(databaseInitializerProvider);

    return databaseInit.when(
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Erreur lors de l\'initialisation: $error'),
          ),
        ),
      ),
      data: (_) {
        final router = AppRouter.createRouter(ref);
        return MaterialApp.router(
          title: 'FinTrack Pro',
          theme: FinTrackTheme.lightTheme,
          darkTheme: FinTrackTheme.darkTheme,
          themeMode: ThemeMode.light,
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
        );
      },
    );
  }
}
