import 'package:drift/drift.dart';
import 'package:fintrack_pro/core/database/database.dart';
import 'package:fintrack_pro/features/users/data/models/admin_user_model.dart';
import 'package:fintrack_pro/features/auth/domain/entities/user.dart';
import 'package:fintrack_pro/features/users/domain/repositories/admin_user_repository.dart';

/// Source de données locale pour l'administration des utilisateurs
/// Fournit les opérations de base de données avec vérifications de permissions
abstract class AdminUserLocalDataSource {
  /// Récupère tous les utilisateurs avec leurs données d'administration
  Future<List<AdminUserModel>> getAllAdminUsers();

  /// Récupère un utilisateur par son ID avec données d'administration
  Future<AdminUserModel?> getAdminUserById(String id);

  /// Récupère un utilisateur par son email avec données d'administration
  Future<AdminUserModel?> getAdminUserByEmail(String email);

  /// Crée un nouvel utilisateur
  Future<AdminUserModel> createAdminUser(
    String email,
    String firstName,
    String lastName,
    UserRole role, {
    List<String>? assignedActivities,
    List<String>? permissions,
  });

  /// Met à jour un utilisateur
  Future<AdminUserModel> updateAdminUser(
    String id, {
    String? email,
    String? firstName,
    String? lastName,
    UserRole? role,
    List<String>? assignedActivities,
    List<String>? permissions,
    bool? isActive,
  });

  /// Supprime un utilisateur (soft delete)
  Future<void> deleteAdminUser(String id);

  /// Supprime définitivement un utilisateur
  Future<void> hardDeleteAdminUser(String id);

  /// Active/Désactive un utilisateur
  Future<void> toggleUserStatus(String id, bool isActive);

  /// Recherche des utilisateurs avec filtres
  Future<List<AdminUserModel>> searchUsers({
    String? query,
    UserRole? role,
    bool? isActive,
    DateTime? createdAfter,
    DateTime? createdBefore,
  });

  /// Calcule les statistiques des utilisateurs
  Future<UserStatistics> getUserStatistics();
}

/// Implémentation de la source de données locale pour l'administration
class AdminUserLocalDataSourceImpl implements AdminUserLocalDataSource {
  final AppDatabase database;

  AdminUserLocalDataSourceImpl(this.database);

  @override
  Future<List<AdminUserModel>> getAllAdminUsers() async {
    final users = await database.select(database.users).get();
    return users.map((userEntity) {
      final user = User.fromEntity(userEntity);
      return AdminUserModel.fromUser(user);
    }).toList();
  }

  @override
  Future<AdminUserModel?> getAdminUserById(String id) async {
    final query = database.select(database.users)
      ..where((tbl) => tbl.id.equals(id));

    final userEntity = await query.getSingleOrNull();
    if (userEntity == null) return null;

    final user = User.fromEntity(userEntity);
    return AdminUserModel.fromUser(user);
  }

  @override
  Future<AdminUserModel?> getAdminUserByEmail(String email) async {
    final query = database.select(database.users)
      ..where((tbl) => tbl.email.equals(email));

    final userEntity = await query.getSingleOrNull();
    if (userEntity == null) return null;

    final user = User.fromEntity(userEntity);
    return AdminUserModel.fromUser(user);
  }

  @override
  Future<AdminUserModel> createAdminUser(
    String email,
    String firstName,
    String lastName,
    UserRole role, {
    List<String>? assignedActivities,
    List<String>? permissions,
  }) async {
    final userEntity = UsersCompanion(
      email: Value(email),
      firstName: Value(firstName),
      lastName: Value(lastName),
      role: Value(role.value),
      password: const Value(''), // Sera défini lors de la réinitialisation du mot de passe
    );

    final id = await database.into(database.users).insert(userEntity);

    // Récupérer l'utilisateur créé
    final createdUser = await getAdminUserById(id.toString());
    if (createdUser == null) {
      throw Exception('Erreur lors de la création de l\'utilisateur');
    }

    // Mettre à jour avec les données d'administration
    return createdUser.copyWith(
      assignedActivities: assignedActivities ?? [],
      permissions: permissions ?? AdminUserModel.fromUser(createdUser.user).permissions,
    );
  }

