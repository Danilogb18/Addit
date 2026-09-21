
import 'package:addit/domain/repositories/counters_repositories.dart';
import 'package:addit/infrastructure/datasources/mockup_counter_datasource.dart';
import 'package:addit/infrastructure/repositories/counters_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counters_repository_provider.g.dart';

//final countersRepository = Provider((ref) => CountersRepositoryImpl(datasource: MockupCounterDatasource()));

@riverpod
CountersRepositories counterRepository(Ref ref) {
  return CountersRepositoryImpl(datasource: MockupCounterDatasource());
}