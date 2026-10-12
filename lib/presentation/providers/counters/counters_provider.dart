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

    final newEntriesList = [...counter.entries];
    newEntriesList.add(newCounterEntry);
    
    final newCounter = counter.copyWith(entries: newEntriesList);

    //Llamar a la actualizacion en el datasource
    await repository.updateCounter(newCounter);

    state = AsyncData([
      for (final c in list)
        if (c.id == counterId) newCounter else c
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

  Future<void> editCounter(String counterId, String name, String icon, List<CounterEntry> entries, String? description) async {
    // si quiero editar, tengo que encontrar su indice en la lista y reemplazarlo por la nueva version. y luego en el repositorio simplemente actualizar el counter como cuando le cambian las entradas
    final repository = ref.read(counterRepositoryProvider);
    final list = state.value;
    if (list == null) return;

    final newCounter = Counter(id: counterId, name: name, icon: icon, entries: entries, description: description);
    await repository.updateCounter(newCounter);

    final List<Counter> newList = [];
    for (var c in list) {
      c.id == counterId ? newList.add(newCounter) : newList.add(c);
    }
    state = AsyncData([...newList]);
    ref.invalidateSelf();
  }

  Future<void> deleteCounter(Counter counter) async {
    final repository = ref.read(counterRepositoryProvider);
    final list = state.value;
    if (list == null) return;

    await repository.deleteCounter(counter);
    ref.invalidateSelf();
  }

  Future<void> updateEntry (Counter counter, CounterEntry previousEntry, String description, DateTime dateTime) async {
    final repository = ref.read(counterRepositoryProvider);
    
    // Actualizar el estado y hacer cambios en el datasource
    //Tengo que encontrar el entry en la lista del counter, hacerle un copyWith, y reemplazar esa misma posicion por el nuevo
    final entryIndex = counter.entries.indexWhere((e) => e.id == previousEntry.id);
    final updatedEntry = previousEntry.copyWith(description: description, dateTime: dateTime);
    
    final updatedEntries = [...counter.entries];
    updatedEntries[entryIndex] = updatedEntry;

    final updatedCounter = counter.copyWith(entries: updatedEntries); // ** Nuevo counter, necesario hacerlo asi para que riverpod lo detexte como un cambio de estado

    await repository.updateCounter(updatedCounter);

    state = AsyncData([
      for (final c in state.value!)
        if (c.id == counter.id) updatedCounter else c
    ]);
  }

  Future<void> deleteEntry(Counter counter, CounterEntry entry) async {
  final repository = ref.read(counterRepositoryProvider);
  final list = state.value;
  if (list == null) return;

  // Lista nueva, sin mutar la original
  final newEntries = counter.entries
      .where((element) => element.id != entry.id)
      .toList();

  final newCounter = counter.copyWith(entries: newEntries);

  // Persistir el counter nuevo
  await repository.updateCounter(newCounter);

  state = AsyncData([
    for (final c in list)
      if (c.id == counter.id) newCounter else c
  ]);
}

}