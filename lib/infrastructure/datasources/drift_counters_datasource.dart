// infrastructure/datasources/drift_counters_datasource.dart
import 'package:drift/drift.dart';

import 'package:addit/domain/datasources/counters_datasource.dart';
import 'package:addit/domain/entities/counter.dart';
import 'package:addit/domain/entities/counter_entry.dart';
import 'package:addit/infrastructure/drift/app_database.dart';

class DriftCountersDatasource implements CountersDatasource {
  final AppDatabase _db;

  DriftCountersDatasource(this._db);

  @override
  Future<List<Counter>> getCounters() async {
    final counterRows = await _db.select(_db.counters).get();
    final entryRows = await _db.select(_db.counterEntries).get();

    final entriesByCounter = <String, List<CounterEntry>>{};
    for (final row in entryRows) {
      entriesByCounter
          .putIfAbsent(row.counterId, () => [])
          .add(_entryFromRow(row));
    }

    return counterRows
        .map((row) => Counter(
              id: row.id,
              name: row.name,
              icon: row.icon,
              description: row.description,
              entries: entriesByCounter[row.id] ?? [],
            ))
        .toList();
  }

  @override
  Future<void> createCounter(Counter counter) {
    return _db.transaction(() async {
      await _db.into(_db.counters).insert(
            CountersCompanion.insert(
              id: counter.id,
              name: counter.name,
              icon: counter.icon,
              description: Value(counter.description),
            ),
          );
      await _insertEntries(counter);
    });
  }

  @override
  Future<Counter> updateCounter(Counter counter) async {
    await _db.transaction(() async {
      await (_db.update(_db.counters)
            ..where((t) => t.id.equals(counter.id)))
          .write(CountersCompanion(
        name: Value(counter.name),
        icon: Value(counter.icon),
        description: Value(counter.description),
      ));

      await (_db.delete(_db.counterEntries)
            ..where((t) => t.counterId.equals(counter.id)))
          .go();
      await _insertEntries(counter);
    });
    return counter;
  }

  @override
  Future<void> deleteCounter(Counter counter) async {
    // Las entries se borran solas por el ON DELETE CASCADE.
    await (_db.delete(_db.counters)..where((t) => t.id.equals(counter.id)))
        .go();
  }

  Future<void> _insertEntries(Counter counter) {
    return _db.batch((batch) {
      batch.insertAll(
        _db.counterEntries,
        counter.entries.map((e) => CounterEntriesCompanion.insert(
              id: e.id,
              counterId: counter.id,
              occurredAt: e.dateTime,
              description: Value(e.description),
            )),
      );
    });
  }

  CounterEntry _entryFromRow(CounterEntryRow row) => CounterEntry(
        id: row.id,
        dateTime: row.occurredAt,
        description: row.description,
      );
}