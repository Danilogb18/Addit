// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_counter_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateCounterStateProvider)
final createCounterStateProviderProvider =
    CreateCounterStateProviderProvider._();

final class CreateCounterStateProviderProvider
    extends
        $NotifierProvider<CreateCounterStateProvider, CreateCounterFormState> {
  CreateCounterStateProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createCounterStateProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createCounterStateProviderHash();

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
}

String _$createCounterStateProviderHash() =>
    r'74a3a2394e314b75c7504239151380055f43255e';

abstract class _$CreateCounterStateProvider
    extends $Notifier<CreateCounterFormState> {
  CreateCounterFormState build();
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
    return element.handleCreate(ref, build);
  }
}
