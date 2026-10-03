import 'package:e1547/shared/shared.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

final DateFormat logFileDateFormat = DateFormat('yyyy-MM-dd-HH-mm-ss-SSS');

const String logFileExtension = '.jsonl';

class LogFileInfo {
  LogFileInfo({required this.path, required this.date, required this.type});

  factory LogFileInfo.parse(String path) {
    String raw = basenameWithoutExtension(path);
    String? type = extension(raw);
    if (type.isNotEmpty) {
      type = type.substring(1);
      raw = basenameWithoutExtension(raw);
    } else {
      type = null;
    }
    DateTime date = logFileDateFormat.parse(raw);
    return LogFileInfo(path: path, date: date, type: type);
  }

  final String path;
  final DateTime date;
  final String? type;

  @override
  String toString() =>
      // This stays on the platform locale on purpose: it is a data layer
      // without a context, and log file metadata should not follow the app
      // language. The logs UI formats dates itself via [DateFormatting].
      '${DateFormatting.dateTime(date)} ${type != null ? ' ($type)' : ''}';
}
