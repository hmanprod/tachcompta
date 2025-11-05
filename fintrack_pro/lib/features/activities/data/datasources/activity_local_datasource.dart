import 'package:drift/drift.dart';
import 'package:fintrack_pro/features/activities/data/models/activity_model.dart';

import 'package:drift/drift.dart' as drift;
import 'package:fintrack_pro/core/database/database.dart';
import 'package:fintrack_pro/features/activities/domain/entities/activity.dart';

abstract class ActivityLocalDataSource {
  // CRUD Operations
  Future<List<ActivityModel>> getAllActivities();
  Future<ActivityModel?> getActivityById(String id);
  Future<ActivityModel> createActivity(ActivityModel activity);
  Future<ActivityModel> updateActivity(ActivityModel activity);
  Future<void> deleteActivity(String id);

  // Assignment Operations
  Future<void> assignUserToActivity(String activityId, String userId);
  Future<void> unassignUserFromActivity(String activityId, String userId);
  Future<List<String>> getAssignedUsers(String activityId);

  // Special Operations
  Future<ActivityModel> closeActivity(String id, String closedBy);
  Future<ActivityModel> suspendActivity(String id);
  Future<ActivityModel> reactivateActivity(String id);

  // Filtered Queries
  Future<List<ActivityModel>> getActivitiesByType(String type);
  Future<List<ActivityModel>> getActivitiesByStatus(String status);
  Future<List<ActivityModel>> getActivitiesByUser(String userId);
  Future<List<ActivityModel>> searchActivities(String query);
}

class ActivityLocalDataSourceImpl implements ActivityLocalDataSource {
  final AppDatabase database;

  ActivityLocalDataSourceImpl(this.database);

  @override
  Future<List<ActivityModel>> getAllActivities() async {
    final activities = await database.select(database.activities).get();
    return activities.map((entity) => ActivityModel.fromEntity(entity)).toList();
  }

  @override
  Future<ActivityModel?> getActivityById(String id) async {
    final query = database.select(database.activities)
      ..where((tbl) => tbl.id.equals(id));

    final entity = await query.getSingleOrNull();
    return entity != null ? ActivityModel.fromEntity(entity) : null;
  }

  @override
  Future<ActivityModel> createActivity(ActivityModel activity) async {
    await database.into(database.activities).insert(ActivitiesCompanion(
      name: drift.Value(activity.name),
      description: drift.Value(activity.description),
      type: drift.Value(activity.type.value),
      status: drift.Value(activity.status.value),
      createdBy: drift.Value(activity.createdBy),
      color: drift.Value(activity.color),
    ));
    return activity;
  }

  @override
  Future<ActivityModel> updateActivity(ActivityModel activity) async {
    await (database.update(database.activities)
          ..where((tbl) => tbl.id.equals(activity.id)))
        .write(ActivitiesCompanion(
          name: drift.Value(activity.name),
          description: drift.Value(activity.description),
          type: drift.Value(activity.type.value),
          status: drift.Value(activity.status.value),
          color: drift.Value(activity.color),
          updatedAt: drift.Value(DateTime.now()),
        ));
    return activity;
  }

  @override
  Future<void> deleteActivity(String id) async {
    await (database.delete(database.activities)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  @override
  Future<void> assignUserToActivity(String activityId, String userId) async {
    await database.into(database.activityAssignments).insert(ActivityAssignmentsCompanion(
      activityId: drift.Value(activityId),
      userId: drift.Value(userId),
    ));
  }

  @override
  Future<void> unassignUserFromActivity(String activityId, String userId) async {
    await (database.update(database.activityAssignments)
          ..where((tbl) => tbl.activityId.equals(activityId) & tbl.userId.equals(userId)))
        .write(ActivityAssignmentsCompanion(
          isActive: drift.Value(false),
        ));
  }

  @override
  Future<List<String>> getAssignedUsers(String activityId) async {
    final query = database.select(database.activityAssignments)
      ..where((tbl) => tbl.activityId.equals(activityId) & tbl.isActive.equals(true));

    final assignments = await query.get();
    return assignments.map((assignment) => assignment.userId).toList();
  }

  @override
  Future<ActivityModel> closeActivity(String id, String closedBy) async {
    await (database.update(database.activities)
          ..where((tbl) => tbl.id.equals(id)))
        .write(ActivitiesCompanion(
          status: drift.Value('closed'),
          closedAt: drift.Value(DateTime.now()),
        ));

    final activity = await getActivityById(id);
    if (activity == null) {
      throw Exception('Activity not found after closing');
    }

    return ActivityModel.fromDomain(
      activity.toDomain().copyWith(
        status: ActivityStatus.closed,
        closedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<ActivityModel> suspendActivity(String id) async {
    await (database.update(database.activities)
          ..where((tbl) => tbl.id.equals(id)))
        .write(ActivitiesCompanion(
          status: drift.Value('suspended'),
        ));

    final activity = await getActivityById(id);
    if (activity == null) {
      throw Exception('Activity not found after suspending');
    }

    return ActivityModel.fromDomain(
      activity.toDomain().copyWith(status: ActivityStatus.suspended),
    );
  }

  @override
  Future<ActivityModel> reactivateActivity(String id) async {
    await (database.update(database.activities)
          ..where((tbl) => tbl.id.equals(id)))
        .write(ActivitiesCompanion(
          status: drift.Value('active'),
        ));

    final activity = await getActivityById(id);
    if (activity == null) {
      throw Exception('Activity not found after reactivating');
    }

    return ActivityModel.fromDomain(
      activity.toDomain().copyWith(status: ActivityStatus.active),
    );
  }

  @override
  Future<List<ActivityModel>> getActivitiesByType(String type) async {
    final query = database.select(database.activities)
      ..where((tbl) => tbl.type.equals(type));

    final activities = await query.get();
    return activities.map((entity) => ActivityModel.fromEntity(entity)).toList();
  }

  @override
  Future<List<ActivityModel>> getActivitiesByStatus(String status) async {
    final query = database.select(database.activities)
      ..where((tbl) => tbl.status.equals(status));

    final activities = await query.get();
    return activities.map((entity) => ActivityModel.fromEntity(entity)).toList();
  }

  @override
  Future<List<ActivityModel>> getActivitiesByUser(String userId) async {
    final assignmentQuery = database.select(database.activityAssignments)
      ..where((tbl) => tbl.userId.equals(userId) & tbl.isActive.equals(true));

    final assignments = await assignmentQuery.get();
    final activityIds = assignments.map((a) => a.activityId).toList();

    if (activityIds.isEmpty) return [];

    final activityQuery = database.select(database.activities)
      ..where((tbl) => tbl.id.isIn(activityIds));

    final activities = await activityQuery.get();
    return activities.map((entity) => ActivityModel.fromEntity(entity)).toList();
  }

  @override
  Future<List<ActivityModel>> searchActivities(String query) async {
    final searchQuery = database.select(database.activities)
      ..where((tbl) => tbl.name.contains(query) | tbl.description.contains(query));

    final activities = await searchQuery.get();
    return activities.map((entity) => ActivityModel.fromEntity(entity)).toList();
  }
}