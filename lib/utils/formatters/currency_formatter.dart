import 'package:intl/intl.dart';

/// Consistent `$X,XXX.XX` formatting for money values shown in the app.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _format = NumberFormat.currency(
    symbol: '\$ ',
    decimalDigits: 2,
  );

  static String format(num amount) => _format.format(amount);
}
