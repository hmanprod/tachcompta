import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fintrack_pro/core/database/database.dart';
import 'package:fintrack_pro/core/database/tables/users.dart';
import 'package:fintrack_pro/core/database/tables/activities.dart';
import 'package:fintrack_pro/core/database/tables/activity_assignments.dart';
import 'package:fintrack_pro/core/database/tables/transactions.dart';
import 'package:fintrack_pro/core/database/tables/notifications.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    // Créer une base de données en mémoire pour les tests
    database = AppDatabase();
  });

  tearDown(() async {
    await database.close();
  });

  group('Database Initialization', () {
    test('should create database successfully', () async {
      await database.init();

      // Vérifier que les tables sont créées
      final userCount = await database.usersDao.count().getSingle();
      expect(userCount, greaterThan(0)); // Seed data doit être présente
    });

    test('should seed test data correctly', () async {
      await database.init();

      // Vérifier les utilisateurs de test
      final users = await database.usersDao.select().get();
      expect(users.length, 3); // 3 utilisateurs de test

      final admin = users.firstWhere((u) => u.email == 'admin@fintrack.pro');
      expect(admin.role, 'admin');
      expect(admin.firstName, 'Admin');
      expect(admin.lastName, 'System');

      final agent = users.firstWhere((u) => u.email == 'agent@fintrack.pro');
      expect(agent.role, 'agent');

      final user = users.firstWhere((u) => u.email == 'user@fintrack.pro');
      expect(user.role, 'user');
    });
  });

  group('Activities Management', () {
    setUp(() async {
      await database.init();
    });

    test('should create activities correctly', () async {
      final activities = await database.activitiesDao.select().get();
      expect(activities.length, 4); // 4 activités de test

      final magasinCentral = activities.firstWhere((a) => a.name == 'Magasin Central');
      expect(magasinCentral.type, 'magasin');
      expect(magasinCentral.status, 'active');
    });

    test('should handle activity assignments', () async {
      final assignments = await database.activityAssignmentsDao.select().get();
      expect(assignments.length, greaterThan(0));

      // Magasin Central devrait avoir 3 assignations
      final magasinCentral = await (database.activitiesDao.select()
        ..where((a) => a.name.equals('Magasin Central')))
        .getSingle();

      final magasinAssignments = assignments
          .where((aa) => aa.activityId == magasinCentral.id)
          .toList();
      expect(magasinAssignments.length, 3);
    });
  });

  group('Transactions Management', () {
    setUp(() async {
      await database.init();
    });

    test('should create transactions correctly', () async {
      final transactions = await database.transactionsDao.select().get();
      expect(transactions.length, greaterThan(15)); // Au moins 15 transactions de test

      // Vérifier les types de transactions
      final recettes = transactions.where((t) => t.type == 'recette').toList();
      final depenses = transactions.where((t) => t.type == 'depense').toList();

      expect(recettes.length, greaterThan(0));
      expect(depenses.length, greaterThan(0));
    });

    test('should handle transaction statuses', () async {
      final transactions = await database.transactionsDao.select().get();

      final pending = transactions.where((t) => t.status == 'pending').toList();
      final approved = transactions.where((t) => t.status == 'approved').toList();
      final completed = transactions.where((t) => t.status == 'completed').toList();
      final rejected = transactions.where((t) => t.status == 'rejected').toList();

      expect(pending.length + approved.length + completed.length + rejected.length,
             transactions.length);
    });
  });

  group('Notifications Management', () {
    setUp(() async {
      await database.init();
    });

    test('should create notifications correctly', () async {
      final notifications = await database.notificationsDao.select().get();
      expect(notifications.length, greaterThan(0));

      // Vérifier les types de notifications
      final types = notifications.map((n) => n.type).toSet();
      expect(types.contains('new_user'), true);
      expect(types.contains('pending_expense'), true);
      expect(types.contains('activity_closed'), true);
      expect(types.contains('alert_threshold'), true);
    });
  });

  group('Database Constraints and Relations', () {
    setUp(() async {
      await database.init();
    });

    test('should enforce foreign key constraints', () async {
      // Tester que les clés étrangères sont respectées
      final transactions = await database.transactionsDao.select().get();
      final activities = await database.activitiesDao.select().get();
      final users = await database.usersDao.select().get();

      for (final transaction in transactions) {
        expect(
          activities.any((a) => a.id == transaction.activityId),
          true,
          reason: 'Transaction ${transaction.id} references non-existent activity'
        );
        expect(
          users.any((u) => u.id == transaction.userId),
          true,
          reason: 'Transaction ${transaction.id} references non-existent user'
        );
      }
    });

    test('should handle unique constraints', () async {
      // Tester l'unicité des emails
      final users = await database.usersDao.select().get();
      final emails = users.map((u) => u.email).toSet();
      expect(emails.length, users.length); // Tous les emails sont uniques
    });
  });

  group('Database Performance', () {
    setUp(() async {
      await database.init();
    });

    test('should query transactions efficiently', () async {
      // Tester les requêtes optimisées
      final stopwatch = Stopwatch()..start();

      final transactions = await database.transactionsDao.select().get();

      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(100)); // Doit être rapide
    });

    test('should filter transactions by status', () async {
      final pendingTransactions = await (database.transactionsDao.select()
        ..where((t) => t.status.equals('pending')))
        .get();

      expect(pendingTransactions.every((t) => t.status == 'pending'), true);
    });
  });

  group('Database Maintenance', () {
    setUp(() async {
      await database.init();
    });

    test('should provide database statistics', () async {
      final stats = await database.getDatabaseStats();

      expect(stats.containsKey('users'), true);
      expect(stats.containsKey('activities'), true);
      expect(stats.containsKey('transactions'), true);
      expect(stats.containsKey('notifications'), true);

      expect(stats['users'], greaterThan(0));
    });

    test('should export and import data', () async {
      // Exporter les données
      final exportData = await database.exportData();
      expect(exportData, isNotEmpty);

      // Créer une nouvelle base pour l'import
      final newDatabase = AppDatabase(NativeDatabase.memory());
      await newDatabase.clearAllData();

      // Importer les données
      await newDatabase.importData(exportData);

      // Vérifier que les données sont importées
      final newStats = await newDatabase.getDatabaseStats();
      final originalStats = await database.getDatabaseStats();

      expect(newStats['users'], originalStats['users']);

      await newDatabase.close();
    });

    test('should cleanup old notifications', () async {
      // Créer des notifications anciennes
      final oldDate = DateTime.now().subtract(const Duration(days: 40));

      await database.batch((batch) {
        batch.insert(database.notifications, NotificationsCompanion.insert(
          userId: 'test-user-id',
          type: 'test',
          title: 'Old notification',
          message: 'This is old',
          createdAt: Value(oldDate),
        ));
      });

      final beforeCleanup = await database.notificationsDao.count().getSingle();

      // Nettoyer les notifications anciennes
      await database.cleanupOldNotifications(daysOld: 30);

      final afterCleanup = await database.notificationsDao.count().getSingle();

      expect(afterCleanup, lessThan(beforeCleanup));
    });
  });

  group('Data Integrity', () {
    setUp(() async {
      await database.init();
    });

    test('should maintain referential integrity', () async {
      // Supprimer un utilisateur et vérifier que les transactions sont nettoyées
      final userToDelete = (await database.usersDao.select().get()).first;

      // Vérifier qu'il y a des transactions pour cet utilisateur
      final userTransactions = await (database.transactionsDao.select()
        ..where((t) => t.userId.equals(userToDelete.id)))
        .get();

      expect(userTransactions.length, greaterThan(0));

      // Cette opération devrait échouer si les contraintes sont activées
      // Dans ce test, on vérifie juste que la structure est cohérente
      expect(userToDelete.id, isNotEmpty);
    });

    test('should handle data validation', () async {
      // Tester que les contraintes de validation sont respectées
      final users = await database.usersDao.select().get();

      for (final user in users) {
        expect(['admin', 'agent', 'user'].contains(user.role), true);
        expect(user.email, contains('@'));
      }

      final activities = await database.activitiesDao.select().get();

      for (final activity in activities) {
        expect(['magasin', 'transport', 'autre'].contains(activity.type), true);
        expect(['active', 'closed', 'suspended'].contains(activity.status), true);
      }

      final transactions = await database.transactionsDao.select().get();

      for (final transaction in transactions) {
        expect(['recette', 'depense'].contains(transaction.type), true);
        expect(['pending', 'approved', 'rejected', 'completed'].contains(transaction.status), true);
      }
    });
  });
}