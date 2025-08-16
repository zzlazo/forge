import 'package:intl/intl.dart';

class SharedUtility {
  static String formatViewDateTime(DateTime dateTime, DateTime now) {
    late final String format;
    final yesterday = now.subtract(const Duration(days: 1));
    if (dateTime.isBefore(yesterday)) {
      format = "yyyy/MM/dd HH:mm";
    } else {
      format = "HH:mm";
    }
    return DateFormat(format).format(dateTime);
  }

  static const String nullText = "N/A";
  static String onlyNumberAlphabet(String text) {
    return text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }
}

enum SharedPrefKey {
  isAppInitialized("init");

  const SharedPrefKey(this.prefKey);
  final String prefKey;
}
