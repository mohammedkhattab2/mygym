import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../route_paths.dart';

/// Subscription status enum
enum SubscriptionStatus {
  none,
  active,
  expired,
  suspended,
}

/// Guard to check subscription status for premium features
@lazySingleton
class SubscriptionGuard {
  SubscriptionGuard();

  /// Current subscription status (cached)
  SubscriptionStatus currentStatus = SubscriptionStatus.none;

  /// Remaining visits
  int remainingVisits = 0;

  /// Subscription expiry date
  DateTime? expiryDate;

  /// Update subscription status
  Future<void> refreshStatus() async {
    // TODO: Fetch from repository
    // This would typically call a use case to get subscription status
  }

  /// Check if user has active subscription
  Future<String?> canActivate(
    BuildContext context,
    String location,
  ) async {
    await refreshStatus();

    if (currentStatus != SubscriptionStatus.active) {
      // Redirect to subscription purchase page
      return RoutePaths.bundles;
    }

    return null; // Allowed
  }

  /// Check if subscription is active
  bool get isActive => currentStatus == SubscriptionStatus.active;

  /// Check if subscription is expired
  bool get isExpired => currentStatus == SubscriptionStatus.expired;

  /// Check if subscription is suspended
  bool get isSuspended => currentStatus == SubscriptionStatus.suspended;

  /// Check if user has remaining visits
  bool get hasRemainingVisits => remainingVisits > 0;

  /// Check if subscription expires soon (within 7 days)
  bool get expiresSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 7 && daysUntilExpiry > 0;
  }

  /// Get days until expiry
  int get daysUntilExpiry {
    if (expiryDate == null) return 0;
    return expiryDate!.difference(DateTime.now()).inDays;
  }
}