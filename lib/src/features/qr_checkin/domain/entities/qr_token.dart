import 'dart:convert';

/// QR Token entity for secure gym check-in
/// 
/// Uses JWT-based tokens with embedded claims for:
/// - User identification
/// - Gym validation
/// - Time-based expiry
/// - One-time use protection
class QrToken {
  final String token;
  final String userId;
  final String? gymId; // Null for network-wide access
  final DateTime issuedAt;
  final DateTime expiresAt;
  final String nonce; // Unique identifier for one-time use
  final QrTokenStatus status;
  final int? remainingVisits;
  final String? subscriptionId;

  const QrToken({
    required this.token,
    required this.userId,
    this.gymId,
    required this.issuedAt,
    required this.expiresAt,
    required this.nonce,
    this.status = QrTokenStatus.valid,
    this.remainingVisits,
    this.subscriptionId,
  });

  /// Check if token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if token is valid (not expired and not used)
  bool get isValid => !isExpired && status == QrTokenStatus.valid;

  /// Seconds until expiry
  int get secondsUntilExpiry {
    final diff = expiresAt.difference(DateTime.now());
    return diff.inSeconds.clamp(0, 999);
  }

  /// Token validity duration (typically 30-60 seconds)
  Duration get validityDuration => expiresAt.difference(issuedAt);

  /// Create token payload for QR generation
  Map<String, dynamic> toPayload() {
    return {
      'token': token,
      'user_id': userId,
      'gym_id': gymId,
      'issued_at': issuedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'nonce': nonce,
    };
  }

  /// Encode as QR data string
  String toQrData() => base64Encode(utf8.encode(jsonEncode(toPayload())));

  /// Decode from QR data string
  factory QrToken.fromQrData(String qrData) {
    final decoded = utf8.decode(base64Decode(qrData));
    final payload = jsonDecode(decoded) as Map<String, dynamic>;
    return QrToken(
      token: payload['token'] as String,
      userId: payload['user_id'] as String,
      gymId: payload['gym_id'] as String?,
      issuedAt: DateTime.parse(payload['issued_at'] as String),
      expiresAt: DateTime.parse(payload['expires_at'] as String),
      nonce: payload['nonce'] as String,
    );
  }
}

/// QR Token status
enum QrTokenStatus {
  valid,
  used,
  expired,
  invalid,
  revoked,
}

/// Check-in validation result
class CheckInResult {
  final bool isAllowed;
  final CheckInStatus status;
  final String message;
  final String? userName;
  final String? userPhotoUrl;
  final int? remainingVisits;
  final String? subscriptionType;
  final DateTime? checkedInAt;
  final String? rejectionReason;

  const CheckInResult({
    required this.isAllowed,
    required this.status,
    required this.message,
    this.userName,
    this.userPhotoUrl,
    this.remainingVisits,
    this.subscriptionType,
    this.checkedInAt,
    this.rejectionReason,
  });

  factory CheckInResult.allowed({
    required String userName,
    String? userPhotoUrl,
    int? remainingVisits,
    String? subscriptionType,
  }) {
    return CheckInResult(
      isAllowed: true,
      status: CheckInStatus.allowed,
      message: 'Check-in successful!',
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      remainingVisits: remainingVisits,
      subscriptionType: subscriptionType,
      checkedInAt: DateTime.now(),
    );
  }

  factory CheckInResult.rejected({
    required CheckInStatus status,
    required String reason,
    String? userName,
  }) {
    return CheckInResult(
      isAllowed: false,
      status: status,
      message: 'Check-in rejected',
      userName: userName,
      rejectionReason: reason,
    );
  }
}

/// Check-in status codes
enum CheckInStatus {
  allowed,
  noActiveSubscription,
  noRemainingVisits,
  subscriptionExpired,
  dailyLimitReached,
  weeklyLimitReached,
  tokenExpired,
  tokenUsed,
  tokenInvalid,
  gymNotAllowed,
  userBlocked,
  geofenceViolation,
  systemError,
}

