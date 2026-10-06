// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_stats_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

@ProviderFor(WeekRange)
final weekRangeProvider = WeekRangeProvider._();

final class WeekRangeProvider
    extends $NotifierProvider<WeekRange, DateTimeRange<DateTime>> {
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
  WeekRange create() => WeekRange();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTimeRange<DateTime> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTimeRange<DateTime>>(value),
    );
  }
}

String _$weekRangeHash() => r'9d66a5eca0f85c0aa33036e42531bae6eacce598';

abstract class _$WeekRange extends $Notifier<DateTimeRange<DateTime>> {
  DateTimeRange<DateTime> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<DateTimeRange<DateTime>, DateTimeRange<DateTime>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTimeRange<DateTime>, DateTimeRange<DateTime>>,
              DateTimeRange<DateTime>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(dailyAverage)
final dailyAverageProvider = DailyAverageFamily._();

final class DailyAverageProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  DailyAverageProvider._({
    required DailyAverageFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'dailyAverageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dailyAverageHash();

  @override
  String toString() {
    return r'dailyAverageProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    final argument = this.argument as String;
    return dailyAverage(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DailyAverageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dailyAverageHash() => r'b872a0de349bfda27700683260294f24505611cf';

final class DailyAverageFamily extends $Family
    with $FunctionalFamilyOverride<String, String> {
  DailyAverageFamily._()
    : super(
        retry: null,
        name: r'dailyAverageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DailyAverageProvider call(String counterId) =>
      DailyAverageProvider._(argument: counterId, from: this);

  @override
  String toString() => r'dailyAverageProvider';
}

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

String _$weeklyChartDataHash() => r'95177926a5aa7376511e25c3bfb2c6c45c3a7c06';

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

@ProviderFor(chartLabels)
final chartLabelsProvider = ChartLabelsProvider._();

final class ChartLabelsProvider
    extends $FunctionalProvider<ChartAxis, ChartAxis, ChartAxis>
    with $Provider<ChartAxis> {
  ChartLabelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chartLabelsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chartLabelsHash();

  @$internal
  @override
  $ProviderElement<ChartAxis> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChartAxis create(Ref ref) {
    return chartLabels(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChartAxis value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChartAxis>(value),
    );
  }
}

String _$chartLabelsHash() => r'418b2efa07d2518a960c8b633cd343bf1e0fe9ac';
