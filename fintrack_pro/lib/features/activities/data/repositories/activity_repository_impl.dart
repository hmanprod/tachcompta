import 'package:fpdart/fpdart.dart';

import '../../domain/entities/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_local_datasource.dart';
import '../models/activity_model.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityLocalDataSource dataSource;

  ActivityRepositoryImpl(this.dataSource);

  @override
  Future<Either<ActivityFailure, List<Activity>>> getAllActivities() async {
    try {
      final activities = await dataSource.getAllActivities();
      return Right(activities.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la récupération des activités: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, Activity?>> getActivityById(String id) async {
    try {
      final activity = await dataSource.getActivityById(id);
      return Right(activity?.toDomain());
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la récupération de l\'activité: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, Activity>> createActivity(Activity activity) async {
    try {
      // Validation de base
      if (activity.name.isEmpty) {
        return Left(ActivityValidationFailure('Le nom de l\'activité est requis'));
      }

      if (!['magasin', 'transport', 'autre'].contains(activity.type.value)) {
        return Left(ActivityValidationFailure('Type d\'activité invalide'));
      }

      final model = ActivityModel.fromDomain(activity);
      final created = await dataSource.createActivity(model);
      return Right(created.toDomain());
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la création de l\'activité: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, Activity>> updateActivity(Activity activity) async {
    try {
      // Validation de base
      if (activity.name.isEmpty) {
        return Left(ActivityValidationFailure('Le nom de l\'activité est requis'));
      }

      if (!['magasin', 'transport', 'autre'].contains(activity.type.value)) {
        return Left(ActivityValidationFailure('Type d\'activité invalide'));
      }

      final model = ActivityModel.fromDomain(activity);
      final updated = await dataSource.updateActivity(model);
      return Right(updated.toDomain());
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la mise à jour de l\'activité: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, void>> deleteActivity(String id) async {
    try {
      await dataSource.deleteActivity(id);
      return const Right(null);
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la suppression de l\'activité: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, void>> assignUserToActivity(String activityId, String userId) async {
    try {
      await dataSource.assignUserToActivity(activityId, userId);
      return const Right(null);
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de l\'assignation de l\'utilisateur: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, void>> unassignUserFromActivity(String activityId, String userId) async {
    try {
      await dataSource.unassignUserFromActivity(activityId, userId);
      return const Right(null);
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la suppression de l\'assignation: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, List<String>>> getAssignedUsers(String activityId) async {
    try {
      final users = await dataSource.getAssignedUsers(activityId);
      return Right(users);
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la récupération des utilisateurs assignés: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, Activity>> closeActivity(String id, String closedBy) async {
    try {
      final closed = await dataSource.closeActivity(id, closedBy);
      return Right(closed.toDomain());
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la clôture de l\'activité: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, Activity>> suspendActivity(String id) async {
    try {
      final suspended = await dataSource.suspendActivity(id);
      return Right(suspended.toDomain());
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la suspension de l\'activité: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, Activity>> reactivateActivity(String id) async {
    try {
      final reactivated = await dataSource.reactivateActivity(id);
      return Right(reactivated.toDomain());
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la réactivation de l\'activité: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, List<Activity>>> getActivitiesByType(String type) async {
    try {
      final activities = await dataSource.getActivitiesByType(type);
      return Right(activities.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la récupération des activités par type: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, List<Activity>>> getActivitiesByStatus(String status) async {
    try {
      final activities = await dataSource.getActivitiesByStatus(status);
      return Right(activities.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la récupération des activités par statut: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, List<Activity>>> getActivitiesByUser(String userId) async {
    try {
      final activities = await dataSource.getActivitiesByUser(userId);
      return Right(activities.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la récupération des activités de l\'utilisateur: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ActivityFailure, List<Activity>>> searchActivities(String query) async {
    try {
      final activities = await dataSource.searchActivities(query);
      return Right(activities.map((model) => model.toDomain()).toList());
    } catch (e) {
      return Left(ActivityDatabaseFailure('Erreur lors de la recherche des activités: ${e.toString()}'));
    }
  }
}