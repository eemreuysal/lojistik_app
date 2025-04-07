import 'package:intl/intl.dart';

class DateHelpers {
  static String formatTurkishDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'tr_TR').format(date);
  }

  static String formatDateAndTime(DateTime date) {
    return DateFormat('dd MMMM yyyy HH:mm', 'tr_TR').format(date);
  }
}
