import 'package:addit/domain/entities/counter_entry.dart';
import 'package:addit/presentation/providers/counters/counter_by_id_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_stats_providers.g.dart';

// Equivalente al StateProvider<int> de antes.
// @riverpod (minúscula) genera un provider "normal";
// la clase con Notifier es para estado que puede cambiar.
@riverpod
class WeekOffset extends _$WeekOffset {
  @override
  int build() => 0;

  void next() => state++;
  void previous() => state--;
}

// Equivalente al Provider<List<Entry>> de antes.
@riverpod
List<CounterEntry> entries(Ref ref, String counterId) {
  final counter = ref.watch(getCounterByIdProvider(counterId));
  if (counter == null) throw Exception('No se encontró un counter con ese ID');
  return counter.entries;
}

// Equivalente al Provider<DateTimeRange> derivado.
@riverpod
DateTimeRange weekRange(Ref ref) {
  final offset = ref.watch(weekOffsetProvider);
  final now = DateTime.now();
  final currentMonday = now.subtract(Duration(days: now.weekday - 1));
  final targetMonday = currentMonday.add(Duration(days: 7 * offset));
  return DateTimeRange(
    start: DateTime(targetMonday.year, targetMonday.month, targetMonday.day),
    end: targetMonday.add(const Duration(days: 6)),
  );
}

// Equivalente al Provider<List<int>> final.
@riverpod
List<int> weeklyChartData(Ref ref, String counterId) {
  final entries = ref.watch(entriesProvider(counterId));
  final range = ref.watch(weekRangeProvider);
  return _dataForWeek(entries, range);
}


// ** Lo de abajo son métodos que sirven para obtener el listado de conteos por semana
DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

Map<DateTime, int> _countByDay(List<CounterEntry> entries) {
  final counts = <DateTime, int>{};
  for (final entry in entries) {
    final day = _dateOnly(entry.dateTime);
    counts[day] = (counts[day] ?? 0) + 1;
  }
  return counts;
}


List<int> _dataForWeek(List<CounterEntry> allEntries, DateTimeRange weekRange) {
  final counts = _countByDay(
    allEntries.where((e) =>
      !e.dateTime.isBefore(weekRange.start) &&
      !e.dateTime.isAfter(weekRange.end.add(const Duration(days: 1)))
    ).toList(),
  );

  return List.generate(7, (i) {
    final day = _dateOnly(weekRange.start.add(Duration(days: i)));
    return counts[day] ?? 0;
  });
}