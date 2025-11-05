import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import repositories
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/activities/domain/repositories/activity_repository.dart';
import '../../features/users/domain/repositories/admin_user_repository.dart';

// Import datasources
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/transactions/data/datasources/transaction_local_datasource.dart';
import '../../features/activities/data/datasources/activity_local_datasource.dart';
import '../../features/users/data/datasources/admin_user_local_datasource.dart';

// Import implementations
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/activities/data/repositories/activity_repository_impl.dart';
import '../../features/users/data/repositories/admin_user_repository_impl.dart';

// Import use cases
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/dashboard/domain/usecases/get_global_kpis_usecase.dart';

// Import dashboard repository implementation
import '../../features/dashboard/data/repositories/dashboard_repository.dart';
import '../../features/transactions/domain/usecases/get_transactions_usecase.dart';
import '../../features/transactions/domain/usecases/create_transaction_usecase.dart';
import '../../features/transactions/domain/usecases/update_transaction_usecase.dart';
import '../../features/transactions/domain/usecases/delete_transaction_usecase.dart';
import '../../features/transactions/domain/usecases/approve_transaction_usecase.dart';
import '../../features/transactions/domain/usecases/reject_transaction_usecase.dart';
import '../../features/activities/domain/usecases/get_activities_usecase.dart';
import '../../features/activities/domain/usecases/create_activity_usecase.dart';
import '../../features/activities/domain/usecases/update_activity_usecase.dart' as update;
import '../../features/activities/domain/usecases/delete_activity_usecase.dart' as delete;
import '../../features/activities/domain/usecases/activity_management_usecase.dart' as management;

// Import database provider
import 'database_providers.dart';

// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be provided in main.dart');
});

// Repository providers - defined at the bottom level of the dependency tree

// Auth providers
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return AuthLocalDataSourceImpl(database: database, sharedPreferences: sharedPrefs);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(localDataSource: dataSource);
});

// Transaction providers
final transactionLocalDataSourceProvider = Provider<TransactionLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return TransactionLocalDataSourceImpl(database);
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final dataSource = ref.watch(transactionLocalDataSourceProvider);
  return TransactionRepositoryImpl(dataSource);
});

// Activity providers
final activityLocalDataSourceProvider = Provider<ActivityLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return ActivityLocalDataSourceImpl(database);
});

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final dataSource = ref.watch(activityLocalDataSourceProvider);
  return ActivityRepositoryImpl(dataSource);
});

// Admin User providers
final adminUserLocalDataSourceProvider = Provider<AdminUserLocalDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return AdminUserLocalDataSourceImpl(database);
});

final adminUserRepositoryProvider = Provider<AdminUserRepository>((ref) {
  final dataSource = ref.watch(adminUserLocalDataSourceProvider);
  return AdminUserRepositoryImpl(dataSource);
});

// Use case providers - depend on repositories

// Auth use cases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginUseCase(authRepository);
});

// Transaction use cases
final getTransactionsUseCaseProvider = Provider<GetTransactionsUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return GetTransactionsUseCase(repository);
});

final createTransactionUseCaseProvider = Provider<CreateTransactionUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return CreateTransactionUseCase(repository);
});

final updateTransactionUseCaseProvider = Provider<UpdateTransactionUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return UpdateTransactionUseCase(repository);
});

final deleteTransactionUseCaseProvider = Provider<DeleteTransactionUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return DeleteTransactionUseCase(repository);
});

final approveTransactionUseCaseProvider = Provider<ApproveTransactionUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return ApproveTransactionUseCase(repository);
});

final rejectTransactionUseCaseProvider = Provider<RejectTransactionUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return RejectTransactionUseCase(repository);
});

// Activity use cases
final getActivitiesUseCaseProvider = Provider<GetActivitiesUseCase>((ref) {
   final repository = ref.watch(activityRepositoryProvider);
   return GetActivitiesUseCase(repository);
});

final getActivityByIdUseCaseProvider = Provider<GetActivityByIdUseCase>((ref) {
   final repository = ref.watch(activityRepositoryProvider);
   return GetActivityByIdUseCase(repository);
});

final getActivitiesByTypeUseCaseProvider = Provider<GetActivitiesByTypeUseCase>((ref) {
   final repository = ref.watch(activityRepositoryProvider);
   return GetActivitiesByTypeUseCase(repository);
});

final getActivitiesByStatusUseCaseProvider = Provider<GetActivitiesByStatusUseCase>((ref) {
   final repository = ref.watch(activityRepositoryProvider);
   return GetActivitiesByStatusUseCase(repository);
});

final getActivitiesByUserUseCaseProvider = Provider<GetActivitiesByUserUseCase>((ref) {
   final repository = ref.watch(activityRepositoryProvider);
   return GetActivitiesByUserUseCase(repository);
});

final searchActivitiesUseCaseProvider = Provider<SearchActivitiesUseCase>((ref) {
   final repository = ref.watch(activityRepositoryProvider);
   return SearchActivitiesUseCase(repository);
});

final createActivityUseCaseProvider = Provider<CreateActivityUseCase>((ref) {
  final repository = ref.watch(activityRepositoryProvider);
  return CreateActivityUseCase(repository);
});

final updateActivityUseCaseProvider = Provider<update.UpdateActivityUseCase>((ref) {
   final repository = ref.watch(activityRepositoryProvider);
   return update.UpdateActivityUseCase(repository);
});

final deleteActivityUseCaseProvider = Provider<delete.DeleteActivityUseCase>((ref) {
   final repository = ref.watch(activityRepositoryProvider);
   return delete.DeleteActivityUseCase(repository);
});

final assignUserToActivityUseCaseProvider = Provider<management.AssignUserToActivityUseCase>((ref) {
   final repository = ref.watch(activityRepositoryProvider);
   return management.AssignUserToActivityUseCase(repository);
});

final unassignUserFromActivityUseCaseProvider = Provider<management.UnassignUserFromActivityUseCase>((ref) {
   final repository = ref.watch(activityRepositoryProvider);
   return management.UnassignUserFromActivityUseCase(repository);
});

final getAssignedUsersUseCaseProvider = Provider<management.GetAssignedUsersUseCase>((ref) {
   final repository = ref.watch(activityRepositoryProvider);
   return management.GetAssignedUsersUseCase(repository);
});

final closeActivityUseCaseProvider = Provider<management.CloseActivityUseCase>((ref) {
   final repository = ref.watch(activityRepositoryProvider);
   return management.CloseActivityUseCase(repository);
});

final suspendActivityUseCaseProvider = Provider<management.SuspendActivityUseCase>((ref) {
    final repository = ref.watch(activityRepositoryProvider);
    return management.SuspendActivityUseCase(repository);
});

final reactivateActivityUseCaseProvider = Provider<management.ReactivateActivityUseCase>((ref) {
    final repository = ref.watch(activityRepositoryProvider);
    return management.ReactivateActivityUseCase(repository);
});

// Dashboard repository provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final transactionRepository = ref.watch(transactionRepositoryProvider);
  final activityRepository = ref.watch(activityRepositoryProvider);
  return DashboardRepositoryImpl(transactionRepository, activityRepository);
});

// Dashboard use cases
final getGlobalKPIsUseCaseProvider = Provider<GetGlobalKPIsUseCase>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return GetGlobalKPIsUseCase(repository);
});