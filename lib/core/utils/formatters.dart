/// Formatting utilities for currency, percentages, and dates.

class Formatters {
  Formatters._();

  /// Format as Indian Rupee currency.
  static String currency(double amount) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();

    String formatted;
    if (absAmount >= 10000000) {
      formatted = '${(absAmount / 10000000).toStringAsFixed(2)} Cr';
    } else if (absAmount >= 100000) {
      formatted = '${(absAmount / 100000).toStringAsFixed(2)} L';
    } else {
      // Indian numbering system
      final intPart = absAmount.toInt();
      formatted = _indiaFormat(intPart);
    }

    return '${isNegative ? "-" : ""}₹$formatted';
  }

  /// Format as short currency (without ₹ symbol).
  static String shortCurrency(double amount) {
    if (amount >= 10000000) return '${(amount / 10000000).toStringAsFixed(1)}Cr';
    if (amount >= 100000) return '${(amount / 100000).toStringAsFixed(1)}L';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }

  /// Indian number formatting (e.g., 1,00,000).
  static String _indiaFormat(int number) {
    final str = number.toString();
    if (str.length <= 3) return str;

    final lastThree = str.substring(str.length - 3);
    final remaining = str.substring(0, str.length - 3);

    final buffer = StringBuffer();
    for (int i = 0; i < remaining.length; i++) {
      if (i > 0 && (remaining.length - i) % 2 == 0) {
        buffer.write(',');
      }
      buffer.write(remaining[i]);
    }
    buffer.write(',');
    buffer.write(lastThree);

    return buffer.toString();
  }

  /// Format percentage.
  static String percentage(double value) {
    return '${(value * 100).toInt()}%';
  }

  /// Format relative time.
  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
