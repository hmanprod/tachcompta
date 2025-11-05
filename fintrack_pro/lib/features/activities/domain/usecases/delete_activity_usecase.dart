import 'package:fpdart/fpdart.dart';

import '../repositories/activity_repository.dart';

class DeleteActivityUseCase {
  final ActivityRepository repository;

  DeleteActivityUseCase(this.repository);

  Future<Either<ActivityFailure, void>> execute(String id) {
    return repository.deleteActivity(id);
  }
}