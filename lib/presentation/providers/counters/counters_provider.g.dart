// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counters_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Counters)
final countersProvider = CountersProvider._();

final class CountersProvider
    extends $AsyncNotifierProvider<Counters, List<Counter>> {
  CountersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'countersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countersHash();

  @$internal
  @override
  Counters create() => Counters();
}

String _$countersHash() => r'1e87725f8b8a989394d7611e4b8b52c1914a50e5';

abstract class _$Counters extends $AsyncNotifier<List<Counter>> {
  FutureOr<List<Counter>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Counter>>, List<Counter>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Counter>>, List<Counter>>,
              AsyncValue<List<Counter>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
