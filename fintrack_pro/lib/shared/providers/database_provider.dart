import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database.dart';
import 'database_providers.dart';

// Provider pour l'instance de base de données - alias pour databaseProvider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return ref.watch(databaseProvider);
});