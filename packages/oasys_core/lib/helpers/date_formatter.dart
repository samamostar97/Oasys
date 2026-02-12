import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _date = DateFormat('dd.MM.yyyy');
  static final DateFormat _dateTime = DateFormat('dd.MM.yyyy HH:mm');

  static String date(DateTime value) => _date.format(value);

  static String dateTime(DateTime value) => _dateTime.format(value);
}
