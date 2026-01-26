import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/qr_checkin/domain/entities/qr_token.dart';
import 'package:mygym/src/features/qr_checkin/presentation/bloc/qr_checkin_cubit.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Premium Luxury QR Check-in View
///
/// Features:
/// - Static glowing orbs with premium styling
/// - Premium glassmorphism QR card
/// - Gold gradient accents and elegant typography
/// - Timer with gradient progress
/// - Refined luxury styling without animations
class QrCheckInView extends StatefulWidget {
  final String? gymId;
  const QrCheckInView({super.key, this.gymId});

  @override
  State<QrCheckInView> createState() => _QrCheckInViewState();
}

class _QrCheckInViewState extends State<QrCheckInView> {
  bool _systemUISet = false;

  @override
  void initState() {
    super.initState();
    // Generate token after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QrCheckinCubit>().generateToken(gymId: widget.gymId);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_systemUISet) {
      _systemUISet = true;
      _setSystemUI();
    }
  }

  void _setSystemUI() {
    final isDark = context.isDarkMode;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withValues(alpha: 0.95),
              luxury.surfaceElevated,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Custom app bar
                  _buildLuxuryAppBar(colorScheme, luxury),
                  
                  // QR content
                  Expanded(
                    child: BlocBuilder<QrCheckinCubit, QrCheckinState>(
                      builder: (context, state) {
                        final token = state.currentToken;

                        if (state.isLoading && token == null) {
                          return _buildLoadingState(colorScheme, luxury);
                        }
                        if (state.error != null && token == null) {
                          return _buildError(context, colorScheme, state.error!);
                        }
                        if (token == null) {
                          return _buildError(context, colorScheme, 'No QR token available');
                        }
                        final isExpired = !token.isValid || state.secondsRemaining <= 0;
                        return _QrContent(
                          state: state,
                          token: token,
                          isExpired: isExpired,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLuxuryAppBar(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Back button
          _LuxuryIconButton(
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
                  'SCAN TO',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Check In',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50.w,
            height: 50.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(luxury.gold),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Generating QR code...',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, ColorScheme colorScheme, String message) {
    final luxury = context.luxury;
    
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.error.withValues(alpha: 0.15),
                    colorScheme.error.withValues(alpha: 0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: colorScheme.error,
                size: 48.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            _LuxuryButton(
              label: "Try Again",
              icon: Icons.refresh_rounded,
              onTap: () => context.read<QrCheckinCubit>().generateToken(),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// QR CONTENT WIDGET
// ============================================================================

class _QrContent extends StatelessWidget {
  final QrCheckinState state;
  final QrToken token;
  final bool isExpired;

  const _QrContent({
    required this.state,
    required this.token,
    required this.isExpired,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8.h),
          // Instruction text
          Text(
            'Show this QR code at the gym entrance to check in.',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 28.h),
          
          // QR Code with premium styling
          _QrCard(
            token: token,
            isExpired: isExpired,
          ),
          SizedBox(height: 24.h),
          
          // Timer and status
          _TimerAndStatus(state: state, isExpired: isExpired),
          SizedBox(height: 28.h),
          
          // Subscriber info card
          _InfoCard(token: token),
          SizedBox(height: 32.h),
          
          // Action button
          _LuxuryButton(
            label: isExpired ? 'Generate New QR' : 'Refresh QR',
            icon: Icons.refresh_rounded,
            isLoading: state.isRefreshing,
            onTap: () => context.read<QrCheckinCubit>().refreshToken(),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

class _QrCard extends StatelessWidget {
  final QrToken token;
  final bool isExpired;

  const _QrCard({
    required this.token,
    required this.isExpired,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    final glowIntensity = isExpired ? 0.0 : (isDark ? 0.4 : 0.25);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.surfaceElevated,
            colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: isExpired
              ? colorScheme.error.withValues(alpha: 0.3)
              : luxury.gold.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // QR code container - QR codes need white background for scanning
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                QrImageView(
                  data: token.toQrData(),
                  version: QrVersions.auto,
                  size: 200.w,
                  gapless: true,
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: isExpired ? colorScheme.outline : colorScheme.scrim,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: isExpired ? colorScheme.outline : colorScheme.scrim,
                  ),
                  backgroundColor: colorScheme.onPrimary,
                ),
                // Expired overlay
                if (isExpired)
                  Container(
                    width: 200.w,
                    height: 200.w,
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_off_rounded,
                          size: 48.sp,
                          color: colorScheme.error,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'EXPIRED',
                          style: GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.error,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          
          // Premium badge
          if (!isExpired)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    luxury.gold.withValues(alpha: 0.2),
                    luxury.gold.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: luxury.gold.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [luxury.gold, luxury.goldLight],
                      ).createShader(bounds);
                    },
                    child: Icon(
                      Icons.verified_rounded,
                      color: colorScheme.onPrimary,
                      size: 16.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'VERIFIED MEMBER',
                    style: GoogleFonts.montserrat(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: luxury.gold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TimerAndStatus extends StatelessWidget {
  final QrCheckinState state;
  final bool isExpired;

  const _TimerAndStatus({required this.state, required this.isExpired});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final seconds = state.secondsRemaining;
    final progress = seconds / 120.0;

    return Column(
      children: [
        // Timer display
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isExpired
                  ? [
                      colorScheme.error.withValues(alpha: 0.15),
                      colorScheme.error.withValues(alpha: 0.05),
                    ]
                  : [
                      luxury.surfaceElevated,
                      colorScheme.surface,
                    ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isExpired
                  ? colorScheme.error.withValues(alpha: 0.3)
                  : luxury.gold.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isExpired ? Icons.timer_off_rounded : Icons.timer_rounded,
                color: isExpired ? colorScheme.error : luxury.gold,
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Text(
                isExpired
                    ? "QR code expired"
                    : 'Valid for ${seconds.toString().padLeft(2, '0')}s',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: isExpired ? colorScheme.error : colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        
        // Progress bar (only when not expired)
        if (!isExpired) ...[
          Container(
            width: 200.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, luxury.gold],
                  ),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],
        
        // Status text
        Text(
          isExpired
              ? "Tap Refresh to generate a new QR code."
              : state.isExpiringSoon
                  ? 'QR is about to expire, a new one will be generated.'
                  : 'A new QR will be generated automatically before it expires.',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: luxury.textTertiary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final QrToken token;

  const _InfoCard({required this.token});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.surfaceElevated,
            colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [luxury.gold, luxury.goldLight],
                  ).createShader(bounds);
                },
                child: Icon(
                  Icons.person_rounded,
                  color: colorScheme.onPrimary,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                "Subscriber Info",
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          
          if (token.subscriptionId != null)
            _InfoRow(
              icon: Icons.confirmation_number_rounded,
              label: 'Subscription ID',
              value: token.subscriptionId!,
            ),
          if (token.remainingVisits != null)
            _InfoRow(
              icon: Icons.event_available_rounded,
              label: 'Remaining Visits',
              value: '${token.remainingVisits}',
              highlight: true,
            )
          else
            _InfoRow(
              icon: Icons.all_inclusive_rounded,
              label: 'Access',
              value: 'Network-wide',
              highlight: true,
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: highlight
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: highlight ? colorScheme.primary : luxury.textTertiary,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: luxury.textTertiary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: highlight ? colorScheme.primary : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LUXURY ICON BUTTON (Static - No Animation)
// ============================================================================

class _LuxuryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _LuxuryIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                luxury.surfaceElevated,
                colorScheme.surface,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: luxury.gold.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  colorScheme.onSurface,
                  luxury.gold.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Icon(
              icon,
              color: colorScheme.onPrimary,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LUXURY BUTTON (Static - No Animation)
// ============================================================================

class _LuxuryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isLoading;
  final VoidCallback onTap;

  const _LuxuryButton({
    required this.label,
    required this.icon,
    this.isLoading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.secondary,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: luxury.gold.withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onPrimary,
                  ),
                )
              else
                Icon(
                  icon,
                  color: colorScheme.onPrimary,
                  size: 20.sp,
                ),
              SizedBox(width: 10.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
