/// Extension methods on String
extension StringExtensions on String {
  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number (Egyptian format)
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^(01)[0-2,5]{1}[0-9]{8}$');
    return phoneRegex.hasMatch(this);
  }

  /// Check if string is a valid password (min 8 chars, 1 uppercase, 1 lowercase, 1 number)
  bool get isValidPassword {
    if (length < 8) return false;
    final hasUppercase = contains(RegExp(r'[A-Z]'));
    final hasLowercase = contains(RegExp(r'[a-z]'));
    final hasDigit = contains(RegExp(r'[0-9]'));
    return hasUppercase && hasLowercase && hasDigit;
  }

  /// Check if string is empty or contains only whitespace
  bool get isBlank => trim().isEmpty;

  /// Check if string is not blank
  bool get isNotBlank => !isBlank;

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Convert to title case
  String get toTitleCase {
    if (isEmpty) return this;
    return toLowerCase().capitalizeWords;
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Get initials from name
  String get initials {
    if (isEmpty) return '';
    final words = trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words[0].substring(0, words[0].length.clamp(0, 2)).toUpperCase();
    }
    return words
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();
  }

  /// Convert to snake_case
  String get toSnakeCase {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// Convert to camelCase
  String get toCamelCase {
    final words = split(RegExp(r'[_\s-]+'));
    if (words.isEmpty) return this;
    return words.first.toLowerCase() +
        words.skip(1).map((w) => w.capitalize).join();
  }

  /// Mask string (useful for phone numbers, emails)
  String mask({int visibleStart = 2, int visibleEnd = 2, String maskChar = '*'}) {
    if (length <= visibleStart + visibleEnd) return this;
    final start = substring(0, visibleStart);
    final end = substring(length - visibleEnd);
    final masked = maskChar * (length - visibleStart - visibleEnd);
    return '$start$masked$end';
  }

  /// Parse string to int or return null
  int? toIntOrNull() => int.tryParse(this);

  /// Parse string to double or return null
  double? toDoubleOrNull() => double.tryParse(this);

  /// Check if string is numeric
  bool get isNumeric => double.tryParse(this) != null;

  /// Remove HTML tags
  String get stripHtml => replaceAll(RegExp(r'<[^>]*>'), '');

  /// Check if string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );
    return urlRegex.hasMatch(this);
  }
}

/// Extension methods on nullable String
extension NullableStringExtensions on String? {
  /// Check if string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Check if string is not null and not empty
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Check if string is null or blank
  bool get isNullOrBlank => this == null || this!.isBlank;

  /// Check if string is not null and not blank
  bool get isNotNullOrBlank => !isNullOrBlank;

  /// Return the string or a default value if null/empty
  String orDefault([String defaultValue = '']) {
    return isNullOrEmpty ? defaultValue : this!;
  }
}