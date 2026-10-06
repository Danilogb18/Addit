import 'package:addit/presentation/providers/counters/counter_stats_providers.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CounterBarChart extends StatefulWidget {
  const CounterBarChart({
    super.key,
    required this.data,
    required this.axis,
  });

  /// Un valor por barra. Su longitud coincide con axis.labels y axis.tooltips
  /// (7, 31 o ~26 elementos según el rango y la agrupación).
  final List<int> data;
  final ChartAxis axis;

  @override
  State<CounterBarChart> createState() => _CounterBarChartState();
}

class _CounterBarChartState extends State<CounterBarChart> {
  static const double _leftAxisSize = 28;
  static const double _maxBarWidth = 16;
  static const double _barGap = 5;

  // Índice (x) de la barra presionada; -1 = ninguna
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final interval = _calculateInterval(); // una sola vez por build

    return SizedBox(
      height: 200,
      child: LayoutBuilder(
        builder: (context, constraints) => BarChart(
          BarChartData(
            barGroups: _buildGroups(colors, constraints.maxWidth),
            titlesData: _buildTitles(interval),
            barTouchData: _buildTouchData(colors, theme.textTheme),
            gridData: FlGridData(
              show: true,
              checkToShowVerticalLine: (x) => false,
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Barras
  // ---------------------------------------------------------------------------

  List<BarChartGroupData> _buildGroups(ColorScheme colors, double maxWidth) {
    final baseColor = colors.primary;
    final highlightColor = Color.lerp(baseColor, colors.onSurface, 0.75)!;
    final barWidth = _barWidth(maxWidth);

    return List.generate(widget.data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: widget.data[index].toDouble(),
            width: barWidth,
            borderRadius: BorderRadius.zero,
            color: index == _touchedIndex ? highlightColor : baseColor,
          ),
        ],
      );
    });
  }

  /// Ancho por barra: el espacio disponible (sin el eje izquierdo) repartido
  /// entre las barras, menos un margen, con piso y techo para que nunca
  /// sea negativo ni desproporcionado.
  double _barWidth(double maxWidth) {
    final count = widget.data.length;
    if (count == 0) return _maxBarWidth;
    final slot = (maxWidth - _leftAxisSize) / count;
    return (slot - _barGap).clamp(1.0, _maxBarWidth).toDouble();
  }

  // ---------------------------------------------------------------------------
  // Ejes
  // ---------------------------------------------------------------------------

  FlTitlesData _buildTitles(double interval) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final labels = widget.axis.labels;
            final i = value.toInt();
            if (i < 0 || i >= labels.length) return const SizedBox.shrink();

            final show = switch (widget.axis.mode) {
              LabelMode.all => true,
              LabelMode.everyNth => _showEveryNth(i, labels.length),
              LabelMode.onChange => _showOnChange(i, labels),
            };
            if (!show) return const SizedBox.shrink();

            return SideTitleWidget(
              meta: meta, // según tu versión de fl_chart puede ser axisSide: meta.axisSide
              child: Text(labels[i], style: const TextStyle(fontSize: 11)),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: _leftAxisSize,
          interval: interval,
          getTitlesWidget: (value, meta) {
            // fl_chart también pide etiqueta para el máximo del eje aunque no
            // sea múltiplo del intervalo; aquí se descarta.
            if (value.toInt() % interval != 0) return const SizedBox.shrink();

            return Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 12),
            );
          },
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  double _calculateInterval() {
    final maxValue = widget.data.fold(0, (a, b) => a > b ? a : b);

    if (maxValue <= 5) return 1;
    if (maxValue <= 20) return 5;
    if (maxValue <= 100) return 20;
    return (maxValue / 5).roundToDouble();
  }

  // ---------------------------------------------------------------------------
  // Touch: tooltip + resaltado de la barra presionada
  // ---------------------------------------------------------------------------

  BarTouchData _buildTouchData(ColorScheme colors, TextTheme textTheme) {
    return BarTouchData(
      touchCallback: (event, response) {
        final spot = response?.spot;
        final next = (!event.isInterestedForInteractions || spot == null)
            ? -1
            : spot.touchedBarGroup.x;

        // Evita reconstruir el gráfico si no cambió la barra
        if (next != _touchedIndex) {
          setState(() => _touchedIndex = next);
        }
      },
      touchTooltipData: BarTouchTooltipData(
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipColor: (_) => colors.inverseSurface,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final index = group.x;
          if (index < 0 || index >= widget.axis.tooltips.length) return null;

          final count = rod.toY.toInt();
          return BarTooltipItem(
            '${widget.axis.tooltips[index]}\n',
            textTheme.labelMedium!.copyWith(
              color: colors.onInverseSurface,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: '$count ${count == 1 ? 'conteo' : 'conteos'}',
                style: textTheme.labelMedium!.copyWith(
                  color: colors.onInverseSurface,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ** Funciones helper

bool _showEveryNth(int i, int count, {int target = 5}) {
  final step = (count / target).ceil();
  return i % step == 0;
}

/// Muestra la etiqueta solo donde cambia respecto a la anterior (p. ej. el mes).
/// Se excluyen los índices 1 y el último (deduzco que para evitar que la
/// etiqueta quede pegada a la del índice 0 o cortada en el borde derecho;
/// ajusta el comentario si el motivo era otro).
bool _showOnChange(int i, List<String> labels) {
  if (i == 0) return true;
  final isEdge = i <= 1 || i >= labels.length - 1;
  return !isEdge && labels[i] != labels[i - 1];
}