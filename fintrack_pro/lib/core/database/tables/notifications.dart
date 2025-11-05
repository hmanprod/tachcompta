// Table Notifications
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'users.dart';

@DataClassName('NotificationEntity')
class Notifications extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get type => text().check(
    (type).isIn(['activity_closed', 'new_user', 'pending_expense', 'alert_threshold'])
  )();
  TextColumn get title => text()();
  TextColumn get message => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  TextColumn get data => text().nullable()(); // JSON avec données additionnelles
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}