import 'package:intl/intl.dart';

class DateHelper {
  static String getFormattedDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
