// Table Association Utilisateur-Activité
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'activities.dart';
import 'users.dart';

@DataClassName('ActivityAssignmentEntity')
class ActivityAssignments extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get activityId => text().references(Activities, #id)();
  TextColumn get userId => text().references(Users, #id)();
  DateTimeColumn get assignedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {activityId, userId}
  ];
}