
import 'package:addit/domain/entities/counter.dart';
import 'package:addit/presentation/providers/counters/counters_provider.dart';
import 'package:addit/presentation/providers/counters/counters_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_by_id_provider.g.dart';

@riverpod
Counter? getCounterById (Ref ref, String id) {

  final list = ref.watch(countersProvider);
  Counter? counter;
  list.when(
    data: (data) {
      counter = data.firstWhere((c) => c.id == id);
    }, 
    error: (error, stackTrace) => null, 
    loading: () => null,
  );

  return counter;
}