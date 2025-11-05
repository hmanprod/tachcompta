// Table Transactions
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'activities.dart';
import 'users.dart';

@DataClassName('TransactionEntity')
class Transactions extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get activityId => text().references(Activities, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get type => text().check(
    (type).isIn(['recette', 'depense'])
  )();
  RealColumn get amount => real()();
  TextColumn get status => text().check(
    (status).isIn(['pending', 'approved', 'rejected', 'completed'])
  )();
  TextColumn get description => text()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn? get approvedBy => text().references(Users, #id).nullable()();
  DateTimeColumn? get approvedAt => dateTime().nullable()();
  TextColumn? get rejectionReason => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}