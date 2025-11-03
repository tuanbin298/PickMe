import 'package:intl/intl.dart';

class UtilsMethod {
  // Method format money
  static String formatMoney(double value) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return formatter.format(value);
  }

  // Method format time
  static String formatTime(String time) {
    try {
      final parsed = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("HH:mm").format(parsed);
    } catch (_) {
      return time;
    }
  }

  // Method format date
  static String formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
    } catch (_) {
      return isoString;
    }
  }
}
