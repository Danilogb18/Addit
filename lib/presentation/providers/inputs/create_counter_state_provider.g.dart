// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_counter_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateCounterStateProvider)
final createCounterStateProviderProvider = CreateCounterStateProviderFamily._();

final class CreateCounterStateProviderProvider
    extends
        $NotifierProvider<CreateCounterStateProvider, CreateCounterFormState> {
  CreateCounterStateProviderProvider._({
    required CreateCounterStateProviderFamily super.from,
    required Counter? super.argument,
  }) : super(
         retry: null,
         name: r'createCounterStateProviderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$createCounterStateProviderHash();

  @override
  String toString() {
    return r'createCounterStateProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CreateCounterStateProvider create() => CreateCounterStateProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateCounterFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateCounterFormState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CreateCounterStateProviderProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$createCounterStateProviderHash() =>
    r'6141fc12ada057a20074730a5545bfba252feb77';

final class CreateCounterStateProviderFamily extends $Family
    with
        $ClassFamilyOverride<
          CreateCounterStateProvider,
          CreateCounterFormState,
          CreateCounterFormState,
          CreateCounterFormState,
          Counter?
        > {
  CreateCounterStateProviderFamily._()
    : super(
        retry: null,
        name: r'createCounterStateProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CreateCounterStateProviderProvider call(Counter? counter) =>
      CreateCounterStateProviderProvider._(argument: counter, from: this);

  @override
  String toString() => r'createCounterStateProviderProvider';
}

abstract class _$CreateCounterStateProvider
    extends $Notifier<CreateCounterFormState> {
  late final _$args = ref.$arg as Counter?;
  Counter? get counter => _$args;

  CreateCounterFormState build(Counter? counter);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<CreateCounterFormState, CreateCounterFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CreateCounterFormState, CreateCounterFormState>,
              CreateCounterFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
