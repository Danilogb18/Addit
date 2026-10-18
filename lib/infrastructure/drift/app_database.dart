// infrastructure/drift/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Counters, CounterEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'addit'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          // SQLite trae las llaves foráneas desactivadas por defecto.
          // Sin esto, el onDelete: cascade no hace nada.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}