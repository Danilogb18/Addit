import 'package:addit/domain/entities/counter.dart';
import 'package:addit/domain/entities/counter_entry.dart';
import 'package:addit/presentation/providers/counters/counters_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counters_provider.g.dart';

@riverpod
class Counters extends _$Counters {
  @override
  Future<List<Counter>> build() {
    final repository = ref.watch(counterRepositoryProvider);
    return repository.getCounters();
  }

  Future<void> increment (String counterId) async{
    final repository = ref.read(counterRepositoryProvider);
    final list = state.value;
    if (list == null) return;

    final counter = list.firstWhere((c) => c.id == counterId);
    final newCounterEntry = CounterEntry(dateTime: DateTime.now());
    counter.entries.add(newCounterEntry);

    //Llamar a la actualizacion en el datasource
    await repository.updateCounter(counter);

    state = AsyncData([
      for (final c in list)
        if (c.id == counterId) counter else c
    ]);
    
  }

  Future<void> createCounter(String name, String icon, List<CounterEntry> entries, String? description) async {
    final repository = ref.read(counterRepositoryProvider);
    final list = state.value;
    if (list == null) return;

    final newCounter = Counter(name: name, icon: icon, entries: entries, description: description);
    await repository.createCounter(newCounter);

    state = AsyncData([...list, newCounter]);
    ref.invalidateSelf();
  }

  Future<void> updateEntry (Counter counter, CounterEntry previousEntry, String description, DateTime dateTime) async {
    final repository = ref.read(counterRepositoryProvider);
    
    // Actualizar el estado y hacer cambios en el datasource
    //Tengo que encontrar el entry en la lista del counter, hacerle un copyWith, y reemplazar esa misma posicion por el nuevo
    final entryIndex = counter.entries.indexWhere((e) => e.id == previousEntry.id);
    final updatedEntry = previousEntry.copyWith(description: description, dateTime: dateTime);
    counter.entries[entryIndex] = updatedEntry;

    await repository.updateCounter(counter);

    state = AsyncData([
      for (final c in state.value!)
        if (c.id == counter.id) counter else c
    ]);
  }

}