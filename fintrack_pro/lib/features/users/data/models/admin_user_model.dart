import 'package:equatable/equatable.dart';
import 'package:fintrack_pro/features/auth/domain/entities/user.dart';
import 'package:fintrack_pro/features/activities/domain/entities/activity.dart';

/// Modèle étendu pour l'administration des utilisateurs
/// Inclut des informations supplémentaires pour la gestion admin
class AdminUserModel extends Equatable {
  final User user;
  final List<String> assignedActivities;
  final DateTime? lastLogin;
  final int loginCount;
  final bool passwordNeedsReset;
  final DateTime? passwordLastReset;
  final List<String> permissions;

  const AdminUserModel({
    required this.user,
    this.assignedActivities = const [],
    this.lastLogin,
    this.loginCount = 0,
    this.passwordNeedsReset = false,
    this.passwordLastReset,
    this.permissions = const [],
  });

  /// Factory pour créer depuis User standard
  factory AdminUserModel.fromUser(User user) {
    return AdminUserModel(
      user: user,
      assignedActivities: [],
      loginCount: 0,
      permissions: _getDefaultPermissions(user.role),
    );
  }

  /// Factory pour créer depuis JSON
  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      user: User(
        id: json['id'],
        email: json['email'],
        role: UserRole.fromString(json['role']),
        firstName: json['firstName'],
        lastName: json['lastName'],
        avatarUrl: json['avatarUrl'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        isActive: json['isActive'] ?? true,
      ),
      assignedActivities: List<String>.from(json['assignedActivities'] ?? []),
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      loginCount: json['loginCount'] ?? 0,
      passwordNeedsReset: json['passwordNeedsReset'] ?? false,
      passwordLastReset: json['passwordLastReset'] != null ? DateTime.parse(json['passwordLastReset']) : null,
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }

  /// Convertit en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': user.id,
      'email': user.email,
      'role': user.role.value,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'avatarUrl': user.avatarUrl,
      'createdAt': user.createdAt.toIso8601String(),
      'updatedAt': user.updatedAt.toIso8601String(),
      'isActive': user.isActive,
      'assignedActivities': assignedActivities,
      'lastLogin': lastLogin?.toIso8601String(),
      'loginCount': loginCount,
      'passwordNeedsReset': passwordNeedsReset,
      'passwordLastReset': passwordLastReset?.toIso8601String(),
      'permissions': permissions,
    };
  }

  /// Calcule le nom complet
  String get fullName => '${user.firstName} ${user.lastName}';

  /// Vérifie si l'utilisateur a accès à une activité spécifique
  bool hasAccessToActivity(String activityId) {
    return assignedActivities.contains(activityId) || user.role == UserRole.admin;
  }

  /// Vérifie si l'utilisateur a une permission spécifique
  bool hasPermission(String permission) {
    return permissions.contains(permission) || user.role == UserRole.admin;
  }

  /// Crée une copie avec des modifications
  AdminUserModel copyWith({
    User? user,
    List<String>? assignedActivities,
    DateTime? lastLogin,
    int? loginCount,
    bool? passwordNeedsReset,
    DateTime? passwordLastReset,
    List<String>? permissions,
  }) {
    return AdminUserModel(
      user: user ?? this.user,
      assignedActivities: assignedActivities ?? this.assignedActivities,
      lastLogin: lastLogin ?? this.lastLogin,
      loginCount: loginCount ?? this.loginCount,
      passwordNeedsReset: passwordNeedsReset ?? this.passwordNeedsReset,
      passwordLastReset: passwordLastReset ?? this.passwordLastReset,
      permissions: permissions ?? this.permissions,
    );
  }

  @override
  List<Object?> get props => [
    user,
    assignedActivities,
    lastLogin,
    loginCount,
    passwordNeedsReset,
    passwordLastReset,
    permissions,
  ];
}

/// Permissions par défaut selon le rôle
List<String> _getDefaultPermissions(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return [
        'users.create',
        'users.read',
        'users.update',
        'users.delete',
        'users.assign_activities',
        'activities.create',
        'activities.read',
        'activities.update',
        'activities.delete',
        'activities.transfer',
        'activities.archive',
        'transactions.create',
        'transactions.read',
        'transactions.approve',
        'transactions.reject',
        'system.settings',
        'system.backup',
        'system.restore',
        'reports.view',
        'reports.export',
        'audit.view',
      ];
    case UserRole.agent:
      return [
        'activities.read',
        'activities.update',
        'transactions.create',
        'transactions.read',
        'transactions.approve',
        'reports.view',
      ];
    case UserRole.user:
      return [
        'activities.read',
        'transactions.read',
      ];
  }
}