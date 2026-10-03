import 'dart:io';

import 'package:intl/date_symbol_data_local.dart' as intl_dates;
import 'package:intl/intl.dart';

/// Primitive default date formatting.
///
/// Has no translation support and follows the platform locale.
/// Prefer the localized variants in `shared/widget/date.dart`
/// for any user-visible dates.
///
/// The logs UI and log file names keep using these on purpose:
/// they are technical diagnostics whose timestamps
/// should not depend on the app language.
abstract final class DateFormatting {
  static Future<void> ensureInitialized() =>
      intl_dates.initializeDateFormatting();

  static String dateTime(DateTime dateTime) =>
      DateFormat.yMd(Platform.localeName).add_jm().format(dateTime);
  static String date(DateTime date) =>
      DateFormat.yMd(Platform.localeName).format(date);
  static String time(DateTime time) =>
      DateFormat.jm(Platform.localeName).format(time);
}
