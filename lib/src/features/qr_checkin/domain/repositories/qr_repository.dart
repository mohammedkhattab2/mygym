import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/qr_token.dart';

/// Repository interface for QR check-in operations
/// 
/// Handles token generation, validation, and visit tracking.
abstract class QrRepository {
  /// Generate a new QR token for check-in
  /// 
  /// [gymId] - Optional specific gym ID (null for network-wide access)
  /// Returns a JWT-based token valid for 30-60 seconds
  Future<Either<Failure, QrToken>> generateToken({String? gymId});

  /// Validate a check-in attempt (staff side)
  /// 
  /// Performs server-side validation including:
  /// - Token validity and expiry
  /// - Subscription status
  /// - Daily/weekly visit limits
  /// - One-time use check
  /// - Optional geofence verification
  Future<Either<Failure, CheckInResult>> validateCheckIn({
    required QrToken token,
    required String gymId,
    double? userLatitude,
    double? userLongitude,
  });

  /// Get user's visit history
  Future<Either<Failure, List<VisitEntry>>> getVisitHistory({
    int page = 1,
    int limit = 20,
  });

  /// Get visits for a specific gym
  Future<Either<Failure, List<VisitEntry>>> getGymVisitHistory({
    required String gymId,
    int page = 1,
    int limit = 20,
  });

  /// Get scanner configuration for a gym (staff side)
  Future<Either<Failure, ScannerConfig>> getScannerConfig(String gymId);

  /// Get today's check-in count for a gym (staff side)
  Future<Either<Failure, int>> getTodayCheckInCount({required String gymId});

  /// Get visit statistics for date range
  Future<Either<Failure, VisitStats>> getVisitStats({
    required String gymId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Report a manual check-out (optional feature)
  Future<Either<Failure, void>> checkOut({required String visitId});
}

/// Visit statistics for reporting
class VisitStats {
  final int totalVisits;
  final int uniqueUsers;
  final Map<String, int> visitsByDay; // date string -> count
  final Map<int, int> visitsByHour; // hour (0-23) -> count
  final double averageVisitDuration; // in minutes
  final List<PeakHour> peakHours;

  const VisitStats({
    required this.totalVisits,
    required this.uniqueUsers,
    required this.visitsByDay,
    required this.visitsByHour,
    required this.averageVisitDuration,
    required this.peakHours,
  });
}

/// Peak hour data
class PeakHour {
  final int hour;
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final double averageOccupancy;

  const PeakHour({
    required this.hour,
    required this.dayOfWeek,
    required this.averageOccupancy,
  });

  String get formattedTime {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:00 $period';
  }

  String get dayName {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dayOfWeek - 1];
  }
}