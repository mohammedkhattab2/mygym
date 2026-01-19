import 'package:intl/intl.dart';

/// Extension methods on num
extension NumExtensions on num {
  /// Format number as currency (EGP)
  String get asCurrency => NumberFormat.currency(
        locale: 'ar_EG',
        symbol: 'EGP ',
        decimalDigits: 2,
      ).format(this);

  /// Format number as currency without symbol
  String get asCurrencyNoSymbol => NumberFormat.currency(
        locale: 'ar_EG',
        symbol: '',
        decimalDigits: 2,
      ).format(this);

  /// Format number with thousand separators
  String get formatted => NumberFormat('#,###').format(this);

  /// Format number as compact (e.g., 1.2K, 1.5M)
  String get compact => NumberFormat.compact().format(this);

  /// Format number as percentage
  String get asPercentage => '${(this * 100).toStringAsFixed(0)}%';

  /// Format number with decimal places
  String toDecimal([int places = 2]) => toStringAsFixed(places);

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Get absolute value
  num get abs => this < 0 ? -this : this;

  /// Clamp value between min and max
  num clampNum(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  /// Convert to Duration (as milliseconds)
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// Convert to Duration (as seconds)
  Duration get seconds => Duration(seconds: toInt());

  /// Convert to Duration (as minutes)
  Duration get minutes => Duration(minutes: toInt());

  /// Convert to Duration (as hours)
  Duration get hours => Duration(hours: toInt());

  /// Convert to Duration (as days)
  Duration get days => Duration(days: toInt());

  /// Format as file size (KB, MB, GB)
  String get asFileSize {
    if (this < 1024) {
      return '${toStringAsFixed(0)} B';
    } else if (this < 1024 * 1024) {
      return '${(this / 1024).toStringAsFixed(1)} KB';
    } else if (this < 1024 * 1024 * 1024) {
      return '${(this / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Format as distance (m, km)
  String get asDistance {
    if (this < 1000) {
      return '${toStringAsFixed(0)} m';
    } else {
      return '${(this / 1000).toStringAsFixed(1)} km';
    }
  }

  /// Convert degrees to radians
  double get toRadians => this * 3.14159265359 / 180;

  /// Convert radians to degrees
  double get toDegrees => this * 180 / 3.14159265359;
}

/// Extension methods on int
extension IntExtensions on int {
  /// Check if number is even
  bool get isEven => this % 2 == 0;

  /// Check if number is odd
  bool get isOdd => this % 2 != 0;

  /// Generate list from 0 to this number
  List<int> get range => List.generate(this, (index) => index);

  /// Repeat a function n times
  void times(void Function(int index) action) {
    for (var i = 0; i < this; i++) {
      action(i);
    }
  }

  /// Format as ordinal (1st, 2nd, 3rd, etc.)
  String get ordinal {
    if (this >= 11 && this <= 13) {
      return '${this}th';
    }
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  /// Pad with leading zeros
  String padLeft(int width, [String padding = '0']) {
    return toString().padLeft(width, padding);
  }
}

/// Extension methods on double
extension DoubleExtensions on double {
  /// Round to specified decimal places
  double roundTo(int places) {
    final mod = 10.0 * places;
    return (this * mod).round() / mod;
  }

  /// Check if approximately equal to another double
  bool isApproximately(double other, {double epsilon = 0.0001}) {
    return (this - other).abs() < epsilon;
  }
}