// Configuration Database AppDatabase
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import 'tables/users.dart';
import 'tables/activities.dart';
import 'tables/activity_assignments.dart';
import 'tables/transactions.dart';
import 'tables/notifications.dart';

part 'database.g.dart';



@DriftDatabase(tables: [
  Users,
  Activities,
  ActivityAssignments,
  Transactions,
  Notifications
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([DatabaseConnection? connection])
      : super(connection ?? _openConnection());

  @override
  int get schemaVersion => 1;

  // Getters pour les DAOs
  $UsersTable get usersDao => users;
  $ActivitiesTable get activitiesDao => activities;
  $TransactionsTable get transactionsDao => transactions;
  $ActivityAssignmentsTable get activityAssignmentsDao => activityAssignments;
  $NotificationsTable get notificationsDao => notifications;

  @override
  MigrationStrategy get migration => migrationStrategy;

  static MigrationStrategy get migrationStrategy => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      // Créer les indexes après la création des tables
      await _createIndexes(m);
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Migrations futures ici
      }
    },
  );

  static Future<void> _createIndexes(Migrator m) async {
    // Indexes pour optimiser les performances
    await m.createIndex(
      Index('idx_users_email', 'CREATE INDEX idx_users_email ON users(email)'),
    );
    await m.createIndex(
      Index('idx_users_role', 'CREATE INDEX idx_users_role ON users(role)'),
    );
    await m.createIndex(
      Index('idx_activities_status', 'CREATE INDEX idx_activities_status ON activities(status)'),
    );
    await m.createIndex(
      Index('idx_activities_type', 'CREATE INDEX idx_activities_type ON activities(type)'),
    );
    await m.createIndex(
      Index('idx_transactions_status', 'CREATE INDEX idx_transactions_status ON transactions(status)'),
    );
    await m.createIndex(
      Index('idx_transactions_activity_id', 'CREATE INDEX idx_transactions_activity_id ON transactions(activity_id)'),
    );
    await m.createIndex(
      Index('idx_transactions_user_id', 'CREATE INDEX idx_transactions_user_id ON transactions(user_id)'),
    );
    await m.createIndex(
      Index('idx_transactions_date', 'CREATE INDEX idx_transactions_date ON transactions(transaction_date)'),
    );
    await m.createIndex(
      Index('idx_notifications_user_id', 'CREATE INDEX idx_notifications_user_id ON notifications(user_id)'),
    );
    await m.createIndex(
      Index('idx_notifications_is_read', 'CREATE INDEX idx_notifications_is_read ON notifications(is_read)'),
    );
    await m.createIndex(
      Index('idx_activity_assignments_activity_id', 'CREATE INDEX idx_activity_assignments_activity_id ON activity_assignments(activity_id)'),
    );
    await m.createIndex(
      Index('idx_activity_assignments_user_id', 'CREATE INDEX idx_activity_assignments_user_id ON activity_assignments(user_id)'),
    );
  }

  // Méthodes d'initialisation
  Future<void> init() async {
    // Vérifier si la base contient des données
    final userCount = await (select(users)..limit(1)).get().then((list) => list.length);
    if (userCount == 0) {
      await seedTestData();
    }
  }

  // Vérifier si la base est vide
  Future<bool> isEmpty() async {
    final userCount = await (select(users)..limit(1)).get().then((list) => list.length);
    return userCount == 0;
  }

  // Seed données de test
  Future<void> seedTestData() async {
    await batch((batch) async {
      // Utilisateurs de test
      final adminId = await _createTestUser(batch, 'admin@fintrack.pro', 'Admin', 'System', 'admin');
      final agentId = await _createTestUser(batch, 'agent@fintrack.pro', 'Agent', 'IT', 'agent');
      final userId = await _createTestUser(batch, 'user@fintrack.pro', 'User', 'Standard', 'user');

      // Activités de test
      final magasinCentralId = await _createTestActivity(batch, 'Magasin Central', 'magasin', adminId);
      final transportAId = await _createTestActivity(batch, 'Transport A', 'transport', adminId);
      final boutiqueBId = await _createTestActivity(batch, 'Boutique B', 'magasin', adminId);
      final transportBId = await _createTestActivity(batch, 'Transport B', 'transport', adminId);

      // Assignations d'activités
      await _createActivityAssignments(batch, magasinCentralId, [adminId, agentId, userId]);
      await _createActivityAssignments(batch, transportAId, [agentId, userId]);
      await _createActivityAssignments(batch, boutiqueBId, [userId]);
      await _createActivityAssignments(batch, transportBId, [agentId, userId]);

      // Transactions de test
      await _createTestTransactions(batch, magasinCentralId, adminId, agentId, userId);
      await _createTestTransactions(batch, transportAId, agentId, userId, null);
      await _createTestTransactions(batch, boutiqueBId, userId, null, null);
      await _createTestTransactions(batch, transportBId, agentId, userId, null);

      // Notifications de test
      await _createTestNotifications(batch, adminId, agentId, userId);
    });
  }

  Future<String> _createTestUser(Batch batch, String email, String firstName, String lastName, String role) async {
    final passwordHash = _hashPassword('password123'); // Mot de passe par défaut pour les tests
    final userId = const Uuid().v4();

    batch.insert(users, UsersCompanion.insert(
      id: Value(userId),
      email: email,
      password: passwordHash,
      role: role,
      firstName: firstName,
      lastName: lastName,
    ));

    return userId;
  }

  Future<String> _createTestActivity(Batch batch, String name, String type, String createdBy) async {
    final activityId = const Uuid().v4();

    batch.insert(activities, ActivitiesCompanion.insert(
      id: Value(activityId),
      name: name,
      description: Value('Activité de test pour $name'),
      type: type,
      status: 'active',
      createdBy: createdBy,
    ));

    return activityId;
  }

  Future<void> _createActivityAssignments(Batch batch, String activityId, List<String> userIds) async {
    for (final userId in userIds) {
      batch.insert(activityAssignments, ActivityAssignmentsCompanion.insert(
        activityId: activityId,
        userId: userId,
      ));
    }
  }

  Future<void> _createTestTransactions(Batch batch, String activityId, String userId1, String? userId2, String? userId3) async {
    final now = DateTime.now();
    
    // Première transaction
    batch.insert(transactions, TransactionsCompanion.insert(
      activityId: activityId,
      userId: userId1,
      type: 'recette',
      amount: 1500.50,
      status: 'completed',
      description: 'Vente de produits',
      transactionDate: now.subtract(const Duration(days: 5)),
    ));

    // Deuxième transaction
    batch.insert(transactions, TransactionsCompanion.insert(
      activityId: activityId,
      userId: userId1,
      type: 'depense',
      amount: 750.25,
      status: 'approved',
      description: 'Achat de fournitures',
      transactionDate: now.subtract(const Duration(days: 3)),
    ));

    // Troisième transaction
    batch.insert(transactions, TransactionsCompanion.insert(
      activityId: activityId,
      userId: userId1,
      type: 'depense',
      amount: 300.00,
      status: 'pending',
      description: 'Frais de transport',
      transactionDate: now.subtract(const Duration(days: 1)),
    ));

    if (userId2 != null) {
      batch.insert(transactions, TransactionsCompanion.insert(
        activityId: activityId,
        userId: userId2,
        type: 'recette',
        amount: 2200.75,
        status: 'completed',
        description: 'Services rendus',
        transactionDate: now.subtract(const Duration(days: 7)),
      ));
    }

    if (userId3 != null) {
      batch.insert(transactions, TransactionsCompanion.insert(
        activityId: activityId,
        userId: userId3,
        type: 'depense',
        amount: 1250.00,
        status: 'rejected',
        description: 'Achat équipement',
        transactionDate: now.subtract(const Duration(days: 2)),
        rejectionReason: Value('Budget insuffisant'),
      ));
    }
  }

  Future<void> _createTestNotifications(Batch batch, String adminId, String agentId, String userId) async {
    // Première notification
    batch.insert(notifications, NotificationsCompanion.insert(
      userId: adminId,
      type: 'new_user',
      title: 'Nouvel utilisateur inscrit',
      message: 'Un nouvel utilisateur s\'est inscrit sur la plateforme.',
      data: Value(jsonEncode({'userId': agentId})),
    ));

    // Deuxième notification
    batch.insert(notifications, NotificationsCompanion.insert(
      userId: agentId,
      type: 'pending_expense',
      title: 'Dépense en attente',
      message: 'Une nouvelle dépense nécessite votre approbation.',
      data: Value(jsonEncode({'amount': 300.00})),
    ));

    // Troisième notification
    batch.insert(notifications, NotificationsCompanion.insert(
      userId: userId,
      type: 'activity_closed',
      title: 'Activité clôturée',
      message: 'L\'activité Boutique B a été clôturée.',
      data: Value(jsonEncode({'activityId': 'boutique-b-id'})),
    ));

    // Quatrième notification
    batch.insert(notifications, NotificationsCompanion.insert(
      userId: adminId,
      type: 'alert_threshold',
      title: 'Seuil d\'alerte dépassé',
      message: 'Le budget mensuel est proche de la limite.',
      data: Value(jsonEncode({'threshold': 80, 'current': 85})),
    ));
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Méthodes utilitaires pour le développement
  Future<void> clearAllData() async {
    await batch((batch) {
      batch.deleteAll(notifications);
      batch.deleteAll(transactions);
      batch.deleteAll(activityAssignments);
      batch.deleteAll(activities);
      batch.deleteAll(users);
    });
  }

  // Méthodes de monitoring et maintenance
  Future<Map<String, int>> getDatabaseStats() async {
    final userCount = await (select(users)).get().then((list) => list.length);
    final activityCount = await (select(activities)).get().then((list) => list.length);
    final transactionCount = await (select(transactions)).get().then((list) => list.length);
    final notificationCount = await (select(notifications)).get().then((list) => list.length);

    return {
      'users': userCount,
      'activities': activityCount,
      'transactions': transactionCount,
      'notifications': notificationCount,
    };
  }

  Future<void> cleanupOldNotifications({int daysOld = 30}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    await (delete(notifications)..where((n) => n.createdAt.isSmallerThanValue(cutoffDate))).go();
  }

  Future<void> cleanupInactiveActivities({int daysInactive = 90}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysInactive));
    await (update(activities)
      ..where((a) => a.updatedAt.isSmallerThanValue(cutoffDate) & a.status.equals('active')))
      .write(const ActivitiesCompanion(status: Value('suspended')));
  }

  // Backup/Restore functionality
  Future<String> exportData() async {
    final data = <String, dynamic>{};
    data['users'] = await select(users).get();
    data['activities'] = await select(activities).get();
    data['activityAssignments'] = await select(activityAssignments).get();
    data['transactions'] = await select(transactions).get();
    data['notifications'] = await select(notifications).get();

    return jsonEncode(data);
  }

  Future<void> importData(String jsonData) async {
    final data = jsonDecode(jsonData) as Map<String, dynamic>;

    await clearAllData();

    await batch((batch) {
      if (data.containsKey('users')) {
        for (final user in data['users']) {
          batch.insert(users, UsersCompanion(
            id: Value(user['id']),
            email: Value(user['email']),
            password: Value(user['password']),
            role: Value(user['role']),
            firstName: Value(user['firstName']),
            lastName: Value(user['lastName']),
            avatarUrl: Value(user['avatarUrl']),
            createdAt: Value(DateTime.parse(user['createdAt'])),
            updatedAt: Value(DateTime.parse(user['updatedAt'])),
            isActive: Value(user['isActive']),
          ));
        }
      }
      // Similar for other tables...
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fintrack_pro.sqlite'));
    return NativeDatabase(file);
  });
}