
import 'package:addit/config/helpers/human_formats.dart';
import 'package:addit/domain/entities/counter.dart';
import 'package:addit/domain/entities/counter_entry.dart';
import 'package:addit/presentation/providers/counters/counter_stats_providers.dart';
import 'package:addit/presentation/providers/counters/counters_provider.dart';
import 'package:addit/presentation/widgets/stats/counter_bar_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterInfoScreen extends ConsumerWidget {

  final String id;

  const CounterInfoScreen({
    super.key, 
    required this.id
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final counters = ref.watch(countersProvider);

    return counters.when(
      data: (data) {
        final counter = data.firstWhere((element) => element.id == id,);
        return Scaffold(
          appBar: AppBar(title: const Text('Información'),),
          body: _CounterInfoView(counter: counter,),
        );
      },
      error: (error, stackTrace) => Center(child: Text('There was an error: $error'),), 
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class _CounterInfoView extends ConsumerWidget {

  final Counter counter;

  const _CounterInfoView({
    required this.counter
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textTheme = Theme.of(context).textTheme;
    //final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    final counterEntriesOrdered = [...counter.entries]..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              _CounterIconAndTitle(size: size, textTheme: textTheme, counter: counter),
              const SizedBox(height: 30,),
              _SectionTitle(textTheme: textTheme, title: 'Estadísticas',),
              const SizedBox(height: 5,),
              _StatsVisualizer(textTheme: textTheme, counter: counter, ref: ref,),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SectionTitle(textTheme: textTheme, title: 'Lista de entradas',),
                  IconButton.filled(
                    onPressed: () {
                      ref.read(countersProvider.notifier).increment(counter.id);
                    }, 
                    icon: const Icon(Icons.add)
                  )
                ],
              ),
              const SizedBox(height: 5,),
      
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column( // ** Trabajo con una column generando con un for en vez de un ListView.separated , para que el key sirva para detectar una nueva entry agregada y que se anime solamente la nueva creada
                    children: [
                      for (int i = 0; i < counterEntriesOrdered.length; i++) ...[
                        if (i > 0) const Divider(),
                        Builder(
                          key: ValueKey(counterEntriesOrdered[i].id),
                          builder: (context) {
                            final counterEntry = counterEntriesOrdered[i];
                            return FadeInRight(
                              child: ListTile(
                                horizontalTitleGap: 8,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                                visualDensity: const VisualDensity(vertical: -3),
                                leading: Text(counter.icon, style: textTheme.titleLarge),
                                title: _EntryDescription(counterEntry: counterEntry, textTheme: textTheme),
                                subtitle: Text(HumanFormats.formatDate(counterEntry.dateTime)),
                                trailing: const Icon(Icons.keyboard_arrow_right, size: 30),
                                onTap: () => _showEditEntrySheet(context, ref, counter, counterEntry),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 100,)
      
            ],
          ),
        ),
      ),
    );
  }
}

class _EntryDescription extends StatelessWidget {
  const new({
    required this.counterEntry,
    required this.textTheme,
  });

  final CounterEntry counterEntry;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      counterEntry.description.trim() == ''
        ? 'Sin descripción'
        : counterEntry.description
      , 
      style: counterEntry.description.trim() == ''
        ? textTheme.bodyMedium?.copyWith(color: Colors.black54)
        : textTheme.bodyMedium?.copyWith(color: Colors.black87)
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const new({
    required this.textTheme,
    required this.title
  });

  final TextTheme textTheme;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, textAlign: TextAlign.left, style: textTheme.titleLarge,)
    );
  }
}



class _CounterIconAndTitle extends StatelessWidget {
  const new({
    required this.size,
    required this.textTheme,
    required this.counter,
  });

  final Size size;
  final TextTheme textTheme;
  final Counter counter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black12,
              )
            ),
            child: CircleAvatar(
              radius: 50, 
              backgroundColor: Colors.white,
              child: Text(counter.icon , style: textTheme.displayLarge,), 
            )
          ),
      
          const SizedBox(width: 20,),
      
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(counter.name, style: textTheme.headlineSmall,),
                Text('Total hasta la fecha: ${counter.count}', style: textTheme.bodyMedium?.copyWith(color: Colors.black54),)
              ],
            ),
          )
          
        ],
      ),
    );
  }
}

Future<void> _showEditEntrySheet(BuildContext context, WidgetRef ref, Counter counter, CounterEntry entry) async {
  final descriptionController = TextEditingController(text: entry.description);
  DateTime selectedDateTime = entry.dateTime;

  final result = await showModalBottomSheet<CounterEntry>(
    context: context,
    isScrollControlled: true, // necesario para que el sheet suba cuando aparece el teclado
    builder: (context) {
      return SafeArea(
        child: Padding(
          // evita que el teclado tape los campos
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                    maxLength: 40,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Fecha: ${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDateTime,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setSheetState(() {
                          selectedDateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            selectedDateTime.hour,
                            selectedDateTime.minute,
                          );
                        });
                      }
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Hora: ${TimeOfDay.fromDateTime(selectedDateTime).format(context)}'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                      );
                      if (time != null) {
                        setSheetState(() {
                          selectedDateTime = DateTime(
                            selectedDateTime.year,
                            selectedDateTime.month,
                            selectedDateTime.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        CounterEntry(
                          dateTime: selectedDateTime,
                          description: descriptionController.text,
                        ),
                      );
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );

  if (result != null) {
    ref.read(countersProvider.notifier).updateEntry(counter, entry, descriptionController.value.text, selectedDateTime);
  }
}


class _StatsVisualizer extends StatelessWidget {

  final TextTheme textTheme;
  final Counter counter;
  final WidgetRef ref;

  const _StatsVisualizer({
    required this.textTheme,
    required this.counter,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(weeklyChartDataProvider(counter.id));
    final dateRange = ref.watch(weekRangeProvider);
    final average = data.reduce((a,b) => a+b) / data.length;
    final averageStr = average.toString().substring(0, 3);

    final bool isDataInWeek = data.any((element) => element > 0,); // Si hay algun elemento mayor que cero, hay data

    bool isForward = ref.watch(weekRangeProvider.notifier).isForward;
    //final String dateRangeString = '${HumanFormats.formatDateToDDMMYY(dateRange.start)} - ${HumanFormats.formatDateToDDMMYY(dateRange.end)}';
    final String dateRangeString = HumanFormats.formatDateRange(dateRange);
    return FadeInRight(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 20, 5, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                ? CounterBarChart(weeklyData: data, labels: ref.watch(chartLabelsProvider),)
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

  if (range != null) {
    ref.read(weekRangeProvider.notifier).newRange(range);
  }
}