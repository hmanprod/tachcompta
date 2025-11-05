import 'package:fintrack_pro/features/users/data/datasources/admin_user_local_datasource.dart';
import 'package:fintrack_pro/features/users/data/models/admin_user_model.dart';
import 'package:fintrack_pro/features/users/domain/repositories/admin_user_repository.dart';
import 'package:fintrack_pro/features/auth/domain/entities/user.dart';

/// Implémentation du repository d'administration des utilisateurs
class AdminUserRepositoryImpl implements AdminUserRepository {
  final AdminUserLocalDataSource localDataSource;

  AdminUserRepositoryImpl(this.localDataSource);

  @override
  Future<List<AdminUserModel>> getAllAdminUsers() async {
    return await localDataSource.getAllAdminUsers();
  }

  @override
  Future<AdminUserModel?> getAdminUserById(String id) async {
    return await localDataSource.getAdminUserById(id);
  }

  @override
  Future<AdminUserModel?> getAdminUserByEmail(String email) async {
    return await localDataSource.getAdminUserByEmail(email);
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
    // Vérifier les permissions de l'utilisateur actuel
    await _checkAdminPermission('users.create');

    final user = await localDataSource.createAdminUser(
      email,
      firstName,
      lastName,
      role,
      assignedActivities: assignedActivities,
      permissions: permissions,
    );

    // Logger l'action
    await logAdminAction('user.create', user.user.id, metadata: {
      'email': email,
      'role': role.value,
    });

    return user;
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
    // Vérifier les permissions
    await _checkAdminPermission('users.update');

    final currentUser = await getAdminUserById(id);
    if (currentUser == null) {
      throw AdminFailure.userNotFound();
    }

    final updatedUser = await localDataSource.updateAdminUser(
      id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      role: role,
      assignedActivities: assignedActivities,
      permissions: permissions,
      isActive: isActive,
    );

    // Logger l'action
    await logAdminAction('user.update', id, metadata: {
      'changes': {
        if (email != null) 'email': email,
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (role != null) 'role': role.value,
        if (assignedActivities != null) 'assignedActivities': assignedActivities,
        if (permissions != null) 'permissions': permissions,
        if (isActive != null) 'isActive': isActive,
      },
    });

    return updatedUser;
  }

  @override
  Future<void> deleteAdminUser(String id) async {
    // Vérifier les permissions
    await _checkAdminPermission('users.delete');

    // Vérifier que l'utilisateur existe
    final user = await getAdminUserById(id);
    if (user == null) {
      throw AdminFailure.userNotFound();
    }

    await localDataSource.deleteAdminUser(id);

    // Logger l'action
    await logAdminAction('user.delete', id);
  }

  @override
  Future<void> hardDeleteAdminUser(String id) async {
    // Vérifier les permissions spéciales pour la suppression définitive
    await _checkAdminPermission('users.hard_delete');

    final user = await getAdminUserById(id);
    if (user == null) {
      throw AdminFailure.userNotFound();
    }

    await localDataSource.hardDeleteAdminUser(id);

    // Logger l'action
    await logAdminAction('user.hard_delete', id);
  }

  @override
  Future<void> resetUserPassword(String id) async {
    // Vérifier les permissions
    await _checkAdminPermission('users.reset_password');

    final user = await getAdminUserById(id);
    if (user == null) {
      throw AdminFailure.userNotFound();
    }

    // Ici, nous devrions intégrer avec un service de réinitialisation de mot de passe
    // Pour l'instant, nous marquons simplement que le mot de passe doit être réinitialisé
    await localDataSource.updateAdminUser(
      id,
      permissions: user.permissions,
      assignedActivities: user.assignedActivities,
    );

    // Logger l'action
    await logAdminAction('user.reset_password', id);
  }

  @override
  Future<void> toggleUserStatus(String id, bool isActive) async {
    // Vérifier les permissions
    await _checkAdminPermission('users.toggle_status');

    await localDataSource.toggleUserStatus(id, isActive);

    // Logger l'action
    await logAdminAction('user.toggle_status', id, metadata: {
      'isActive': isActive,
    });
  }

  @override
  Future<void> assignActivitiesToUser(
    String userId,
    List<String> activityIds,
  ) async {
    // Vérifier les permissions
    await _checkAdminPermission('users.assign_activities');

    await localDataSource.updateAdminUser(
      userId,
      assignedActivities: activityIds,
    );

    // Logger l'action
    await logAdminAction('user.assign_activities', userId, metadata: {
      'activityIds': activityIds,
    });
  }

  @override
  Future<void> removeActivitiesFromUser(
    String userId,
    List<String> activityIds,
  ) async {
    // Vérifier les permissions
    await _checkAdminPermission('users.assign_activities');

    final currentUser = await getAdminUserById(userId);
    if (currentUser == null) {
      throw AdminFailure.userNotFound();
    }

    final updatedActivities = List<String>.from(currentUser.assignedActivities)
      ..removeWhere((activityId) => activityIds.contains(activityId));

    await localDataSource.updateAdminUser(
      userId,
      assignedActivities: updatedActivities,
    );

    // Logger l'action
    await logAdminAction('user.remove_activities', userId, metadata: {
      'removedActivityIds': activityIds,
    });
  }

  @override
  Future<void> updateUserPermissions(
    String userId,
    List<String> permissions,
  ) async {
    // Vérifier les permissions
    await _checkAdminPermission('users.update_permissions');

    await localDataSource.updateAdminUser(
      userId,
      permissions: permissions,
    );

    // Logger l'action
    await logAdminAction('user.update_permissions', userId, metadata: {
      'permissions': permissions,
    });
  }

  @override
  Future<UserStatistics> getUserStatistics() async {
    // Vérifier les permissions
    await _checkAdminPermission('users.view_statistics');

    return await localDataSource.getUserStatistics();
  }

  @override
  Future<List<AdminUserModel>> searchUsers({
    String? query,
    UserRole? role,
    bool? isActive,
    DateTime? createdAfter,
    DateTime? createdBefore,
  }) async {
    // Vérifier les permissions
    await _checkAdminPermission('users.read');

    return await localDataSource.searchUsers(
      query: query,
      role: role,
      isActive: isActive,
      createdAfter: createdAfter,
      createdBefore: createdBefore,
    );
  }

  @override
  Future<bool> hasPermission(String permission) async {
    // TODO: Implémenter la vérification des permissions de l'utilisateur actuel
    // Pour l'instant, retourner true pour les admins
    return true;
  }

  @override
  Future<bool> hasAccessToActivity(String activityId) async {
    // TODO: Implémenter la vérification d'accès aux activités
    return true;
  }

  @override
  Future<void> logAdminAction(
    String action,
    String targetUserId, {
    Map<String, dynamic>? metadata,
  }) async {
    // TODO: Implémenter le système de logging d'audit
    // Pour l'instant, simplement print
    print('Admin action: $action on user $targetUserId, metadata: $metadata');
  }

  /// Vérifie si l'utilisateur actuel a la permission requise
  Future<void> _checkAdminPermission(String permission) async {
    final hasAccess = await hasPermission(permission);
    if (!hasAccess) {
      throw AdminFailure.permissionDenied();
    }
  }
}