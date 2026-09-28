import 'package:addit/domain/entities/counter_entry.dart';
import 'package:addit/presentation/providers/counters/counter_by_id_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_stats_providers.g.dart';

// Equivalente al StateProvider<int> de antes.
// @riverpod (minúscula) genera un provider "normal";
// la clase con Notifier es para estado que puede cambiar.
// @riverpod
// class WeekOffset extends _$WeekOffset {
//   @override
//   int build() => 0;

//   void next() => state++;
//   void previous() => state--;
// }

// Equivalente al Provider<List<Entry>> de antes.
@riverpod
List<CounterEntry> entries(Ref ref, String counterId) {
  final counter = ref.watch(getCounterByIdProvider(counterId));
  if (counter == null) throw Exception('No se encontró un counter con ese ID');
  return counter.entries;
}

// Equivalente al Provider<DateTimeRange> derivado.
// @riverpod
// DateTimeRange weekRange(Ref ref) {
//   final offset = ref.watch(weekOffsetProvider);
//   final now = DateTime.now();
  // final currentMonday = now.subtract(Duration(days: now.weekday - 1));
  // final targetMonday = currentMonday.add(Duration(days: 7 * offset));
  // return DateTimeRange(
  //   start: DateTime(targetMonday.year, targetMonday.month, targetMonday.day),
  //   end: targetMonday.add(const Duration(days: 6)),
  // );
// }


@riverpod
class WeekRange extends _$WeekRange {

  bool isForward = false;
  int firstDay = 1; // por defecto el primer dia del rango es lunes

  @override
  DateTimeRange build () {
    final now = DateTime.now();
    final currentMonday = now.subtract(Duration(days: now.weekday - 1));
    return DateTimeRange(
      start: DateTime(currentMonday.year, currentMonday.month, currentMonday.day),
      end: currentMonday.add(const Duration(days: 6)),
    );
  }

  void next() {
    isForward = true;
    final dayCount = _dayCount(state); // cantidad real de días del rango, inclusive
    final shift = Duration(days: dayCount);
    state = DateTimeRange(
      start: state.start.add(shift),
      end: state.end.add(shift),
    );
    firstDay = state.start.weekday;
  }

  void previous() {
    isForward = false;
    final dayCount = _dayCount(state);
    final shift = Duration(days: dayCount);
    state = DateTimeRange(
      start: state.start.subtract(shift),
      end: state.end.subtract(shift),
    );
    firstDay = state.start.weekday;
  }

  void newRange(DateTimeRange range) {
    state = range;
    firstDay = state.start.weekday;
  }

}


// Equivalente al Provider<List<int>> final.
@riverpod
List<int> weeklyChartData(Ref ref, String counterId) {
  final entries = ref.watch(entriesProvider(counterId));
  final range = ref.watch(weekRangeProvider);
  return _dataForWeek(entries, range);
}

@riverpod
List<String> chartLabels(Ref ref) {
  // Debo devolver la lista de labels. Aqui puedo en base al
  List<String> labels = [];

  final firstDay = ref.watch(weekRangeProvider.notifier).firstDay;
  final firstDayMonth = ref.watch(weekRangeProvider).start.day; //El dia de la fecha del mes del primer numero en la lista de datos

  final dateRange = ref.watch(weekRangeProvider);
  final daysIncludedInCount = _dayCount(dateRange);

  if (daysIncludedInCount <= 7) {
    const canonical = ['lun', 'mar', 'mie', 'jue', 'vie', 'sab', 'dom'];
    final startIndex = firstDay - 1;
    final rotated = [
      ...canonical.sublist(startIndex),
      ...canonical.sublist(0, startIndex),
    ];

    return rotated.take(daysIncludedInCount).toList();
  }

  if(daysIncludedInCount <= 31) {
    final start = dateRange.start;
    return List.generate(
      daysIncludedInCount,
      (index) => index % 4 == 0 ? DateTime(start.year, start.month, start.day + index).day.toString() : '',
    );
  }

  return labels;
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

  return List.generate(_dayCount(weekRange), (i) {
    final day = _dateOnly(weekRange.start.add(Duration(days: i)));
    return counts[day] ?? 0;
  });
}

int _dayCount (DateTimeRange dateRange) {
  final firstDate = DateTime(dateRange.start.year, dateRange.start.month, dateRange.start.day);
  final lastDate = DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day);
  final daysIncludedInCount = lastDate.difference(firstDate).inDays + 1; //Se suma 1 para incluir el ultimo dia. Este es el valor de la cantidad de dias que abarca el weekrange
  return daysIncludedInCount;
}