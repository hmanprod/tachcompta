import 'package:fintrack_pro/features/users/data/models/admin_user_model.dart';
import 'package:fintrack_pro/features/auth/domain/entities/user.dart';

/// Interface pour le repository d'administration des utilisateurs
/// Fournit des opérations CRUD avec vérifications de permissions avancées
abstract class AdminUserRepository {
  /// Récupère tous les utilisateurs avec leurs données d'administration
  Future<List<AdminUserModel>> getAllAdminUsers();

  /// Récupère un utilisateur par son ID avec données d'administration
  Future<AdminUserModel?> getAdminUserById(String id);

  /// Récupère un utilisateur par son email avec données d'administration
  Future<AdminUserModel?> getAdminUserByEmail(String email);

  /// Crée un nouvel utilisateur avec données d'administration
  Future<AdminUserModel> createAdminUser(
    String email,
    String firstName,
    String lastName,
    UserRole role, {
    List<String>? assignedActivities,
    List<String>? permissions,
  });

  /// Met à jour un utilisateur avec données d'administration
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

  /// Réinitialise le mot de passe d'un utilisateur
  Future<void> resetUserPassword(String id);

  /// Active/Désactive un utilisateur
  Future<void> toggleUserStatus(String id, bool isActive);

  /// Assigne des activités à un utilisateur
  Future<void> assignActivitiesToUser(
    String userId,
    List<String> activityIds,
  );

  /// Retire des activités d'un utilisateur
  Future<void> removeActivitiesFromUser(
    String userId,
    List<String> activityIds,
  );

  /// Met à jour les permissions d'un utilisateur
  Future<void> updateUserPermissions(
    String userId,
    List<String> permissions,
  );

  /// Récupère les statistiques des utilisateurs
  Future<UserStatistics> getUserStatistics();

  /// Recherche des utilisateurs avec filtres
  Future<List<AdminUserModel>> searchUsers({
    String? query,
    UserRole? role,
    bool? isActive,
    DateTime? createdAfter,
    DateTime? createdBefore,
  });

  /// Vérifie si l'utilisateur actuel a une permission spécifique
  Future<bool> hasPermission(String permission);

  /// Vérifie si l'utilisateur actuel peut accéder à une activité
  Future<bool> hasAccessToActivity(String activityId);

  /// Enregistre une action d'administration pour l'audit
  Future<void> logAdminAction(
    String action,
    String targetUserId, {
    Map<String, dynamic>? metadata,
  });
}

/// Statistiques des utilisateurs pour l'administration
class UserStatistics {
  final int totalUsers;
  final int activeUsers;
  final int inactiveUsers;
  final int adminUsers;
  final int agentUsers;
  final int regularUsers;
  final Map<UserRole, int> usersByRole;
  final int usersCreatedThisMonth;
  final int usersCreatedThisWeek;
  final DateTime? lastUserCreated;

  const UserStatistics({
    required this.totalUsers,
    required this.activeUsers,
    required this.inactiveUsers,
    required this.adminUsers,
    required this.agentUsers,
    required this.regularUsers,
    required this.usersByRole,
    required this.usersCreatedThisMonth,
    required this.usersCreatedThisWeek,
    this.lastUserCreated,
  });

  factory UserStatistics.empty() {
    return const UserStatistics(
      totalUsers: 0,
      activeUsers: 0,
      inactiveUsers: 0,
      adminUsers: 0,
      agentUsers: 0,
      regularUsers: 0,
      usersByRole: {},
      usersCreatedThisMonth: 0,
      usersCreatedThisWeek: 0,
      lastUserCreated: null,
    );
  }
}

/// Échec d'opération d'administration
class AdminFailure {
  final String message;
  final String? code;

  AdminFailure(this.message, {this.code});

  factory AdminFailure.permissionDenied() =>
      AdminFailure('Permission refusée', code: 'PERMISSION_DENIED');

  factory AdminFailure.userNotFound() =>
      AdminFailure('Utilisateur non trouvé', code: 'USER_NOT_FOUND');

  factory AdminFailure.invalidData() =>
      AdminFailure('Données invalides', code: 'INVALID_DATA');

  factory AdminFailure.databaseError() =>
      AdminFailure('Erreur de base de données', code: 'DATABASE_ERROR');

  factory AdminFailure.networkError() =>
      AdminFailure('Erreur réseau', code: 'NETWORK_ERROR');
}