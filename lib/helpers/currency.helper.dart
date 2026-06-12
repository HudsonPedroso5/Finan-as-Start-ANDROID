import 'package:intl/intl.dart';

class CurrencyHelper {
  static String format(
    double amount, {
    required String symbol,
    String locale = 'en_US',
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
}
