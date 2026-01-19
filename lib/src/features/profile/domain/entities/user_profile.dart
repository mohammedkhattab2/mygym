// User profile entities

/// Complete user profile
class UserProfile {
  final String id;
  final String email;
  final String? phone;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? photoUrl;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final String? city;
  final List<String> interests;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final ProfileCompleteness completeness;

  const UserProfile({
    required this.id,
    required this.email,
    this.phone,
    this.displayName,
    this.firstName,
    this.lastName,
    this.photoUrl,
    this.dateOfBirth,
    this.gender,
    this.city,
    this.interests = const [],
    required this.createdAt,
    this.lastLoginAt,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    required this.completeness,
  });

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return displayName ?? email.split('@').first;
  }

  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }
}

/// Gender enum
enum Gender {
  male,
  female,
  other,
  preferNotToSay,
}

/// Extension for Gender
extension GenderX on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
      case Gender.preferNotToSay:
        return 'Prefer not to say';
    }
  }
}

/// Profile completeness tracking
class ProfileCompleteness {
  final int percentage;
  final bool hasPhoto;
  final bool hasName;
  final bool hasPhone;
  final bool hasDateOfBirth;
  final bool hasCity;
  final bool hasInterests;
  final List<String> missingFields;

  const ProfileCompleteness({
    required this.percentage,
    required this.hasPhoto,
    required this.hasName,
    required this.hasPhone,
    required this.hasDateOfBirth,
    required this.hasCity,
    required this.hasInterests,
    this.missingFields = const [],
  });

  factory ProfileCompleteness.calculate(UserProfile profile) {
    final missing = <String>[];
    int complete = 0;
    const total = 6;

    if (profile.photoUrl != null) {
      complete++;
    } else {
      missing.add('Profile photo');
    }

    if (profile.displayName != null || (profile.firstName != null && profile.lastName != null)) {
      complete++;
    } else {
      missing.add('Full name');
    }

    if (profile.phone != null) {
      complete++;
    } else {
      missing.add('Phone number');
    }

    if (profile.dateOfBirth != null) {
      complete++;
    } else {
      missing.add('Date of birth');
    }

    if (profile.city != null) {
      complete++;
    } else {
      missing.add('City');
    }

    if (profile.interests.isNotEmpty) {
      complete++;
    } else {
      missing.add('Interests');
    }

    return ProfileCompleteness(
      percentage: ((complete / total) * 100).round(),
      hasPhoto: profile.photoUrl != null,
      hasName: profile.displayName != null || profile.firstName != null,
      hasPhone: profile.phone != null,
      hasDateOfBirth: profile.dateOfBirth != null,
      hasCity: profile.city != null,
      hasInterests: profile.interests.isNotEmpty,
      missingFields: missing,
    );
  }
}

/// Profile update request
class ProfileUpdateRequest {
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final String? city;
  final List<String>? interests;

  const ProfileUpdateRequest({
    this.displayName,
    this.firstName,
    this.lastName,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.city,
    this.interests,
  });

  Map<String, dynamic> toJson() {
    return {
      if (displayName != null) 'displayName': displayName,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (phone != null) 'phone': phone,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
      if (gender != null) 'gender': gender!.name,
      if (city != null) 'city': city,
      if (interests != null) 'interests': interests,
    };
  }
}

/// Notification preferences
class NotificationPreferences {
  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;
  final bool classReminders;
  final bool promotionalOffers;
  final bool subscriptionAlerts;
  final bool visitReminders;
  final bool weeklyDigest;
  final int reminderMinutesBefore;

  const NotificationPreferences({
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.smsEnabled = false,
    this.classReminders = true,
    this.promotionalOffers = false,
    this.subscriptionAlerts = true,
    this.visitReminders = true,
    this.weeklyDigest = true,
    this.reminderMinutesBefore = 30,
  });

  NotificationPreferences copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? smsEnabled,
    bool? classReminders,
    bool? promotionalOffers,
    bool? subscriptionAlerts,
    bool? visitReminders,
    bool? weeklyDigest,
    int? reminderMinutesBefore,
  }) {
    return NotificationPreferences(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      classReminders: classReminders ?? this.classReminders,
      promotionalOffers: promotionalOffers ?? this.promotionalOffers,
      subscriptionAlerts: subscriptionAlerts ?? this.subscriptionAlerts,
      visitReminders: visitReminders ?? this.visitReminders,
      weeklyDigest: weeklyDigest ?? this.weeklyDigest,
      reminderMinutesBefore: reminderMinutesBefore ?? this.reminderMinutesBefore,
    );
  }
}

/// Privacy settings
class PrivacySettings {
  final bool profileVisible;
  final bool showVisitHistory;
  final bool allowReferrals;
  final bool shareWithPartners;

  const PrivacySettings({
    this.profileVisible = true,
    this.showVisitHistory = false,
    this.allowReferrals = true,
    this.shareWithPartners = false,
  });

  PrivacySettings copyWith({
    bool? profileVisible,
    bool? showVisitHistory,
    bool? allowReferrals,
    bool? shareWithPartners,
  }) {
    return PrivacySettings(
      profileVisible: profileVisible ?? this.profileVisible,
      showVisitHistory: showVisitHistory ?? this.showVisitHistory,
      allowReferrals: allowReferrals ?? this.allowReferrals,
      shareWithPartners: shareWithPartners ?? this.shareWithPartners,
    );
  }
}