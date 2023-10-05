

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String customFormat(
      [String pattern = 'dd-MM-yyyy', String locale = 'fr_FR']) {
    initializeDateFormatting(locale);
    return DateFormat(pattern, locale).format(this);
  }
}