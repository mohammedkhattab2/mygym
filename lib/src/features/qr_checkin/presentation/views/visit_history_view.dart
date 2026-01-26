import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/qr_checkin/domain/entities/qr_token.dart';
import 'package:mygym/src/features/qr_checkin/presentation/bloc/qr_checkin_cubit.dart';

/// Premium Luxury Visit History View
///
/// Features:
/// - Static glowing orbs with premium styling
/// - Premium glassmorphism visit cards
/// - Gold gradient accents and elegant typography
/// - Timeline connector design
/// - Refined luxury styling without animations
class VisitHistoryView extends StatefulWidget {
  const VisitHistoryView({super.key});

  @override
  State<VisitHistoryView> createState() => _VisitHistoryViewState();
}

class _VisitHistoryViewState extends State<VisitHistoryView> {
  late Future<List<VisitEntry>> _futureVisits;

  @override
  void initState() {
    super.initState();
    _setSystemUI();
    _futureVisits = context.read<QrCheckinCubit>().getVisitHistory(limit: 50);
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
                  
                  // Visit history content
                  Expanded(
                    child: FutureBuilder<List<VisitEntry>>(
                      future: _futureVisits,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _buildLoadingState(colorScheme, luxury);
                        }
                        if (snapshot.hasError) {
                          return _buildErrorState(colorScheme);
                        }
                        final visits = snapshot.data ?? [];
                        if (visits.isEmpty) {
                          return _buildEmptyState(colorScheme, luxury);
                        }
                        return _buildVisitsList(visits);
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
                  'YOUR ACTIVITY',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Visit History',
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
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(luxury.gold),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading history...',
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

  Widget _buildErrorState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.sp,
            color: colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(
            "Failed to load visit history",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    luxury.surfaceElevated.withValues(alpha: 0.6),
                    colorScheme.surface.withValues(alpha: 0.4),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      luxury.textTertiary,
                      luxury.gold.withValues(alpha: 0.5),
                    ],
                  ).createShader(bounds);
                },
                child: Icon(
                  Icons.history_rounded,
                  color: colorScheme.onPrimary,
                  size: 48.sp,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "No visits yet",
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Your gym check-in history will appear here after your first visit.",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: luxury.textTertiary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitsList(List<VisitEntry> visits) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      itemCount: visits.length,
      itemBuilder: (context, index) {
        final visit = visits[index];
        final isFirst = index == 0;
        final isLast = index == visits.length - 1;
        return _LuxuryVisitCard(
          visit: visit,
          isFirst: isFirst,
          isLast: isLast,
        );
      },
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
// LUXURY VISIT CARD (Static - No Animation)
// ============================================================================

class _LuxuryVisitCard extends StatelessWidget {
  final VisitEntry visit;
  final bool isFirst;
  final bool isLast;

  const _LuxuryVisitCard({
    required this.visit,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final checkIn = visit.checkInTime;
    final checkOut = visit.checkOutTime;
    final isActive = checkOut == null;
    final dateStr =
        '${checkIn.day.toString().padLeft(2, '0')}/${checkIn.month.toString().padLeft(2, '0')}/${checkIn.year}';
    final timeStr =
        '${checkIn.hour.toString().padLeft(2, '0')}:${checkIn.minute.toString().padLeft(2, '0')}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        SizedBox(
          width: 30.w,
          child: Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 10.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        luxury.gold.withValues(alpha: 0.1),
                        luxury.gold.withValues(alpha: 0.3),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isActive
                        ? [luxury.success, luxury.success.withValues(alpha: 0.7)]
                        : [luxury.gold, luxury.goldLight],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isActive ? luxury.success : luxury.gold)
                          .withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 80.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        luxury.gold.withValues(alpha: 0.3),
                        luxury.gold.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(width: 14.w),
        
        // Visit card
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 14.h),
            padding: EdgeInsets.all(16.w),
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
                color: isActive
                    ? luxury.success.withValues(alpha: 0.3)
                    : luxury.gold.withValues(alpha: 0.1),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gym avatar
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.2),
                        luxury.gold.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: luxury.gold.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: [colorScheme.primary, luxury.gold],
                        ).createShader(bounds);
                      },
                      child: Text(
                        visit.gymName.isNotEmpty
                            ? visit.gymName[0].toUpperCase()
                            : "G",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                
                // Visit details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              visit.gymName,
                              style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          // Status badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isActive
                                    ? [
                                        luxury.success.withValues(alpha: 0.2),
                                        luxury.success.withValues(alpha: 0.1),
                                      ]
                                    : [
                                        colorScheme.surface,
                                        colorScheme.surface,
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isActive
                                    ? luxury.success.withValues(alpha: 0.3)
                                    : colorScheme.outline.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              isActive ? 'Active' : 'Done',
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? luxury.success
                                    : luxury.textTertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      
                      // Date and time
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 12.sp,
                            color: luxury.textTertiary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '$dateStr • $timeStr',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      
                      // Duration
                      Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 12.sp,
                            color: luxury.textTertiary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Duration: ${visit.formattedDuration}',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      
                      // Remaining visits
                      if (visit.visitsAfter != null) ...[
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: [luxury.gold, luxury.goldLight],
                                ).createShader(bounds);
                              },
                              child: Icon(
                                Icons.confirmation_number_rounded,
                                size: 12.sp,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '${visit.visitsAfter} visits remaining',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: luxury.gold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
