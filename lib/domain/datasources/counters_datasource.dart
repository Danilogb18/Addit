

import 'package:addit/domain/entities/counter.dart';

abstract class CountersDatasource {

  Future<List<Counter>> getCounters ();

  Future<Counter> updateCounter(Counter counter);

  Future<void> createCounter(Counter counter);

}