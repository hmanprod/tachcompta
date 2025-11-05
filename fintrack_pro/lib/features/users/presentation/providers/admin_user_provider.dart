import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fintrack_pro/features/users/data/datasources/admin_user_local_datasource.dart';
import 'package:fintrack_pro/features/users/data/repositories/admin_user_repository_impl.dart';
import 'package:fintrack_pro/features/users/data/models/admin_user_model.dart';
import 'package:fintrack_pro/features/users/domain/repositories/admin_user_repository.dart';
import 'package:fintrack_pro/shared/providers/database_provider.dart';
import 'package:fintrack_pro/features/auth/domain/entities/user.dart';

// Provider pour la datasource
final adminUserLocalDataSourceProvider = Provider<AdminUserLocalDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return AdminUserLocalDataSourceImpl(database);
});

// Provider pour le repository
final adminUserRepositoryProvider = Provider<AdminUserRepository>((ref) {
  final dataSource = ref.watch(adminUserLocalDataSourceProvider);
  return AdminUserRepositoryImpl(dataSource);
});

// Provider pour l'état de la liste des utilisateurs admin
final adminUsersListProvider = StateNotifierProvider<AdminUsersNotifier, AsyncValue<List<AdminUserModel>>>((ref) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return AdminUsersNotifier(repository);
});

class AdminUsersNotifier extends StateNotifier<AsyncValue<List<AdminUserModel>>> {
  final AdminUserRepository _repository;

  AdminUsersNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    state = const AsyncValue.loading();
    try {
      final users = await _repository.getAllAdminUsers();
      state = AsyncValue.data(users);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshUsers() async {
    await loadUsers();
  }

  Future<void> addUser({
    required String email,
    required String firstName,
    required String lastName,
    required UserRole role,
    List<String>? assignedActivities,
    List<String>? permissions,
  }) async {
    try {
      await _repository.createAdminUser(
        email,
        firstName,
        lastName,
        role,
        assignedActivities: assignedActivities,
        permissions: permissions,
      );
      await loadUsers(); // Recharger la liste
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateUser(
    String userId, {
    String? email,
    String? firstName,
    String? lastName,
    UserRole? role,
    List<String>? assignedActivities,
    List<String>? permissions,
    bool? isActive,
  }) async {
    try {
      await _repository.updateAdminUser(
        userId,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: role,
        assignedActivities: assignedActivities,
        permissions: permissions,
        isActive: isActive,
      );
      await loadUsers(); // Recharger la liste
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _repository.deleteAdminUser(userId);
      await loadUsers(); // Recharger la liste
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> toggleUserStatus(String userId, bool isActive) async {
    try {
      await _repository.toggleUserStatus(userId, isActive);
      await loadUsers(); // Recharger la liste
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Provider pour les statistiques des utilisateurs
final userStatisticsProvider = FutureProvider<UserStatistics>((ref) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return repository.getUserStatistics();
});

// Provider pour un utilisateur spécifique
final adminUserProvider = FutureProvider.family<AdminUserModel?, String>((ref, userId) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return repository.getAdminUserById(userId);
});

// Provider pour la recherche d'utilisateurs
final searchUsersProvider = StateNotifierProvider<SearchUsersNotifier, AsyncValue<List<AdminUserModel>>>((ref) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return SearchUsersNotifier(repository);
});

class SearchUsersNotifier extends StateNotifier<AsyncValue<List<AdminUserModel>>> {
  final AdminUserRepository _repository;

  SearchUsersNotifier(this._repository) : super(const AsyncValue.data([]));

  Future<void> search({
    String? query,
    UserRole? role,
    bool? isActive,
    DateTime? createdAfter,
    DateTime? createdBefore,
  }) async {
    state = const AsyncValue.loading();
    try {
      final users = await _repository.searchUsers(
        query: query,
        role: role,
        isActive: isActive,
        createdAfter: createdAfter,
        createdBefore: createdBefore,
      );
      state = AsyncValue.data(users);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clearSearch() {
    state = const AsyncValue.data([]);
  }
}

// Provider pour vérifier les permissions
final userPermissionProvider = FutureProvider.family<bool, String>((ref, permission) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return repository.hasPermission(permission);
});

// Provider pour vérifier l'accès aux activités
final userActivityAccessProvider = FutureProvider.family<bool, String>((ref, activityId) {
  final repository = ref.watch(adminUserRepositoryProvider);
  return repository.hasAccessToActivity(activityId);
});