extension CheckInStatusExtension on CheckInStatus {
  String get displayMessage {
    switch (this) {
      case CheckInStatus.allowed:
        return 'Welcome! Enjoy your workout.';
      case CheckInStatus.noActiveSubscription:
        return 'No active subscription found.';
      case CheckInStatus.noRemainingVisits:
        return 'No remaining visits on your plan.';
      case CheckInStatus.subscriptionExpired:
        return 'Your subscription has expired.';
      case CheckInStatus.dailyLimitReached:
        return 'Daily visit limit reached.';
      case CheckInStatus.weeklyLimitReached:
        return 'Weekly visit limit reached.';
      case CheckInStatus.tokenExpired:
        return 'QR code has expired. Generate a new one.';
      case CheckInStatus.tokenUsed:
        return 'This QR code has already been used.';
      case CheckInStatus.tokenInvalid:
        return 'Invalid QR code.';
      case CheckInStatus.gymNotAllowed:
        return 'Your subscription doesn\'t include this gym.';
      case CheckInStatus.userBlocked:
        return 'Your account has been blocked.';
      case CheckInStatus.geofenceViolation:
        return 'You must be at the gym to check in.';
      case CheckInStatus.systemError:
        return 'System error. Please try again.';
    }
  }

  bool get isRetryable {
    return this == CheckInStatus.tokenExpired ||
        this == CheckInStatus.tokenUsed ||
        this == CheckInStatus.systemError;
  }
}

/// Visit history entry
class VisitEntry {
  final String id;
  final String gymId;
  final String gymName;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final Duration? duration;
  final String? subscriptionId;
  final int? visitsAfter; // Remaining visits after this visit

  const VisitEntry({
    required this.id,
    required this.gymId,
    required this.gymName,
    required this.checkInTime,
    this.checkOutTime,
    this.duration,
    this.subscriptionId,
    this.visitsAfter,
  });

  /// Calculate visit duration
  Duration get visitDuration {
    if (duration != null) return duration!;
    if (checkOutTime != null) {
      return checkOutTime!.difference(checkInTime);
    }
    return DateTime.now().difference(checkInTime);
  }

  /// Format duration as string
  String get formattedDuration {
    final d = visitDuration;
    if (d.inHours > 0) {
      return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    }
    return '${d.inMinutes}m';
  }
}

/// QR Scanner configuration for staff app
class ScannerConfig {
  final String gymId;
  final String gymName;
  final bool requireGeofence;
  final double? geofenceLatitude;
  final double? geofenceLongitude;
  final double? geofenceRadiusMeters;
  final bool playSoundOnSuccess;
  final bool playSoundOnError;
  final bool vibrateOnScan;
  final int autoResetDelaySeconds;

  const ScannerConfig({
    required this.gymId,
    required this.gymName,
    this.requireGeofence = false,
    this.geofenceLatitude,
    this.geofenceLongitude,
    this.geofenceRadiusMeters = 100,
    this.playSoundOnSuccess = true,
    this.playSoundOnError = true,
    this.vibrateOnScan = true,
    this.autoResetDelaySeconds = 3,
  });

  /// Check if user location is within geofence
  bool isWithinGeofence(double userLat, double userLng) {
    if (!requireGeofence || geofenceLatitude == null || geofenceLongitude == null) {
      return true;
    }
    
    // Simple distance calculation (Haversine formula would be more accurate)
    final latDiff = (userLat - geofenceLatitude!).abs();
    final lngDiff = (userLng - geofenceLongitude!).abs();
    
    // Approximate meters per degree at equator
    const metersPerDegree = 111320.0;
    final distanceMeters = (latDiff * metersPerDegree + lngDiff * metersPerDegree) / 2;
    
    return distanceMeters <= (geofenceRadiusMeters ?? 100);
  }
}