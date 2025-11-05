import 'package:fpdart/fpdart.dart';

import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

class GetActivitiesUseCase {
  final ActivityRepository repository;

  GetActivitiesUseCase(this.repository);

  Future<Either<ActivityFailure, List<Activity>>> execute() {
    return repository.getAllActivities();
  }
}

class GetActivityByIdUseCase {
  final ActivityRepository repository;

  GetActivityByIdUseCase(this.repository);

  Future<Either<ActivityFailure, Activity?>> execute(String id) {
    return repository.getActivityById(id);
  }
}

class GetActivitiesByTypeUseCase {
  final ActivityRepository repository;

  GetActivitiesByTypeUseCase(this.repository);

  Future<Either<ActivityFailure, List<Activity>>> execute(String type) {
    return repository.getActivitiesByType(type);
  }
}

class GetActivitiesByStatusUseCase {
  final ActivityRepository repository;

  GetActivitiesByStatusUseCase(this.repository);

  Future<Either<ActivityFailure, List<Activity>>> execute(String status) {
    return repository.getActivitiesByStatus(status);
  }
}

class GetActivitiesByUserUseCase {
  final ActivityRepository repository;

  GetActivitiesByUserUseCase(this.repository);

  Future<Either<ActivityFailure, List<Activity>>> execute(String userId) {
    return repository.getActivitiesByUser(userId);
  }
}

class SearchActivitiesUseCase {
  final ActivityRepository repository;

  SearchActivitiesUseCase(this.repository);

  Future<Either<ActivityFailure, List<Activity>>> execute(String query) {
    return repository.searchActivities(query);
  }
}