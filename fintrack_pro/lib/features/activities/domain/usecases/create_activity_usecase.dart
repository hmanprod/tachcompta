import 'package:fpdart/fpdart.dart';

import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

class CreateActivityUseCase {
  final ActivityRepository repository;

  CreateActivityUseCase(this.repository);

  Future<Either<ActivityFailure, Activity>> execute(Activity activity) {
    return repository.createActivity(activity);
  }
}

class UpdateActivityUseCase {
  final ActivityRepository repository;

  UpdateActivityUseCase(this.repository);

  Future<Either<ActivityFailure, Activity>> execute(Activity activity) {
    return repository.updateActivity(activity);
  }
}

class DeleteActivityUseCase {
  final ActivityRepository repository;

  DeleteActivityUseCase(this.repository);

  Future<Either<ActivityFailure, void>> execute(String id) {
    return repository.deleteActivity(id);
  }
}