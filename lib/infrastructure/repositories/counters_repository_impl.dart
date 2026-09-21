

import 'package:addit/domain/datasources/counters_datasource.dart';
import 'package:addit/domain/entities/counter.dart';
import 'package:addit/domain/repositories/counters_repositories.dart';

class CountersRepositoryImpl extends CountersRepositories {

  final CountersDatasource datasource;

  new({required this.datasource});

  @override
  Future<List<Counter>> getCounters() {
    return datasource.getCounters();
  }

  @override
  Future<Counter> updateCounter(Counter counter) {
    return datasource.updateCounter(counter);
  }

  @override
  Future<void> createCounter(Counter counter) {
    return datasource.createCounter(counter);
  }

}