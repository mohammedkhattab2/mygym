// App settings entities for settings feature

/// Supported languages
enum AppLanguage {
  english,
  arabic,
}

/// Extension for AppLanguage
extension AppLanguageX on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.arabic:
        return 'ar';
    }
  }

  String get displayName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.arabic:
        return 'العربية';
    }
  }

  String get nativeName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.arabic:
        return 'Arabic';
    }
  }
}

/// Theme mode
enum AppThemeMode {
  system,
  light,
  dark,
}

/// Extension for AppThemeMode
extension AppThemeModeX on AppThemeMode {
  String get displayName {
    switch (this) {
      case AppThemeMode.system:
        return 'System Default';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }
}

/// Complete app settings
class AppSettings {
  final AppLanguage language;
  final AppThemeMode themeMode;
  final bool biometricEnabled;
  final bool analyticsEnabled;
  final bool crashReportingEnabled;
  final MeasurementUnit measurementUnit;
  final CurrencySettings currency;

  const AppSettings({
    this.language = AppLanguage.english,
    this.themeMode = AppThemeMode.system,
    this.biometricEnabled = false,
    this.analyticsEnabled = true,
    this.crashReportingEnabled = true,
    this.measurementUnit = MeasurementUnit.metric,
    this.currency = const CurrencySettings(),
  });

  AppSettings copyWith({
    AppLanguage? language,
    AppThemeMode? themeMode,
    bool? biometricEnabled,
    bool? analyticsEnabled,
    bool? crashReportingEnabled,
    MeasurementUnit? measurementUnit,
    CurrencySettings? currency,
  }) {
    return AppSettings(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      crashReportingEnabled: crashReportingEnabled ?? this.crashReportingEnabled,
      measurementUnit: measurementUnit ?? this.measurementUnit,
      currency: currency ?? this.currency,
    );
  }
}

/// Measurement unit preference
enum MeasurementUnit {
  metric,
  imperial,
}

/// Extension for MeasurementUnit
extension MeasurementUnitX on MeasurementUnit {
  String get displayName {
    switch (this) {
      case MeasurementUnit.metric:
        return 'Metric (km, kg)';
      case MeasurementUnit.imperial:
        return 'Imperial (mi, lb)';
    }
  }
}

/// Currency settings
class CurrencySettings {
  final String code;
  final String symbol;
  final String name;
  final int decimalPlaces;

  const CurrencySettings({
    this.code = 'EGP',
    this.symbol = 'E£',
    this.name = 'Egyptian Pound',
    this.decimalPlaces = 2,
  });
}

/// Support ticket
class SupportTicket {
  final String id;
  final String userId;
  final String subject;
  final String description;
  final SupportCategory category;
  final SupportPriority priority;
  final TicketStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? resolvedAt;
  final List<TicketMessage> messages;
  final String? assignedTo;

  const SupportTicket({
    required this.id,
    required this.userId,
    required this.subject,
    required this.description,
    required this.category,
    this.priority = SupportPriority.normal,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.resolvedAt,
    this.messages = const [],
    this.assignedTo,
  });
}

/// Support category
enum SupportCategory {
  account,
  payment,
  technical,
  gym,
  subscription,
  other,
}

/// Extension for SupportCategory
extension SupportCategoryX on SupportCategory {
  String get displayName {
    switch (this) {
      case SupportCategory.account:
        return 'Account Issues';
      case SupportCategory.payment:
        return 'Payment & Billing';
      case SupportCategory.technical:
        return 'Technical Support';
      case SupportCategory.gym:
        return 'Gym Related';
      case SupportCategory.subscription:
        return 'Subscription';
      case SupportCategory.other:
        return 'Other';
    }
  }
}

/// Support priority
enum SupportPriority {
  low,
  normal,
  high,
  urgent,
}

/// Ticket status
enum TicketStatus {
  open,
  inProgress,
  waitingOnCustomer,
  resolved,
  closed,
}

/// Extension for TicketStatus
extension TicketStatusX on TicketStatus {
  String get displayName {
    switch (this) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.waitingOnCustomer:
        return 'Waiting on You';
      case TicketStatus.resolved:
        return 'Resolved';
      case TicketStatus.closed:
        return 'Closed';
    }
  }
}

/// Ticket message
class TicketMessage {
  final String id;
  final String ticketId;
  final String senderId;
  final String senderName;
  final bool isStaff;
  final String content;
  final DateTime sentAt;
  final List<String> attachments;

  const TicketMessage({
    required this.id,
    required this.ticketId,
    required this.senderId,
    required this.senderName,
    required this.isStaff,
    required this.content,
    required this.sentAt,
    this.attachments = const [],
  });
}

/// FAQ item
class FaqItem {
  final String id;
  final String question;
  final String answer;
  final String category;
  final int viewCount;
  final int helpfulCount;

  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.viewCount = 0,
    this.helpfulCount = 0,
  });
}

/// About app info
class AboutInfo {
  final String appName;
  final String version;
  final String buildNumber;
  final String copyright;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final String contactEmail;
  final String websiteUrl;
  final List<SocialLink> socialLinks;

  const AboutInfo({
    required this.appName,
    required this.version,
    required this.buildNumber,
    required this.copyright,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    required this.contactEmail,
    required this.websiteUrl,
    this.socialLinks = const [],
  });
}

/// Social media link
class SocialLink {
  final String name;
  final String url;
  final String icon;

  const SocialLink({
    required this.name,
    required this.url,
    required this.icon,
  });
}