import 'package:intl/intl.dart';

/// Data formatting utilities
/// Veri formatlama yardımcı fonksiyonları

class Formatters {
  /// Format currency (Gold, Gems)
  static String formatCurrency(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  /// Format number with thousand separators
  static String formatNumber(int value) {
    final formatter = NumberFormat('#,###');
    return formatter.format(value);
  }

  /// Format decimal number
  static String formatDecimal(double value, {int decimals = 2}) {
    return value.toStringAsFixed(decimals);
  }

  /// Format percentage
  static String formatPercentage(double value, {int decimals = 0}) {
    return '${(value * 100).toStringAsFixed(decimals)}%';
  }

  /// Format date (dd/MM/yyyy)
  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  /// Format date and time (dd/MM/yyyy HH:mm)
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  /// Format time (HH:mm:ss)
  static String formatTime(DateTime time) {
    final formatter = DateFormat('HH:mm:ss');
    return formatter.format(time);
  }

  /// Format duration (e.g., "2h 30m")
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Format countdown timer (MM:SS)
  static String formatCountdown(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Format file size (e.g., "1.5 MB")
  static String formatFileSize(int bytes) {
    if (bytes >= 1073741824) {
      return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
    } else if (bytes >= 1048576) {
      return '${(bytes / 1048576).toStringAsFixed(2)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }
    return '$bytes B';
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
