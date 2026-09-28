import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CounterBarChart extends StatelessWidget {
  const CounterBarChart({
    super.key, 
    required this.weeklyData,
    required this.labels
  });

  // Índice 0 = lunes, ..., 6 = domingo (o el orden que prefieras)
  final List<int> weeklyData;
  final List<String> labels;


  double _calculateInterval() {
    final maxValue = weeklyData.fold(0, (previousValue, element) => previousValue > element ? previousValue : element,);
    
    if (maxValue <= 5) return 1;
    if (maxValue <= 20) return 5;
    if (maxValue <= 100) return 20;
    return (maxValue / 5).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          // maxY define el techo del eje Y; si no lo pones, fl_chart
          // lo calcula solo, pero es más predecible fijarlo
          //maxY: (weeklyData.reduce((a, b) => a > b ? a : b) + 1).toDouble(),
          barGroups: List.generate(weeklyData.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: weeklyData[index].toDouble(),
                  width: 16,
                  borderRadius: BorderRadius.circular(0),
                  color: colors.primary
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // ** Aqui puedo meter la comprobacion, si son 7 dias, mostrar todas las etiquetas, si son mas , decidir, pero se puede hacer aquí.
                  // * Para de 7-31 dias, mostrar 31 datos. para mas de eso, mostrar agrupacion por semana, para rango de hasta 6 meses.
                  // * De 6 meses a 3 años, agrupar por mes. 
                  return Text(labels[value.toInt()]);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, 
                reservedSize: 28, 
                interval: _calculateInterval(),
                getTitlesWidget: (value, meta) {
                  // Si el valor no es múltiplo del intervalo, no dibujes nada
                  if ( value.toInt() % _calculateInterval() != 0) return const SizedBox.shrink();
                  
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: true, checkToShowVerticalLine: (x) => false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
