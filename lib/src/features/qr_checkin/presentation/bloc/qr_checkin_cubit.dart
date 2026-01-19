import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/qr_token.dart';
import '../../domain/repositories/qr_repository.dart';

/// State for QR Check-in (Member side - QR Generator)
class QrCheckinState {
  final QrToken? currentToken;
  final bool isLoading;
  final String? error;
  final int secondsRemaining;
  final bool isRefreshing;

  const QrCheckinState({
    this.currentToken,
    this.isLoading = false,
    this.error,
    this.secondsRemaining = 0,
    this.isRefreshing = false,
  });

  QrCheckinState copyWith({
    QrToken? currentToken,
    bool? isLoading,
    String? error,
    int? secondsRemaining,
    bool? isRefreshing,
  }) {
    return QrCheckinState(
      currentToken: currentToken ?? this.currentToken,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  /// Check if QR code is valid and not expired
  bool get hasValidToken => currentToken != null && currentToken!.isValid;

  /// Check if token is about to expire (< 10 seconds)
  bool get isExpiringSoon => secondsRemaining > 0 && secondsRemaining < 10;
}

/// Cubit for QR code generation (member app)
@injectable
class QrCheckinCubit extends Cubit<QrCheckinState> {
  final QrRepository _qrRepository;
  Timer? _countdownTimer;
  Timer? _autoRefreshTimer;

  QrCheckinCubit(this._qrRepository) : super(const QrCheckinState());

  /// Generate a new QR token
  Future<void> generateToken({String? gymId}) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _qrRepository.generateToken(gymId: gymId);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (token) {
        emit(state.copyWith(
          isLoading: false,
          currentToken: token,
          secondsRemaining: token.secondsUntilExpiry,
        ));
        _startCountdown();
        _scheduleAutoRefresh(token);
      },
    );
  }

  /// Refresh the current token
  Future<void> refreshToken() async {
    if (state.isRefreshing) return;

    emit(state.copyWith(isRefreshing: true));

    final gymId = state.currentToken?.gymId;
    final result = await _qrRepository.generateToken(gymId: gymId);

    result.fold(
      (failure) => emit(state.copyWith(
        isRefreshing: false,
        error: failure.message,
      )),
      (token) {
        emit(state.copyWith(
          isRefreshing: false,
          currentToken: token,
          secondsRemaining: token.secondsUntilExpiry,
        ));
        _startCountdown();
        _scheduleAutoRefresh(token);
      },
    );
  }

  /// Start countdown timer
  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (state.secondsRemaining > 0) {
          emit(state.copyWith(secondsRemaining: state.secondsRemaining - 1));
        } else {
          _countdownTimer?.cancel();
        }
      },
    );
  }

  /// Schedule auto-refresh before token expires
  void _scheduleAutoRefresh(QrToken token) {
    _autoRefreshTimer?.cancel();
    
    // Refresh 5 seconds before expiry
    final refreshDelay = token.secondsUntilExpiry - 5;
    if (refreshDelay > 0) {
      _autoRefreshTimer = Timer(
        Duration(seconds: refreshDelay),
        () => refreshToken(),
      );
    }
  }

  /// Get visit history
  Future<List<VisitEntry>> getVisitHistory({int limit = 20}) async {
    final result = await _qrRepository.getVisitHistory(limit: limit);
    return result.fold(
      (failure) => [],
      (visits) => visits,
    );
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    _autoRefreshTimer?.cancel();
    return super.close();
  }
}

/// State for QR Scanner (Staff/Partner side)
class QrScannerState {
  final bool isScanning;
  final bool isProcessing;
  final CheckInResult? lastResult;
  final String? error;
  final ScannerConfig? config;
  final List<CheckInResult> recentScans;

  const QrScannerState({
    this.isScanning = false,
    this.isProcessing = false,
    this.lastResult,
    this.error,
    this.config,
    this.recentScans = const [],
  });

  QrScannerState copyWith({
    bool? isScanning,
    bool? isProcessing,
    CheckInResult? lastResult,
    String? error,
    ScannerConfig? config,
    List<CheckInResult>? recentScans,
  }) {
    return QrScannerState(
      isScanning: isScanning ?? this.isScanning,
      isProcessing: isProcessing ?? this.isProcessing,
      lastResult: lastResult,
      error: error,
      config: config ?? this.config,
      recentScans: recentScans ?? this.recentScans,
    );
  }
}

/// Cubit for QR scanning (staff/partner app)
@injectable
class QrScannerCubit extends Cubit<QrScannerState> {
  final QrRepository _qrRepository;

  QrScannerCubit(this._qrRepository) : super(const QrScannerState());

  /// Initialize scanner with gym config
  Future<void> initialize(String gymId) async {
    final result = await _qrRepository.getScannerConfig(gymId);
    
    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (config) => emit(state.copyWith(config: config)),
    );
  }

  /// Start scanning
  void startScanning() {
    emit(state.copyWith(isScanning: true, lastResult: null, error: null));
  }

  /// Stop scanning
  void stopScanning() {
    emit(state.copyWith(isScanning: false));
  }

  /// Process scanned QR code
  Future<void> processQrCode(String qrData, {double? userLat, double? userLng}) async {
    if (state.isProcessing) return;

    emit(state.copyWith(isProcessing: true, error: null));

    try {
      // Decode QR data
      final token = QrToken.fromQrData(qrData);

      // Validate with server
      final result = await _qrRepository.validateCheckIn(
        token: token,
        gymId: state.config?.gymId ?? '',
        userLatitude: userLat,
        userLongitude: userLng,
      );

      result.fold(
        (failure) => emit(state.copyWith(
          isProcessing: false,
          lastResult: CheckInResult.rejected(
            status: CheckInStatus.systemError,
            reason: failure.message,
          ),
        )),
        (checkInResult) {
          final updatedScans = [checkInResult, ...state.recentScans.take(9)];
          emit(state.copyWith(
            isProcessing: false,
            lastResult: checkInResult,
            recentScans: updatedScans,
          ));
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isProcessing: false,
        lastResult: CheckInResult.rejected(
          status: CheckInStatus.tokenInvalid,
          reason: 'Invalid QR code format',
        ),
      ));
    }
  }

  /// Clear last result (for resetting UI)
  void clearResult() {
    emit(state.copyWith(lastResult: null));
  }

  /// Get today's check-in count
  Future<int> getTodayCheckInCount() async {
    final result = await _qrRepository.getTodayCheckInCount(
      gymId: state.config?.gymId ?? '',
    );
    return result.fold(
      (failure) => 0,
      (count) => count,
    );
  }
}