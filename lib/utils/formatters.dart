import 'package:intl/intl.dart';

class Fmt {
  static final _currency = NumberFormat('#,##0', 'en_NG');

  /// Format a number as Nigerian Naira: ₦1,234,567
  static String currency(double amount) {
    return '₦${_currency.format(amount)}';
  }

  /// Friendly relative date label
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'Today, ${DateFormat('h:mm a').format(date)}';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return DateFormat('EEEE').format(date);
    return DateFormat('MMM d').format(date);
  }
}
