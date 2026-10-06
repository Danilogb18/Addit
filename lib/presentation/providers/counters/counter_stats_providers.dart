import 'dart:math';

import 'package:addit/config/helpers/human_formats.dart';
import 'package:addit/domain/entities/counter_entry.dart';
import 'package:addit/presentation/providers/counters/counter_by_id_provider.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_stats_providers.g.dart';

// CAMBIO: sube a nivel de archivo porque ahora lo usan los tooltips y dos ramas de las etiquetas
const _months = ['ene', 'feb', 'mar', 'abr', 'may', 'jun',
                 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];


@riverpod
List<CounterEntry> entries(Ref ref, String counterId) {
  final counter = ref.watch(getCounterByIdProvider(counterId));
  if (counter == null) throw Exception('No se encontró un counter con ese ID');
  return counter.entries;
}


@riverpod
class WeekRange extends _$WeekRange {
  bool isForward = false;
  int firstDay = 1;

  @override
  DateTimeRange build() {
    final now = DateTime.now();
    // Construir con el constructor evita arrastrar la hora actual y los problemas de Duration
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    return DateTimeRange(
      start: monday,
      end: DateTime(monday.year, monday.month, monday.day + 6),
    );
  }

  void next() {
    isForward = true;
    _shift(1);
  }

  void previous() {
    isForward = false;
    _shift(-1);
  }

  void newRange(DateTimeRange range) {
    state = range;
    firstDay = state.start.weekday;
  }

  /// direction: 1 = adelante, -1 = atrás
  void _shift(int direction) {
    if (_isFullMonth(state)) {
      final months = _monthCount(state);
      final s = state.start;
      final offset = months * direction;

      state = DateTimeRange(
        start: DateTime(s.year, s.month + offset, 1),
        // día 0 del mes siguiente al último mes del nuevo rango = su último día
        end: DateTime(s.year, s.month + offset + months, 0),
      );
    } else {
      final days = _dayCount(state) * direction;
      state = DateTimeRange(
        start: DateTime(state.start.year, state.start.month, state.start.day + days),
        end: DateTime(state.end.year, state.end.month, state.end.day + days),
      );
    }
    firstDay = state.start.weekday;
  }

  /// Cantidad de meses calendario que abarca el rango (inclusive).
  /// Ej: 1 ene – 31 mar → 3
  int _monthCount(DateTimeRange r) => (r.end.year - r.start.year) * 12 + (r.end.month - r.start.month) + 1;
}

@riverpod
String dailyAverage(Ref ref, String counterId) {
  final data = ref.watch(weeklyChartDataProvider(counterId));
  final average = data.reduce((a,b) => a+b) / _dayCount(ref.watch(weekRangeProvider));
  final averageStr = average.toStringAsFixed(1);
  return averageStr;
}

@riverpod
List<int> weeklyChartData(Ref ref, String counterId) {
  final entries = ref.watch(entriesProvider(counterId));
  final range = ref.watch(weekRangeProvider);
  final daily = _dataForWeek(entries, range);

  // Rangos medianos: se agrupan de 7 en 7 días para no saturar el gráfico
  if (_groupByWeek(daily.length)) return _groupInWeeks(daily);

  // NUEVO: rangos largos: se agrupan por mes calendario
  if (_groupByMonth(daily.length)) return _groupInMonths(daily, range);

  return daily;
}

