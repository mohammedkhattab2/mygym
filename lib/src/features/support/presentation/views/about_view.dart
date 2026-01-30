import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/settings/domain/entities/app_settings.dart';
import 'package:mygym/src/features/support/presentation/cubit/support_cubit.dart';

/// Premium Luxury About View
///
/// Features:
/// - Static glowing orbs (no motion/parallax)
/// - Premium glassmorphism about cards
/// - Gold gradient accents and elegant typography
/// - Full Light/Dark mode compliance
/// - NO animations (static luxury design)
class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  void _setSystemUI(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
    _setSystemUI(context);
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

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
                  // Custom luxury app bar
                  _buildLuxuryAppBar(colorScheme, luxury),

                  // About content
                  Expanded(
                    child: BlocBuilder<SupportCubit, SupportState>(
                      builder: (context, state) {
                        final info = state.aboutInfo;
                        if (state.isLoading && info == null) {
                          return _buildLoadingState(colorScheme, luxury);
                        }
                        if (info == null) {
                          return _buildEmptyState(colorScheme, luxury);
                        }
                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                          children: [
                            // App branding card
                            _LuxuryBrandingCard(info: info),
                            SizedBox(height: 20.h),
                            // Contact section
                            _LuxuryContactSection(info: info),
                            SizedBox(height: 20.h),
                            // Legal section
                            _LuxuryLegalSection(info: info),
                            SizedBox(height: 40.h),
                          ],
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
                  'INFORMATION',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'About',
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
          SizedBox(height: 16.h),
          Text(
            'Loading...',
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

  Widget _buildEmptyState(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [luxury.textTertiary, luxury.gold.withValues(alpha: 0.5)],
              ).createShader(bounds);
            },
            child: Icon(
              Icons.info_outline_rounded,
              color: colorScheme.onPrimary,
              size: 48.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No information available',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LUXURY ICON BUTTON
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

    return GestureDetector(
      onTap: onTap,
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
    );
  }
}

// ============================================================================
// LUXURY BRANDING CARD
// ============================================================================

class _LuxuryBrandingCard extends StatelessWidget {
  final AboutInfo info;

  const _LuxuryBrandingCard({required this.info});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.12),
            luxury.gold.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // App logo
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: luxury.gold.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      colorScheme.onPrimary,
                      luxury.goldLight,
                    ],
                  ).createShader(bounds);
                },
                child: Icon(
                  Icons.fitness_center_rounded,
                  color: colorScheme.onPrimary,
                  size: 40.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // App name
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  colorScheme.onSurface,
                  luxury.gold.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Text(
              info.appName,
              style: GoogleFonts.playfairDisplay(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Version badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  luxury.gold.withValues(alpha: 0.15),
                  luxury.goldLight.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: luxury.gold.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Text(
              'v${info.version} (${info.buildNumber})',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: luxury.gold,
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Tagline
          Text(
            'Premium Fitness Experience',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: luxury.textTertiary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LUXURY CONTACT SECTION
// ============================================================================

class _LuxuryContactSection extends StatelessWidget {
  final AboutInfo info;

  const _LuxuryContactSection({required this.info});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
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
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.2),
                      colorScheme.secondary.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [colorScheme.primary, colorScheme.secondary],
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.contact_support_rounded,
                    color: colorScheme.onPrimary,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Contact',
                style: GoogleFonts.montserrat(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Contact items
          _LuxuryContactItem(
            icon: Icons.email_rounded,
            label: 'Email',
            value: info.contactEmail,
            colors: [colorScheme.primary, colorScheme.secondary],
          ),
          SizedBox(height: 12.h),
          _LuxuryContactItem(
            icon: Icons.language_rounded,
            label: 'Website',
            value: info.websiteUrl,
            colors: [luxury.gold, luxury.goldLight],
          ),
        ],
      ),
    );
  }
}

class _LuxuryContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<Color> colors;

  const _LuxuryContactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors[0].withValues(alpha: 0.06),
            colors[1].withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors[0].withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors[0].withValues(alpha: 0.15),
                  colors[1].withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(colors: colors).createShader(bounds);
              },
              child: Icon(
                icon,
                color: colorScheme.onPrimary,
                size: 18.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Content
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
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
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
// LUXURY LEGAL SECTION
// ============================================================================

class _LuxuryLegalSection extends StatelessWidget {
  final AboutInfo info;

  const _LuxuryLegalSection({required this.info});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.surfaceElevated.withValues(alpha: 0.6),
            colorScheme.surface.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [luxury.textTertiary, luxury.gold.withValues(alpha: 0.5)],
              ).createShader(bounds);
            },
            child: Icon(
              Icons.copyright_rounded,
              color: colorScheme.onPrimary,
              size: 24.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            info.copyright,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: luxury.textTertiary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
