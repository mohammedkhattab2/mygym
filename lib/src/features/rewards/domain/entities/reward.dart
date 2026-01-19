// Reward entities for points and referral system

/// Reward type enum
enum RewardType {
  points,
  freeVisit,
  discount,
  merchandise,
  classPass,
  guestPass,
}

/// Extension for RewardType
extension RewardTypeX on RewardType {
  String get displayName {
    switch (this) {
      case RewardType.points:
        return 'Points';
      case RewardType.freeVisit:
        return 'Free Visit';
      case RewardType.discount:
        return 'Discount';
      case RewardType.merchandise:
        return 'Merchandise';
      case RewardType.classPass:
        return 'Class Pass';
      case RewardType.guestPass:
        return 'Guest Pass';
    }
  }

  String get icon {
    switch (this) {
      case RewardType.points:
        return '⭐';
      case RewardType.freeVisit:
        return '🎫';
      case RewardType.discount:
        return '💰';
      case RewardType.merchandise:
        return '👕';
      case RewardType.classPass:
        return '🏋️';
      case RewardType.guestPass:
        return '👥';
    }
  }
}

/// Points transaction type
enum PointsTransactionType {
  earned,
  redeemed,
  expired,
  bonus,
  referral,
  adjustment,
}

/// User rewards summary
class UserRewards {
  final String userId;
  final int currentPoints;
  final int lifetimePoints;
  final int pendingPoints;
  final int expiringPoints;
  final DateTime? expiringDate;
  final int totalRedemptions;
  final int referralCount;
  final String? referralCode;
  final MembershipTier tier;
  final int pointsToNextTier;

  const UserRewards({
    required this.userId,
    required this.currentPoints,
    required this.lifetimePoints,
    this.pendingPoints = 0,
    this.expiringPoints = 0,
    this.expiringDate,
    this.totalRedemptions = 0,
    this.referralCount = 0,
    this.referralCode,
    this.tier = MembershipTier.bronze,
    this.pointsToNextTier = 0,
  });
}

/// Membership tier enum
enum MembershipTier {
  bronze,
  silver,
  gold,
  platinum,
}

/// Extension for MembershipTier
extension MembershipTierX on MembershipTier {
  String get displayName {
    switch (this) {
      case MembershipTier.bronze:
        return 'Bronze';
      case MembershipTier.silver:
        return 'Silver';
      case MembershipTier.gold:
        return 'Gold';
      case MembershipTier.platinum:
        return 'Platinum';
    }
  }

  String get color {
    switch (this) {
      case MembershipTier.bronze:
        return '#CD7F32';
      case MembershipTier.silver:
        return '#C0C0C0';
      case MembershipTier.gold:
        return '#FFD700';
      case MembershipTier.platinum:
        return '#E5E4E2';
    }
  }

  int get minPoints {
    switch (this) {
      case MembershipTier.bronze:
        return 0;
      case MembershipTier.silver:
        return 1000;
      case MembershipTier.gold:
        return 5000;
      case MembershipTier.platinum:
        return 15000;
    }
  }

  double get pointsMultiplier {
    switch (this) {
      case MembershipTier.bronze:
        return 1.0;
      case MembershipTier.silver:
        return 1.25;
      case MembershipTier.gold:
        return 1.5;
      case MembershipTier.platinum:
        return 2.0;
    }
  }
}

/// Points transaction record
class PointsTransaction {
  final String id;
  final String userId;
  final PointsTransactionType type;
  final int points;
  final int balanceAfter;
  final String description;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String? referenceId; // Visit ID, Referral ID, etc.
  final String? referenceType;

  const PointsTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.points,
    required this.balanceAfter,
    required this.description,
    required this.createdAt,
    this.expiresAt,
    this.referenceId,
    this.referenceType,
  });

  bool get isCredit => type == PointsTransactionType.earned || 
                        type == PointsTransactionType.bonus || 
                        type == PointsTransactionType.referral;
}

/// Redeemable reward item
class RewardItem {
  final String id;
  final String name;
  final String description;
  final RewardType type;
  final int pointsCost;
  final String? imageUrl;
  final bool isAvailable;
  final int? stockCount;
  final DateTime? validUntil;
  final List<String> applicableGymIds; // Empty means all gyms
  final MembershipTier? requiredTier;
  final int? maxRedemptionsPerUser;

  const RewardItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.pointsCost,
    this.imageUrl,
    this.isAvailable = true,
    this.stockCount,
    this.validUntil,
    this.applicableGymIds = const [],
    this.requiredTier,
    this.maxRedemptionsPerUser,
  });

  bool get hasLimitedStock => stockCount != null;
  bool get isExpired => validUntil != null && DateTime.now().isAfter(validUntil!);
}

/// Redemption record
class Redemption {
  final String id;
  final String userId;
  final RewardItem reward;
  final int pointsSpent;
  final DateTime redeemedAt;
  final DateTime? usedAt;
  final DateTime expiresAt;
  final String? code; // For discount codes or vouchers
  final RedemptionStatus status;

  const Redemption({
    required this.id,
    required this.userId,
    required this.reward,
    required this.pointsSpent,
    required this.redeemedAt,
    this.usedAt,
    required this.expiresAt,
    this.code,
    required this.status,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get canBeUsed => status == RedemptionStatus.active && !isExpired;
}

/// Redemption status
enum RedemptionStatus {
  active,
  used,
  expired,
  cancelled,
}

/// Referral entity
class Referral {
  final String id;
  final String referrerId;
  final String referrerName;
  final String? refereeId;
  final String? refereeName;
  final String referralCode;
  final ReferralStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final int pointsEarned;
  final int bonusPointsEarned;

  const Referral({
    required this.id,
    required this.referrerId,
    required this.referrerName,
    this.refereeId,
    this.refereeName,
    required this.referralCode,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.pointsEarned = 0,
    this.bonusPointsEarned = 0,
  });
}

/// Referral status
enum ReferralStatus {
  pending,
  registered,
  subscribed,
  completed,
  expired,
}

/// Extension for ReferralStatus
extension ReferralStatusX on ReferralStatus {
  String get displayName {
    switch (this) {
      case ReferralStatus.pending:
        return 'Pending';
      case ReferralStatus.registered:
        return 'Registered';
      case ReferralStatus.subscribed:
        return 'Subscribed';
      case ReferralStatus.completed:
        return 'Completed';
      case ReferralStatus.expired:
        return 'Expired';
    }
  }
}

/// Points earning rules
class PointsEarningRule {
  final String id;
  final String name;
  final String description;
  final int pointsAmount;
  final String triggerType; // 'visit', 'class', 'referral', 'subscription'
  final bool isActive;
  final DateTime? validFrom;
  final DateTime? validUntil;

  const PointsEarningRule({
    required this.id,
    required this.name,
    required this.description,
    required this.pointsAmount,
    required this.triggerType,
    this.isActive = true,
    this.validFrom,
    this.validUntil,
  });
}