@riverpod
ChartAxis chartLabels(Ref ref) {
  final range = ref.watch(weekRangeProvider);
  final firstDay = ref.watch(weekRangeProvider.notifier).firstDay;
  final count = _dayCount(range);
  final start = range.start;

  DateTime dateAt(int i) => DateTime(start.year, start.month, start.day + i);

  final tooltips = _buckets(range).map((b) {
    // NUEVO: un mes completo se muestra como "oct 2025". El primer y el último
    // bucket pueden ser parciales; ahí se muestra el rango exacto para no
    // sugerir que el número abarca todo el mes.
    if (_groupByMonth(count) && _isFullMonth(b)) {
      return '${_months[b.start.month - 1]} ${b.start.year}';
    }
    return HumanFormats.formatDateRange(b);
  }).toList();

  if (count <= 7) {
    const canonical = ['lun', 'mar', 'mie', 'jue', 'vie', 'sab', 'dom'];
    final startIndex = firstDay - 1;
    final rotated = [
      ...canonical.sublist(startIndex),
      ...canonical.sublist(0, startIndex),
    ];
    return ChartAxis(rotated.take(count).toList(), tooltips, LabelMode.all);
  }

  if (count <= 31) {
    return ChartAxis(
      List.generate(count, (i) => dateAt(i).day.toString()),
      tooltips,
      LabelMode.everyNth,
    );
  }

  if (_groupByWeek(count)) {
    final weekCount = (count / 7).ceil();
    return ChartAxis(
      // Cada barra se etiqueta con el mes del primer día de su semana
      List.generate(weekCount, (w) => _months[dateAt(w * 7).month - 1]),
      tooltips,
      LabelMode.onChange,
    );
  }

  if (_groupByMonth(count)) {
    return ChartAxis(
      _buckets(range).map((b) => _months[b.start.month - 1]).toList(),
      tooltips,
      LabelMode.everyNth,
    );
  }

  // Pendiente: decidir qué mostrar para 732 días o más.
  return ChartAxis(List.filled(count, ''), tooltips, LabelMode.all);
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

bool _groupByWeek(int dayCount) => dayCount > 31 && dayCount < 180;

// NUEVO: de 180 días hasta dos años. 731 es el máximo de dos años calendario
// completos (si uno es bisiesto), por eso el límite es <= 731.
bool _groupByMonth(int dayCount) => dayCount >= 180 && dayCount <= 731;

/// Suma los conteos diarios en bloques de 7 días.
/// El último bloque puede tener menos de 7 días si el rango no es múltiplo de 7.
List<int> _groupInWeeks(List<int> daily) {
  final weeks = <int>[];
  for (var i = 0; i < daily.length; i += 7) {
    final end = min(i + 7, daily.length);
    weeks.add(daily.sublist(i, end).fold(0, (sum, v) => sum + v));
  }
  return weeks;
}

// NUEVO
/// Suma los conteos diarios por mes calendario. Usa _buckets para saber
/// cuántos días tiene cada mes dentro del rango, así datos, etiquetas y
/// tooltips siempre coinciden. El primer y el último mes pueden ser parciales.
List<int> _groupInMonths(List<int> daily, DateTimeRange range) {
  final months = <int>[];
  var offset = 0;
  for (final bucket in _buckets(range)) {
    final days = _dayCount(bucket);
    months.add(daily.sublist(offset, offset + days).fold(0, (sum, v) => sum + v));
    offset += days;
  }
  return months;
}


/// Un DateTimeRange por cada barra del gráfico.
/// Si el rango se agrupa por semanas, cada bucket abarca hasta 7 días;
/// si se agrupa por meses, cada bucket es un mes calendario (recortado al rango);
/// si no, cada bucket es un solo día (start == end).
List<DateTimeRange> _buckets(DateTimeRange range) { // * Metodo para generar un DateTimeRange para cada barra del grafico. Luego usado para generar un String que indique ese valor y enviarlo al chart para que lo muestre
  final count = _dayCount(range);
  final start = _dateOnly(range.start);
  DateTime dateAt(int i) => DateTime(start.year, start.month, start.day + i);

  // NUEVO
  if (_groupByMonth(count)) {
    final end = _dateOnly(range.end);
    final buckets = <DateTimeRange>[];
    var cursor = start;
    while (!cursor.isAfter(end)) {
      // Día 0 del mes siguiente = último día de este mes
      final monthEnd = DateTime(cursor.year, cursor.month + 1, 0);
      final last = monthEnd.isAfter(end) ? end : monthEnd;
      buckets.add(DateTimeRange(start: cursor, end: last));
      cursor = DateTime(last.year, last.month, last.day + 1);
    }
    return buckets;
  }

  if (!_groupByWeek(count)) {
    return List.generate(
      count,
      (i) => DateTimeRange(start: dateAt(i), end: dateAt(i)),
    );
  }

  final weekCount = (count / 7).ceil();
  return List.generate(weekCount, (w) {
    final first = w * 7;
    final last = min(first + 6, count - 1); // la última semana puede ser parcial
    return DateTimeRange(start: dateAt(first), end: dateAt(last));
  });
}

// NUEVO: true si el bucket va del día 1 al último día de su mes
bool _isFullMonth(DateTimeRange bucket) {
  final dayAfterEnd = DateTime(bucket.end.year, bucket.end.month, bucket.end.day + 1);
  return bucket.start.day == 1 && dayAfterEnd.day == 1;
}


int _dayCount (DateTimeRange dateRange) {
  final firstDate = DateTime(dateRange.start.year, dateRange.start.month, dateRange.start.day);
  final lastDate = DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day);
  final daysIncludedInCount = lastDate.difference(firstDate).inDays + 1; //Se suma 1 para incluir el ultimo dia. Este es el valor de la cantidad de dias que abarca el weekrange
  return daysIncludedInCount;
}

enum LabelMode { all, everyNth, onChange }

class ChartAxis {
  const ChartAxis(this.labels, this.tooltips, this.mode)
    :assert (labels.length == tooltips.length, 'Labels and tooltips MUST have same length')
  ;
  final List<String> labels;
  final List<String> tooltips;
  final LabelMode mode;
}