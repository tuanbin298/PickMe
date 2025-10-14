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
}
