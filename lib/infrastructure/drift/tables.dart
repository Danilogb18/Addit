// infrastructure/drift/tables.dart
import 'package:drift/drift.dart';

@DataClassName('CounterRow')
class Counters extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CounterEntryRow')
class CounterEntries extends Table {
  TextColumn get id => text()();
  TextColumn get counterId =>
      text().references(Counters, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get description => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}