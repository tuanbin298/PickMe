import 'package:intl/intl.dart';

class UtilsMethod {
  static String formatMoney(double value) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return formatter.format(value);
  }

  static String formatTime(String time) {
    try {
      final parsed = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("HH:mm").format(parsed);
    } catch (_) {
      return time;
    }
  }
}
