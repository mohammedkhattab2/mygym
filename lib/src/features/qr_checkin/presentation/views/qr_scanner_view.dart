import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/qr_checkin/domain/entities/qr_token.dart';
import 'package:mygym/src/features/qr_checkin/presentation/bloc/qr_checkin_cubit.dart';

/// Premium QR Scanner View for Partners
///
/// Features:
/// - Mobile scanner integration for QR code scanning
/// - Real-time check-in validation
/// - Premium glassmorphism UI
/// - Recent scans history
/// - Sound and vibration feedback
/// - Scanner overlay with animated frame
class QrScannerView extends StatefulWidget {
  const QrScannerView({super.key, required this.gymId});
  final String gymId;

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView>
    with SingleTickerProviderStateMixin {
  MobileScannerController? _scannerController;
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
    _initializeAnimations();
    
    // Initialize cubit with gym config
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QrScannerCubit>().initialize(widget.gymId);
      context.read<QrScannerCubit>().startScanning();
    });
  }

  void _initializeScanner() {
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? qrData = barcodes.first.rawValue;
    if (qrData == null || qrData.isEmpty) return;

    setState(() => _hasScanned = true);

    // Vibrate on scan
    HapticFeedback.mediumImpact();

    // Process the QR code
    context.read<QrScannerCubit>().processQrCode(qrData);

    // Reset scan state after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _hasScanned = false);
        context.read<QrScannerCubit>().clearResult();
      }
    });
  }

  void _toggleFlash() async {
    await _scannerController?.toggleTorch();
    setState(() => _isFlashOn = !_isFlashOn);
  }

  void _switchCamera() async {
    await _scannerController?.switchCamera();
    setState(() => _isFrontCamera = !_isFrontCamera);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Scanner camera view
          _buildCameraView(),

          // Scanner overlay
          _buildScannerOverlay(colorScheme, luxury),

          // Top controls
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(colorScheme, luxury),
                const Spacer(),
                // Result card
                BlocBuilder<QrScannerCubit, QrScannerState>(
                  builder: (context, state) {
                    if (state.lastResult != null) {
                      return _ResultCard(result: state.lastResult!);
                    }
                    if (state.isProcessing) {
                      return _ProcessingCard();
                    }
                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(height: 20.h),
                // Bottom controls and recent scans
                _buildBottomSection(colorScheme, luxury),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    return MobileScanner(
      controller: _scannerController,
      onDetect: _onDetect,
      errorBuilder: (context, error) {
        return _CameraErrorWidget(error: error);
      },
    );
  }

  Widget _buildScannerOverlay(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return CustomPaint(
      painter: _ScannerOverlayPainter(
        borderColor: luxury.gold,
        overlayColor: Colors.black.withValues(alpha: 0.6),
        borderRadius: 24.r,
        borderWidth: 3,
        scanAreaSize: 280.w,
      ),
      child: Center(
        child: SizedBox(
          width: 280.w,
          height: 280.w,
          child: Stack(
            children: [
              // Corner decorations
              ..._buildCornerDecorations(luxury),
              
              // Animated scan line
              AnimatedBuilder(
                animation: _scanLineAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: _scanLineAnimation.value * (280.w - 4),
                    left: 10.w,
                    right: 10.w,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            luxury.gold.withValues(alpha: 0.8),
                            luxury.goldLight,
                            luxury.gold.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: luxury.gold.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCornerDecorations(LuxuryThemeExtension luxury) {
    const cornerSize = 30.0;
    const strokeWidth = 4.0;

    Widget buildCorner({
      required Alignment alignment,
      required BorderRadius borderRadius,
    }) {
      return Align(
        alignment: alignment,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: alignment.y == -1
                  ? BorderSide(color: luxury.gold, width: strokeWidth)
                  : BorderSide.none,
              bottom: alignment.y == 1
                  ? BorderSide(color: luxury.gold, width: strokeWidth)
                  : BorderSide.none,
              left: alignment.x == -1
                  ? BorderSide(color: luxury.gold, width: strokeWidth)
                  : BorderSide.none,
              right: alignment.x == 1
                  ? BorderSide(color: luxury.gold, width: strokeWidth)
                  : BorderSide.none,
            ),
            borderRadius: borderRadius,
          ),
        ),
      );
    }

    return [
      buildCorner(
        alignment: Alignment.topLeft,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r)),
      ),
      buildCorner(
        alignment: Alignment.topRight,
        borderRadius: BorderRadius.only(topRight: Radius.circular(12.r)),
      ),
      buildCorner(
        alignment: Alignment.bottomLeft,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.r)),
      ),
      buildCorner(
        alignment: Alignment.bottomRight,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(12.r)),
      ),
    ];
  }

  Widget _buildTopBar(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          // Back button
          _ControlButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 16.w),
          
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MEMBER',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Check-In Scanner',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Flash toggle
          _ControlButton(
            icon: _isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
            onTap: _toggleFlash,
            isActive: _isFlashOn,
          ),
          SizedBox(width: 12.w),
          
          // Camera switch
          _ControlButton(
            icon: Icons.cameraswitch_rounded,
            onTap: _switchCamera,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.8),
            Colors.black,
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Instructions
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: luxury.gold.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.qr_code_scanner_rounded,
                  color: luxury.gold,
                  size: 20.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  'Point at member\'s QR code',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          
          // Today's check-ins count
          BlocBuilder<QrScannerCubit, QrScannerState>(
            builder: (context, state) {
              return _TodayCheckInsCard(
                checkInCount: state.recentScans.length,
              );
            },
          ),
          SizedBox(height: 16.h),
          
          // Recent scans
          BlocBuilder<QrScannerCubit, QrScannerState>(
            builder: (context, state) {
              if (state.recentScans.isEmpty) {
                return const SizedBox.shrink();
              }
              return _RecentScansSection(scans: state.recentScans);
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CONTROL BUTTON WIDGET
// ============================================================================

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isActive
                ? luxury.gold.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isActive
                  ? luxury.gold.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: isActive ? luxury.gold : Colors.white,
            size: 22.sp,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// RESULT CARD WIDGET
// ============================================================================

class _ResultCard extends StatelessWidget {
  final CheckInResult result;

  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final isAllowed = result.isAllowed;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isAllowed
              ? [
                  Colors.green.withValues(alpha: 0.9),
                  Colors.green.shade700.withValues(alpha: 0.9),
                ]
              : [
                  Colors.red.withValues(alpha: 0.9),
                  Colors.red.shade700.withValues(alpha: 0.9),
                ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isAllowed
              ? Colors.green.shade300.withValues(alpha: 0.5)
              : Colors.red.shade300.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isAllowed ? Colors.green : Colors.red).withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status icon
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAllowed ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: Colors.white,
              size: 48.sp,
            ),
          ),
          SizedBox(height: 16.h),

          // Status text
          Text(
            isAllowed ? 'CHECK-IN APPROVED' : 'CHECK-IN DENIED',
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 8.h),

          // User name or rejection reason
          Text(
            isAllowed
                ? result.userName ?? 'Member'
                : result.status.displayMessage,
            style: GoogleFonts.inter(
              fontSize: isAllowed ? 20.sp : 14.sp,
              fontWeight: isAllowed ? FontWeight.w700 : FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.95),
            ),
            textAlign: TextAlign.center,
          ),

          // Additional info for allowed check-ins
          if (isAllowed) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (result.subscriptionType != null) ...[
                    Icon(
                      Icons.workspace_premium_rounded,
                      color: luxury.goldLight,
                      size: 16.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      result.subscriptionType!,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                  if (result.remainingVisits != null) ...[
                    if (result.subscriptionType != null)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        width: 1,
                        height: 14.h,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    Icon(
                      Icons.confirmation_number_rounded,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 16.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '${result.remainingVisits} visits left',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// PROCESSING CARD WIDGET
// ============================================================================

class _ProcessingCard extends StatelessWidget {
  const _ProcessingCard();

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(luxury.gold),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            'Validating...',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TODAY'S CHECK-INS CARD
// ============================================================================

class _TodayCheckInsCard extends StatelessWidget {
  final int checkInCount;

  const _TodayCheckInsCard({required this.checkInCount});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.gold.withValues(alpha: 0.15),
            luxury.gold.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [luxury.gold, luxury.goldLight],
              ).createShader(bounds);
            },
            child: Icon(
              Icons.people_alt_rounded,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Check-ins',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              Text(
                '$checkInCount',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: luxury.gold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// RECENT SCANS SECTION
// ============================================================================

class _RecentScansSection extends StatelessWidget {
  final List<CheckInResult> scans;

  const _RecentScansSection({required this.scans});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            'Recent Scans',
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 1,
            ),
          ),
        ),
        SizedBox(
          height: 60.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: scans.take(5).length,
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final scan = scans[index];
              return _RecentScanChip(result: scan);
            },
          ),
        ),
      ],
    );
  }
}

