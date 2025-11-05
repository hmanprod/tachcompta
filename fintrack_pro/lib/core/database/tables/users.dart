// Table Utilisateurs
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

@DataClassName('UserEntity')
class Users extends Table {
  TextColumn get id => text().clientDefault(() => uuid.v4())();
  TextColumn get email => text()();
  TextColumn get password => text()(); // Hashé avec crypto
  TextColumn get role => text().check(
    (role).isIn(['admin', 'agent', 'user'])
  )();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get avatarUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {email}
  ];
}