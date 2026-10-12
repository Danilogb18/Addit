
import 'package:addit/config/helpers/human_formats.dart';
import 'package:addit/domain/entities/counter.dart';
import 'package:addit/presentation/providers/counters/counter_stats_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CounterCard extends StatelessWidget {

  final Counter counter;
  final Future<void> Function(String counterId) incrementFunction;

  const CounterCard({
    super.key, 
    required this.counter,
    required this.incrementFunction
  });

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final counterLastEntry = counter.latestEntry;

    return SizedBox(
      //height: 150,
      width: double.infinity,
      child: InkWell(
        //borderRadius: BorderRadius.circular(20), // ** Esto debe matchear el border de la Card , que está en app_theme.dart
        onTap: () {
          context.push('counter/${counter.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CounterNameAndIcon(counter: counter, textTheme: textTheme),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${counter.count}', style: textTheme.displayLarge,),
                        IconButton(
                          onPressed: () => incrementFunction(counter.id), 
                          icon: const Icon(Icons.add_circle_outline, size: 55,)
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100, child: VerticalDivider(thickness: 1.5,width: 40, )),
                  Expanded(
                    child: counter.entries.isNotEmpty
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Última entrada:', style: textTheme.titleMedium,),
                          Text(HumanFormats.relativeDay(counterLastEntry!.dateTime), style: textTheme.bodyLarge,),
                          counterLastEntry.description.isEmpty ? const SizedBox.shrink() : Text(counterLastEntry.description, style: textTheme.labelMedium?.copyWith(color: colors.outline),),
                          SizedBox(height: 10,),
                          _MiniChart(counter: counter)
                        ],
                      )
                      : const Text('Aún no hay entradas para este contador'),
                  )
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}

class _CounterNameAndIcon extends StatelessWidget {
  const _CounterNameAndIcon({
    required this.counter,
    required this.textTheme,
  });

  final Counter counter;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(counter.icon, style: textTheme.displayLarge,),
        const SizedBox(width: 10,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(counter.name, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),),
              (counter.description == null || counter.description!.trim().isEmpty)
                ? const SizedBox.shrink()
                : Text(counter.description!,maxLines: 2, overflow: TextOverflow.ellipsis,)
            ],
          )
        ),
      ],
    );
  }
}

class _MiniChart extends ConsumerWidget {

  final Counter counter;

  const _MiniChart({
    required this.counter
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bars = ref.watch(last7DaysProvider(counter.entries));
    final maxBar = bars.reduce((a, b) => a > b ? a : b).clamp(1, 999);
    final color = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final v in bars)
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 6 + 34 * (v / maxBar),
                decoration: BoxDecoration(
                  color: v == 0 ? color.withAlpha(50) : color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}