import 'package:fpdart/fpdart.dart';

import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

class UpdateActivityUseCase {
  final ActivityRepository repository;

  UpdateActivityUseCase(this.repository);

  Future<Either<ActivityFailure, Activity>> execute(Activity activity) {
    return repository.updateActivity(activity);
  }
}