import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  return '${NumberFormat.decimalPattern().format(amount)} Ar';
}