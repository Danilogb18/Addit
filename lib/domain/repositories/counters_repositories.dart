
import 'package:addit/domain/entities/counter.dart';

abstract class CountersRepositories {

  Future<List<Counter>> getCounters ();

  Future<Counter> updateCounter(Counter counter);


  Future<void> createCounter(Counter counter);

}