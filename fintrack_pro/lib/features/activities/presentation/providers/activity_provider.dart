import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../shared/providers/repository_providers.dart';
import '../../domain/entities/activity.dart';
import '../../domain/usecases/get_activities_usecase.dart';
import '../../domain/usecases/create_activity_usecase.dart' as create;
import '../../domain/usecases/update_activity_usecase.dart' as update;
import '../../domain/usecases/delete_activity_usecase.dart' as delete;

class ActivityState {
  final List<Activity> activities;
  final bool isLoading;
  final String? error;

  ActivityState({
    required this.activities,
    required this.isLoading,
    this.error,
  });

  ActivityState copyWith({
    List<Activity>? activities,
    bool? isLoading,
    String? error,
  }) {
    return ActivityState(
      activities: activities ?? this.activities,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ActivityNotifier extends StateNotifier<ActivityState> {
  final GetActivitiesUseCase getActivitiesUseCase;
  final create.CreateActivityUseCase createActivityUseCase;
  final update.UpdateActivityUseCase updateActivityUseCase;
  final delete.DeleteActivityUseCase deleteActivityUseCase;

  ActivityNotifier({
    required this.getActivitiesUseCase,
    required this.createActivityUseCase,
    required this.updateActivityUseCase,
    required this.deleteActivityUseCase,
  }) : super(ActivityState(
    activities: [],
    isLoading: false,
  ));

  Future<void> loadActivities() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getActivitiesUseCase.execute();

    result.fold(
      (error) => state = state.copyWith(isLoading: false, error: error.message),
      (activities) {
        state = state.copyWith(
          activities: activities,
          isLoading: false,
        );
      },
    );
  }

  Future<Either<String, Activity>> createActivity(Activity activity) async {
    final result = await createActivityUseCase.execute(activity);

    if (result.isRight()) {
      await loadActivities(); // Recharger la liste
    }

    return result.fold(
      (failure) => Left(failure.message),
      (activity) => Right(activity),
    );
  }

  Future<Either<String, Activity>> updateActivity(Activity activity) async {
    final result = await updateActivityUseCase.execute(activity);

    if (result.isRight()) {
      await loadActivities(); // Recharger la liste
    }

    return result.fold(
      (failure) => Left(failure.message),
      (activity) => Right(activity),
    );
  }

  Future<Either<String, void>> deleteActivity(String activityId) async {
    final result = await deleteActivityUseCase.execute(activityId);

    if (result.isRight()) {
      await loadActivities(); // Recharger la liste
    }

    return result.fold(
      (failure) => Left(failure.message),
      (_) => const Right(null),
    );
  }
}

// Provider
final activityNotifierProvider = StateNotifierProvider<ActivityNotifier, ActivityState>((ref) {
  final getActivitiesUseCase = ref.watch(getActivitiesUseCaseProvider);
  final createActivityUseCase = ref.watch(createActivityUseCaseProvider);
  final updateActivityUseCase = ref.watch(updateActivityUseCaseProvider);
  final deleteActivityUseCase = ref.watch(deleteActivityUseCaseProvider);

  return ActivityNotifier(
    getActivitiesUseCase: getActivitiesUseCase,
    createActivityUseCase: createActivityUseCase,
    updateActivityUseCase: updateActivityUseCase,
    deleteActivityUseCase: deleteActivityUseCase,
  );
});