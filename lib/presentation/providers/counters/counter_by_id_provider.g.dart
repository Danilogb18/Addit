// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_by_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getCounterById)
final getCounterByIdProvider = GetCounterByIdFamily._();

final class GetCounterByIdProvider
    extends $FunctionalProvider<Counter?, Counter?, Counter?>
    with $Provider<Counter?> {
  GetCounterByIdProvider._({
    required GetCounterByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getCounterByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getCounterByIdHash();

  @override
  String toString() {
    return r'getCounterByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Counter?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Counter? create(Ref ref) {
    final argument = this.argument as String;
    return getCounterById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Counter? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Counter?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetCounterByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getCounterByIdHash() => r'fc315f351ffcabe58ec0a045581c73928b6c45fe';

final class GetCounterByIdFamily extends $Family
    with $FunctionalFamilyOverride<Counter?, String> {
  GetCounterByIdFamily._()
    : super(
        retry: null,
        name: r'getCounterByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetCounterByIdProvider call(String id) =>
      GetCounterByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'getCounterByIdProvider';
}
