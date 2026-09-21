

import 'package:intl/intl.dart';

class HumanFormats {
  static String formatDate(DateTime date) {
    final formatted = DateFormat(
      'EEEE, d \'de\' MMMM \'de\' yyyy, HH:mm:ss',
      'es',
    ).format(date);

    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}