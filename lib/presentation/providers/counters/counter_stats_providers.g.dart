// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_stats_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WeekOffset)
final weekOffsetProvider = WeekOffsetProvider._();

final class WeekOffsetProvider extends $NotifierProvider<WeekOffset, int> {
  WeekOffsetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weekOffsetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weekOffsetHash();

  @$internal
  @override
  WeekOffset create() => WeekOffset();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$weekOffsetHash() => r'952c45e76953c60119ceefea3394cfb66568fb65';

abstract class _$WeekOffset extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(entries)
final entriesProvider = EntriesFamily._();

final class EntriesProvider
    extends
        $FunctionalProvider<
          List<CounterEntry>,
          List<CounterEntry>,
          List<CounterEntry>
        >
    with $Provider<List<CounterEntry>> {
  EntriesProvider._({
    required EntriesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'entriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$entriesHash();

  @override
  String toString() {
    return r'entriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<CounterEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<CounterEntry> create(Ref ref) {
    final argument = this.argument as String;
    return entries(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CounterEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CounterEntry>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EntriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$entriesHash() => r'6215f22a21b893125dec8c69f12f9533ea1da667';

final class EntriesFamily extends $Family
    with $FunctionalFamilyOverride<List<CounterEntry>, String> {
  EntriesFamily._()
    : super(
        retry: null,
        name: r'entriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EntriesProvider call(String counterId) =>
      EntriesProvider._(argument: counterId, from: this);

  @override
  String toString() => r'entriesProvider';
}

@ProviderFor(weekRange)
final weekRangeProvider = WeekRangeProvider._();

final class WeekRangeProvider
    extends
        $FunctionalProvider<
          DateTimeRange<DateTime>,
          DateTimeRange<DateTime>,
          DateTimeRange<DateTime>
        >
    with $Provider<DateTimeRange<DateTime>> {
  WeekRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weekRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weekRangeHash();

  @$internal
  @override
  $ProviderElement<DateTimeRange<DateTime>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTimeRange<DateTime> create(Ref ref) {
    return weekRange(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTimeRange<DateTime> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTimeRange<DateTime>>(value),
    );
  }
}

String _$weekRangeHash() => r'da3e45fe4cd9a717e769bf837ab2708019a39db6';

@ProviderFor(weeklyChartData)
final weeklyChartDataProvider = WeeklyChartDataFamily._();

final class WeeklyChartDataProvider
    extends $FunctionalProvider<List<int>, List<int>, List<int>>
    with $Provider<List<int>> {
  WeeklyChartDataProvider._({
    required WeeklyChartDataFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'weeklyChartDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$weeklyChartDataHash();

  @override
  String toString() {
    return r'weeklyChartDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<int>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<int> create(Ref ref) {
    final argument = this.argument as String;
    return weeklyChartData(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<int>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyChartDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weeklyChartDataHash() => r'f3994f73c7eb70602e331e0ff37812fc75aaa143';

final class WeeklyChartDataFamily extends $Family
    with $FunctionalFamilyOverride<List<int>, String> {
  WeeklyChartDataFamily._()
    : super(
        retry: null,
        name: r'weeklyChartDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WeeklyChartDataProvider call(String counterId) =>
      WeeklyChartDataProvider._(argument: counterId, from: this);

  @override
  String toString() => r'weeklyChartDataProvider';
}
