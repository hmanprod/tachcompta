import 'package:fpdart/fpdart.dart';

import '../entities/activity.dart';

abstract class ActivityFailure {
  const ActivityFailure();
  String get message;
}

class ActivityNotFoundFailure extends ActivityFailure {
  @override
  final String message;
  const ActivityNotFoundFailure(this.message);
}

class ActivityValidationFailure extends ActivityFailure {
  @override
  final String message;
  const ActivityValidationFailure(this.message);
}

class ActivityDatabaseFailure extends ActivityFailure {
  @override
  final String message;
  const ActivityDatabaseFailure(this.message);
}

class ActivityPermissionFailure extends ActivityFailure {
  @override
  final String message;
  const ActivityPermissionFailure(this.message);
}

abstract class ActivityRepository {
  // CRUD Activities
  Future<Either<ActivityFailure, List<Activity>>> getAllActivities();
  Future<Either<ActivityFailure, Activity?>> getActivityById(String id);
  Future<Either<ActivityFailure, Activity>> createActivity(Activity activity);
  Future<Either<ActivityFailure, Activity>> updateActivity(Activity activity);
  Future<Either<ActivityFailure, void>> deleteActivity(String id);

  // Assignations utilisateurs
  Future<Either<ActivityFailure, void>> assignUserToActivity(String activityId, String userId);
  Future<Either<ActivityFailure, void>> unassignUserFromActivity(String activityId, String userId);
  Future<Either<ActivityFailure, List<String>>> getAssignedUsers(String activityId);

  // Opérations spéciales
  Future<Either<ActivityFailure, Activity>> closeActivity(String id, String closedBy);
  Future<Either<ActivityFailure, Activity>> suspendActivity(String id);
  Future<Either<ActivityFailure, Activity>> reactivateActivity(String id);

  // Requêtes avec filtres
  Future<Either<ActivityFailure, List<Activity>>> getActivitiesByType(String type);
  Future<Either<ActivityFailure, List<Activity>>> getActivitiesByStatus(String status);
  Future<Either<ActivityFailure, List<Activity>>> getActivitiesByUser(String userId);
  Future<Either<ActivityFailure, List<Activity>>> searchActivities(String query);
}