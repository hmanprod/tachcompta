import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database.dart';

// Provider pour l'instance de base de données
final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  // Initialiser la base de données (si nécessaire, comme seeder les données)
  // Nous pouvons appeler init() ici si nécessaire, mais pour éviter les appels asynchrones,
  // il est préférable de le faire dans le main ou dans un autre provider

  return database;
});

// Provider pour initialiser la base de données
final databaseInitializerProvider = FutureProvider<void>((ref) async {
  final database = ref.watch(databaseProvider);
  await database.init();
});