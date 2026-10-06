import 'package:addit/config/helpers/human_formats.dart';
import 'package:addit/domain/entities/counter.dart';
import 'package:addit/presentation/providers/counters/counter_stats_providers.dart';
import 'package:addit/presentation/widgets/stats/counter_bar_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsVisualizer extends StatelessWidget {

  final TextTheme textTheme;
  final Counter counter;
  final WidgetRef ref;

  const StatsVisualizer({
    super.key,
    required this.textTheme,
    required this.counter,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(weeklyChartDataProvider(counter.id));
    final dateRange = ref.watch(weekRangeProvider);
    final averageStr = ref.watch(dailyAverageProvider(counter.id));

    final bool isDataInWeek = data.any((element) => element > 0,); // Si hay algun elemento mayor que cero, hay data

    bool isForward = ref.watch(weekRangeProvider.notifier).isForward;
    //final String dateRangeString = '${HumanFormats.formatDateToDDMMYY(dateRange.start)} - ${HumanFormats.formatDateToDDMMYY(dateRange.end)}';
    final String dateRangeString = HumanFormats.formatDateRange(dateRange);
    return FadeInRight(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: SegmentedButton(
                  segments: [
                    ButtonSegment(value: _getWeekDateTimeRange(), label: Text('sem')),
                    ButtonSegment(value: _getMonthDateTimeRange(), label: Text('mes')),
                    ButtonSegment(value: _getLastSixMonthsDateTimeRange(), label: Text('6m')),
                    ButtonSegment(value: _getYearDateTimeRange(), label: Text('año')),
                  ], 
                  selected: {ref.watch(weekRangeProvider)},
                  showSelectedIcon: false,
                  onSelectionChanged: (p0) {
                    ref.read(weekRangeProvider.notifier).newRange(p0.first);
                  },

                ),
              ),
              SizedBox(height: 10,),
              Text('PROMEDIO', style: textTheme.labelLarge,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(averageStr, style: textTheme.displaySmall),
                  const SizedBox(width: 2,),
                  Text('por día', style: textTheme.labelMedium),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DateRangeText(dateRangeString: dateRangeString, textTheme: textTheme, isForward: isForward,),
                  SizedBox(height: 30, width: 20, child: IconButton(onPressed: () {_selectRange(context, ref);}, icon: const Icon(Icons.edit), iconSize: 15,)),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      isForward = false;
                      ref.read(weekRangeProvider.notifier).previous();
                    }, 
                    icon: const Icon(Icons.arrow_left_outlined)
                  ),
                  IconButton(
                    onPressed: () {
                      isForward = true;
                      ref.read(weekRangeProvider.notifier).next();
                    }, 
                    icon: const Icon(Icons.arrow_right_outlined)
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              isDataInWeek
                ? CounterBarChart(data: data, axis: ref.watch(chartLabelsProvider),)
                : const SizedBox(height: 200, child: Center(child: Text('No hay datos para este período de tiempo.'),)), // El height es 200 porque es el mismo que el del barchart
              const SizedBox(height: 5,),
            ],
          ),
        )
      ),
    );
  }
}

class DateRangeText extends StatelessWidget {

  final bool isForward;

  const new({
    super.key,
    required this.dateRangeString,
    required this.textTheme,
    required this.isForward
  });

  final String dateRangeString;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 200),
        reverse: !isForward,
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(primaryAnimation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(-1, 0),
              ).animate(secondaryAnimation),
              child: child,
            ),
          );
        },
        child: Text(dateRangeString, key: ValueKey<String>(dateRangeString)),
      ),
    );
  }
}

Future<void> _selectRange(BuildContext context, WidgetRef ref) async {
  final DateTimeRange? range = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2020),
    lastDate: DateTime(2030),
    initialDateRange: DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(days: 7)),
    ),

  );

  if (range == null) return; // el usuario canceló

  final days = range.end.difference(range.start).inDays + 1; // inclusive, igual que _dayCount
  if (days > 731) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('El rango máximo es de dos años')),
    );
    return;
  }

  ref.read(weekRangeProvider.notifier).newRange(range);
}


// * Lo de abajo son metodos para devolver el dateTimeRange para el selector de arriba
DateTimeRange _getWeekDateTimeRange() {
  final now = DateTime.now();
  final hoy = DateTime(now.year, now.month, now.day);
  // weekday: lunes = 1 ... domingo = 7
  final lunes = hoy.subtract(Duration(days: hoy.weekday - 1));
  final domingo = lunes.add(const Duration(days: 6));
  return DateTimeRange(
    start: lunes,
    end: DateTime(domingo.year, domingo.month, domingo.day),
  );
}

DateTimeRange _getMonthDateTimeRange() {
  final now = DateTime.now();
  final inicio = DateTime(now.year, now.month, 1);
  // Día 0 del mes siguiente = último día del mes actual
  final ultimoDia = DateTime(now.year, now.month + 1, 0);
  return DateTimeRange(
    start: inicio,
    end: DateTime(ultimoDia.year, ultimoDia.month, ultimoDia.day),
  );
}

DateTimeRange _getLastSixMonthsDateTimeRange() {
  final now = DateTime.now();
  // Mes actual + los 5 anteriores = 6 meses
  final inicio = DateTime(now.year, now.month - 5, 1);
  final ultimoDia = DateTime(now.year, now.month + 1, 0);
  return DateTimeRange(
    start: inicio,
    end: DateTime(ultimoDia.year, ultimoDia.month, ultimoDia.day + 1),
  );
}

DateTimeRange _getYearDateTimeRange() {
  final now = DateTime.now();
  return DateTimeRange(
    start: DateTime(now.year, 1, 1),
    end: DateTime(now.year, 13, 0),
  );
}