import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';
import 'package:mygym/src/features/gyms/presentation/bloc/gyms_bloc.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_about_section.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_bottom_button.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_contact_info.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_facilities.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_reviews_section.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_status_and_crowd.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_title_section.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_working_hours.dart';

/// Premium Luxury Gym Details View
///
/// Features:
/// - Static decorative glowing orbs with gold accents
/// - Premium hero header with gradient overlay
/// - Elegant typography with Google Fonts
/// - Gold gradient accents
/// - Full Light/Dark mode compliance
/// - No animations
class GymDetailsView extends StatefulWidget {
  final String gymId;
  const GymDetailsView({super.key, required this.gymId});

  @override
  State<GymDetailsView> createState() => _GymDetailsViewState();
}

class _GymDetailsViewState extends State<GymDetailsView> {

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Set system UI overlay style based on theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );

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
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Main content
            BlocBuilder<GymsBloc, GymsState>(
              builder: (context, state) {
                final detailStatus = state.detailStatus;
                final gym = state.selectedGym;

                if (detailStatus == GymsStatus.loading || gym == null) {
                  return _buildLoadingState(colorScheme, luxury);
                }
                if (detailStatus == GymsStatus.failure) {
                  return _buildError(colorScheme, state.errorMessage);
                }
                final isFavorite = state.favoriteIds.contains(gym.id);

                return Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          // Premium hero header
                          _buildSliverHeader(context, gym, isFavorite, colorScheme, luxury, isDark),
                          
                          // Content sections
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.h),
                                  BuildTitleSection(gym: gym),
                                  SizedBox(height: 20.h),
                                  BuildStatusAndCrowd(gym: gym),
                                  SizedBox(height: 20.h),
                                  BuildFacilities(gym: gym),
                                  SizedBox(height: 28.h),
                                  BuildAboutSection(gym: gym),
                                  SizedBox(height: 28.h),
                                  BuildWorkingHours(gym: gym),
                                  SizedBox(height: 28.h),
                                  BuildContactInfo(gym: gym),
                                  SizedBox(height: 28.h),
                                  BuildReviewsSection(context: context, state: state),
                                  SizedBox(height: 100.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bottom action button
                    BuildBottomButton(context: context, gym: gym),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context, Gym gym, bool isFavorite, ColorScheme colorScheme, LuxuryThemeExtension luxury, bool isDark) {
    final heroLetter = gym.name.isNotEmpty ? gym.name[0].toUpperCase() : "G";
    
    return SliverAppBar(
      expandedHeight: 260.h,
      pinned: true,
      stretch: true,
      backgroundColor: colorScheme.surface,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Hero gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.35),
                    colorScheme.secondary.withValues(alpha: 0.25),
                    luxury.gold.withValues(alpha: 0.15),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Decorative pattern overlay
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroPatternPainter(
                  color: (isDark ? colorScheme.onSurface : colorScheme.surface).withValues(alpha: 0.03),
                ),
              ),
            ),
            // Large hero letter
            Center(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      colorScheme.onPrimary.withValues(alpha: 0.08),
                      luxury.gold.withValues(alpha: 0.12),
                      colorScheme.onPrimary.withValues(alpha: 0.05),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  heroLetter,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 120.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            // Bottom gradient fade
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      colorScheme.surface.withValues(alpha: 0.6),
                      colorScheme.surface,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Custom app bar content - always visible title
      title: Text(
        gym.name,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: _LuxuryCircleButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: _LuxuryCircleButton(
            icon: isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: isFavorite ? Colors.red : null,
            onTap: () {
              context.read<GymsBloc>().add(
                GymsEvent.toggleFavorite(gym.id),
              );
            },
          ),
        ),
      ],
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
          SizedBox(height: 16.h),
          Text(
            'Loading gym details...',
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

  Widget _buildError(ColorScheme colorScheme, String? message) {
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
            message ?? "Failed to load gym details",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LUXURY CIRCLE BUTTON - No animations
// ============================================================================

class _LuxuryCircleButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const _LuxuryCircleButton({
    required this.icon,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              luxury.surfaceElevated.withValues(alpha: 0.9),
              colorScheme.surface.withValues(alpha: 0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(
            color: luxury.gold.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: isDark ? 0.4 : 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: iconColor ?? colorScheme.onSurface,
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HERO PATTERN PAINTER
// ============================================================================

class _HeroPatternPainter extends CustomPainter {
  final Color color;

  _HeroPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    
    // Draw diagonal lines
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
