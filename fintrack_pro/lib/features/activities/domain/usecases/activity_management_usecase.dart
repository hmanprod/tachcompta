import 'package:fpdart/fpdart.dart';

import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

class AssignUserToActivityUseCase {
  final ActivityRepository repository;

  AssignUserToActivityUseCase(this.repository);

  Future<Either<ActivityFailure, void>> execute(String activityId, String userId) {
    return repository.assignUserToActivity(activityId, userId);
  }
}

class UnassignUserFromActivityUseCase {
  final ActivityRepository repository;

  UnassignUserFromActivityUseCase(this.repository);

  Future<Either<ActivityFailure, void>> execute(String activityId, String userId) {
    return repository.unassignUserFromActivity(activityId, userId);
  }
}

class GetAssignedUsersUseCase {
  final ActivityRepository repository;

  GetAssignedUsersUseCase(this.repository);

  Future<Either<ActivityFailure, List<String>>> execute(String activityId) {
    return repository.getAssignedUsers(activityId);
  }
}

class CloseActivityUseCase {
  final ActivityRepository repository;

  CloseActivityUseCase(this.repository);

  Future<Either<ActivityFailure, Activity>> execute(String id, String closedBy) {
    return repository.closeActivity(id, closedBy);
  }
}

class SuspendActivityUseCase {
  final ActivityRepository repository;

  SuspendActivityUseCase(this.repository);

  Future<Either<ActivityFailure, Activity>> execute(String id) {
    return repository.suspendActivity(id);
  }
}

class ReactivateActivityUseCase {
  final ActivityRepository repository;

  ReactivateActivityUseCase(this.repository);

  Future<Either<ActivityFailure, Activity>> execute(String id) {
    return repository.reactivateActivity(id);
  }
}