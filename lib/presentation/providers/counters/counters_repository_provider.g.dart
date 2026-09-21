// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counters_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(counterRepository)
final counterRepositoryProvider = CounterRepositoryProvider._();

final class CounterRepositoryProvider
    extends
        $FunctionalProvider<
          CountersRepositories,
          CountersRepositories,
          CountersRepositories
        >
    with $Provider<CountersRepositories> {
  CounterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'counterRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$counterRepositoryHash();

  @$internal
  @override
  $ProviderElement<CountersRepositories> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CountersRepositories create(Ref ref) {
    return counterRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CountersRepositories value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CountersRepositories>(value),
    );
  }
}

String _$counterRepositoryHash() => r'b7df836fda2ed9bddc9c62ccc5aeae080f5ac1ee';