  @override
  Future<AdminUserModel> updateAdminUser(
    String id, {
    String? email,
    String? firstName,
    String? lastName,
    UserRole? role,
    List<String>? assignedActivities,
    List<String>? permissions,
    bool? isActive,
  }) async {
    final updates = <Expression<bool>>[];

    final userEntity = UsersCompanion(
      id: Value(id),
      email: email != null ? Value(email) : const Value.absent(),
      firstName: firstName != null ? Value(firstName) : const Value.absent(),
      lastName: lastName != null ? Value(lastName) : const Value.absent(),
      role: role != null ? Value(role.value) : const Value.absent(),
      isActive: isActive != null ? Value(isActive) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );

    await (database.update(database.users)
      ..where((tbl) => tbl.id.equals(id)))
      .write(userEntity);

    // Récupérer l'utilisateur mis à jour
    final updatedUser = await getAdminUserById(id);
    if (updatedUser == null) {
      throw Exception('Utilisateur non trouvé après mise à jour');
    }

    // Mettre à jour avec les données d'administration
    return updatedUser.copyWith(
      assignedActivities: assignedActivities ?? updatedUser.assignedActivities,
      permissions: permissions ?? updatedUser.permissions,
    );
  }

  @override
  Future<void> deleteAdminUser(String id) async {
    await (database.update(database.users)
      ..where((tbl) => tbl.id.equals(id)))
      .write(const UsersCompanion(
        isActive: Value(false),
        updatedAt: Value.absent(),
      ));
  }

  @override
  Future<void> hardDeleteAdminUser(String id) async {
    await (database.delete(database.users)
      ..where((tbl) => tbl.id.equals(id)))
      .go();
  }

  @override
  Future<void> toggleUserStatus(String id, bool isActive) async {
    await (database.update(database.users)
      ..where((tbl) => tbl.id.equals(id)))
      .write(UsersCompanion(
        isActive: Value(isActive),
        updatedAt: Value(DateTime.now()),
      ));
  }

  @override
  Future<List<AdminUserModel>> searchUsers({
    String? query,
    UserRole? role,
    bool? isActive,
    DateTime? createdAfter,
    DateTime? createdBefore,
  }) async {
    var queryBuilder = database.select(database.users);

    // Appliquer les filtres
    if (query != null && query.isNotEmpty) {
      queryBuilder = queryBuilder
        ..where((tbl) =>
            tbl.firstName.contains(query) |
            tbl.lastName.contains(query) |
            tbl.email.contains(query));
    }

    if (role != null) {
      queryBuilder = queryBuilder
        ..where((tbl) => tbl.role.equals(role.value));
    }

    if (isActive != null) {
      queryBuilder = queryBuilder
        ..where((tbl) => tbl.isActive.equals(isActive));
    }

    if (createdAfter != null) {
      queryBuilder = queryBuilder
        ..where((tbl) => tbl.createdAt.isBiggerThanValue(createdAfter));
    }

    if (createdBefore != null) {
      queryBuilder = queryBuilder
        ..where((tbl) => tbl.createdAt.isSmallerThanValue(createdBefore));
    }

    final users = await queryBuilder.get();
    return users.map((userEntity) {
      final user = User.fromEntity(userEntity);
      return AdminUserModel.fromUser(user);
    }).toList();
  }

  @override
  Future<UserStatistics> getUserStatistics() async {
    final users = await database.select(database.users).get();

    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final thisWeek = now.subtract(const Duration(days: 7));

    final totalUsers = users.length;
    final activeUsers = users.where((u) => u.isActive).length;
    final inactiveUsers = totalUsers - activeUsers;

    final adminUsers = users.where((u) => u.role == UserRole.admin.value).length;
    final agentUsers = users.where((u) => u.role == UserRole.agent.value).length;
    final regularUsers = users.where((u) => u.role == UserRole.user.value).length;

    final usersByRole = {
      UserRole.admin: adminUsers,
      UserRole.agent: agentUsers,
      UserRole.user: regularUsers,
    };

    final usersCreatedThisMonth = users.where((u) => u.createdAt.isAfter(thisMonth)).length;
    final usersCreatedThisWeek = users.where((u) => u.createdAt.isAfter(thisWeek)).length;

    final lastUserCreated = users.isNotEmpty
        ? users.map((u) => u.createdAt).reduce((a, b) => a.isAfter(b) ? a : b)
        : null;

    return UserStatistics(
      totalUsers: totalUsers,
      activeUsers: activeUsers,
      inactiveUsers: inactiveUsers,
      adminUsers: adminUsers,
      agentUsers: agentUsers,
      regularUsers: regularUsers,
      usersByRole: usersByRole,
      usersCreatedThisMonth: usersCreatedThisMonth,
      usersCreatedThisWeek: usersCreatedThisWeek,
      lastUserCreated: lastUserCreated,
    );
  }
}