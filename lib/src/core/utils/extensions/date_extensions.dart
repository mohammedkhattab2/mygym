import 'package:intl/intl.dart';

/// Extension methods on DateTime
extension DateExtensions on DateTime {
  /// Format date as 'Jan 15, 2024'
  String get formatted => DateFormat.yMMMd().format(this);

  /// Format date as '15/01/2024'
  String get formattedShort => DateFormat('dd/MM/yyyy').format(this);

  /// Format time as '10:30 AM'
  String get formattedTime => DateFormat.jm().format(this);

  /// Format as 'Jan 15, 2024 at 10:30 AM'
  String get formattedWithTime => DateFormat.yMMMd().add_jm().format(this);

  /// Format as 'Monday, January 15, 2024'
  String get formattedFull => DateFormat.yMMMMEEEEd().format(this);

  /// Format as relative time (e.g., '2 hours ago', 'Yesterday')
  String get relative {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat.EEEE().format(this);
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Check if date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if date is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Check if date is in the same week as now
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if date is in the same month as now
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Get start of day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get start of week (Monday)
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).startOfDay;

  /// Get end of week (Sunday)
  DateTime get endOfWeek => add(Duration(days: 7 - weekday)).endOfDay;

  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Get age in years
  int get age {
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }

  /// Add days
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract days
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Add months
  DateTime addMonths(int months) {
    var newMonth = month + months;
    var newYear = year;
    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }
    return DateTime(newYear, newMonth, day, hour, minute, second, millisecond, microsecond);
  }

  /// Check if same day as another date
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Get day name (e.g., 'Monday')
  String get dayName => DateFormat.EEEE().format(this);

  /// Get short day name (e.g., 'Mon')
  String get shortDayName => DateFormat.E().format(this);

  /// Get month name (e.g., 'January')
  String get monthName => DateFormat.MMMM().format(this);

  /// Get short month name (e.g., 'Jan')
  String get shortMonthName => DateFormat.MMM().format(this);
}

/// Extension methods on Duration
extension DurationExtensions on Duration {
  /// Format duration as 'HH:MM:SS'
  String get formatted {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = (inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Format duration as 'MM:SS'
  String get formattedShort {
    final minutes = inMinutes.toString().padLeft(2, '0');
    final seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Format duration as human readable (e.g., '2 hours, 30 minutes')
  String get humanReadable {
    if (inSeconds < 60) {
      return '$inSeconds seconds';
    } else if (inMinutes < 60) {
      return '$inMinutes minutes';
    } else if (inHours < 24) {
      final hours = inHours;
      final minutes = inMinutes % 60;
      if (minutes == 0) {
        return '$hours ${hours == 1 ? 'hour' : 'hours'}';
      }
      return '$hours ${hours == 1 ? 'hour' : 'hours'}, $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else {
      final days = inDays;
      final hours = inHours % 24;
      if (hours == 0) {
        return '$days ${days == 1 ? 'day' : 'days'}';
      }
      return '$days ${days == 1 ? 'day' : 'days'}, $hours ${hours == 1 ? 'hour' : 'hours'}';
    }
  }
}