class _RecentScanChip extends StatelessWidget {
  final CheckInResult result;

  const _RecentScanChip({required this.result});

  @override
  Widget build(BuildContext context) {
    final isAllowed = result.isAllowed;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isAllowed
            ? Colors.green.withValues(alpha: 0.2)
            : Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isAllowed
              ? Colors.green.withValues(alpha: 0.4)
              : Colors.red.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAllowed ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isAllowed ? Colors.green : Colors.red,
            size: 18.sp,
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                result.userName ?? (isAllowed ? 'Approved' : 'Denied'),
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (result.checkedInAt != null)
                Text(
                  _formatTime(result.checkedInAt!),
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:$minute $period';
  }
}

// ============================================================================
// CAMERA ERROR WIDGET
// ============================================================================

class _CameraErrorWidget extends StatelessWidget {
  final MobileScannerException error;

  const _CameraErrorWidget({required this.error});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;

    String errorMessage;
    IconData errorIcon;

    switch (error.errorCode) {
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Camera permission denied.\nPlease enable camera access in settings.';
        errorIcon = Icons.no_photography_rounded;
        break;
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Camera is not supported on this device.';
        errorIcon = Icons.videocam_off_rounded;
        break;
      default:
        errorMessage = 'Failed to initialize camera.\n${error.errorDetails?.message ?? ''}';
        errorIcon = Icons.error_outline_rounded;
    }

    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  errorIcon,
                  color: Colors.red,
                  size: 48.sp,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Camera Error',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                errorMessage,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              if (error.errorCode == MobileScannerErrorCode.permissionDenied)
                _OpenSettingsButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _OpenSettingsButton extends StatelessWidget {
  const _OpenSettingsButton();

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Open app settings
          // You might want to use permission_handler's openAppSettings()
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [luxury.gold, luxury.goldLight],
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: luxury.gold.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.settings_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Text(
                'Open Settings',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SCANNER OVERLAY PAINTER
// ============================================================================

class _ScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final Color overlayColor;
  final double borderRadius;
  final double borderWidth;
  final double scanAreaSize;

  _ScannerOverlayPainter({
    required this.borderColor,
    required this.overlayColor,
    required this.borderRadius,
    required this.borderWidth,
    required this.scanAreaSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scanRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    // Draw overlay
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(scanRect, Radius.circular(borderRadius)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(
      overlayPath,
      Paint()..color = overlayColor,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
