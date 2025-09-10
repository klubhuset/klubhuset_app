import 'package:intl/intl.dart';

class DateHelper {
  static String getFormattedDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  static String getFormattedShortDate(DateTime date) {
    return DateFormat('dd-MM').format(date);
  }

  static String getFormattedTime(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('HH:mm').format(date);
  }
}
