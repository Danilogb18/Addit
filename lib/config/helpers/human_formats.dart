

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HumanFormats {
  static String formatDate(DateTime date) {
    final formatted = DateFormat(
      'EEEE, d \'de\' MMMM \'de\' yyyy, HH:mm:ss',
      'es',
    ).format(date);

    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  static String formatDateToDDMMYY(DateTime date) {
    final format = DateFormat('dd/MM/yy');
    return format.format(date);
  }

  static String formatDateRange(DateTimeRange range, {String locale = 'es'}) {
    final start = range.start;
    final end = range.end;

    final dayFormat = DateFormat('d', locale);
    final monthFormat = DateFormat('MMM', locale);
    final yearFormat = DateFormat('y', locale);

    final sameYear = start.year == end.year;
    final sameMonth = sameYear && start.month == end.month;
    final sameDay = sameYear && sameMonth && start.day == end.day;

    final startDay = dayFormat.format(start);
    final endDay = dayFormat.format(end);
    final startMonth = _cleanMonth(monthFormat.format(start));
    final endMonth = _cleanMonth(monthFormat.format(end));
    final startYear = yearFormat.format(start);
    final endYear = yearFormat.format(end);

    if (sameDay) { //Un metodo simple para devolver la fecha sola si el inicio es lo mismo que el final
      return '$startDay de $startMonth de $startYear';
    }

    // Rangos de meses completos: se omiten los días
    if (_isFullMonth(range)) {
      if (sameMonth) {
        // sept de 2026
        return '$startMonth $startYear';
      }
      if (sameYear) {
        // ene-mar de 2026
        return '$startMonth-$endMonth de $endYear';
      }
      // nov de 2025-feb de 2026
      return '$startMonth de $startYear-$endMonth de $endYear';
    }

    if (sameMonth) {
      // 24-30 de sept del 2026
      return '$startDay-$endDay de $endMonth del $endYear';
    }

    if (sameYear) {
      // 24 de sept-3 de oct del 2026
      return '$startDay de $startMonth-$endDay de $endMonth del $endYear';
    }


    // 24 de dic del 2025-3 de ene del 2026
    //return '$startDay de $startMonth del $startYear-$endDay de $endMonth del $endYear';
    return '$startDay de $startMonth-$endDay de $endMonth del $endYear';
  }

  // intl en español devuelve las abreviaciones con punto ("sept.", "ene.")
  // si prefieres sin punto para que calce con tu formato de ejemplo, lo quitamos:
  static String _cleanMonth(String month) => month.replaceAll('.', '');
  static bool _isFullMonth(DateTimeRange bucket) {
    final dayAfterEnd = DateTime(bucket.end.year, bucket.end.month, bucket.end.day + 1);
    return bucket.start.day == 1 && dayAfterEnd.day == 1;
  }

}