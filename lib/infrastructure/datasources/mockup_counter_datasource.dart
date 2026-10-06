

import 'package:addit/domain/datasources/counters_datasource.dart';
import 'package:addit/domain/entities/counter.dart';
import 'package:addit/domain/entities/counter_entry.dart';

List<CounterEntry> generateEntries () {
  DateTime lastDate = DateTime.now();

  final newEntries = List.generate(50, (index) {
    lastDate = lastDate.add(const Duration(days: 1));
    return CounterEntry(dateTime: lastDate);
  });
  return newEntries;
}


List<Counter> mockupCounterList = [
  Counter(
    name: 'Hamburguesas 2026',
    icon: '🍔​',
    entries: [
      CounterEntry(dateTime: DateTime.now(), description: 'Karfels, karfels'),
      ...generateEntries()
    ]
  )
];


class MockupCounterDatasource extends CountersDatasource {
  @override
  Future<List<Counter>> getCounters() async {
    //aqui no habra espera para los datos porque es para prueba antes de implementar base de datos local
    return mockupCounterList;
  }

  @override
  Future<Counter> updateCounter(Counter counter) async {
    final index = mockupCounterList.indexWhere((c) => c.id == counter.id);
    if (index == -1) throw Exception('Counter no encontrado');
    mockupCounterList[index] = counter;
    return counter;
  }

  @override
  Future<void> createCounter(Counter counter) async {
    mockupCounterList.add(counter);
  }

}