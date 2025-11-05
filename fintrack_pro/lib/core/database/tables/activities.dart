// Table Activités
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'users.dart';

@DataClassName('ActivityEntity')
class Activities extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text().check(
    (type).isIn(['magasin', 'transport', 'autre'])
  )();
  TextColumn get status => text().check(
    (status).isIn(['active', 'closed', 'suspended'])
  )();
  TextColumn get createdBy => text().references(Users, #id)();
  TextColumn get color => text().nullable()(); // Couleur identitaire activité
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn? get closedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}