import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/home/data/datasources/home_dummy_data_source.dart';
import 'package:mygym/src/features/home/domain/entities/fitness_class_entity.dart';

/// Premium Luxury Popular Classes Section
///
/// Features:
/// - Elegant section header with gold accent bar
/// - Premium glassmorphism class cards
/// - Gradient time badges
/// - Instructor info with avatar placeholder
/// - Full Light/Dark mode compliance
/// - NO animations (static luxury design)
class BuildPopularClasses extends StatelessWidget {
  const BuildPopularClasses({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Column(
      children: [
        // Section header with luxury styling
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.secondary,
                          isDark ? luxury.gold : colorScheme.primary,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Popular Classes',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _onSeeAllClasses,
                child: Row(
                  children: [
                    Text(
                      "See all",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? luxury.gold : colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12.sp,
                      color: (isDark ? luxury.gold : colorScheme.primary).withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 18.h),
        // Class cards
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: HomeDummyDataSource.classes.asMap().entries.map((entry) {
              final index = entry.key;
              final fitnessClass = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: _LuxuryClassCard(
                  fitnessClass: fitnessClass,
                  index: index,
                  onTap: () => onClassTap(fitnessClass),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _onSeeAllClasses() {
    // todo: navigate to classes screen
  }

  void onClassTap(FitnessClassEntity fitnessClass) {
    // todo: navigate to class details screen
  }
}

/// Static Luxury Class Card (no animations)
class _LuxuryClassCard extends StatelessWidget {
  final FitnessClassEntity fitnessClass;
  final int index;
  final VoidCallback onTap;

  const _LuxuryClassCard({
    required this.fitnessClass,
    required this.index,
    required this.onTap,
  });

  // Different accent colors for variety using theme colors
  Color _getAccentColor(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    final colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary, // Uses theme tertiary instead of hardcoded teal
      luxury.gold,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    final accentColor = _getAccentColor(colorScheme, luxury);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [luxury.surfaceElevated, luxury.surfacePremium]
                : [colorScheme.surface, colorScheme.surfaceContainerHighest ?? colorScheme.surface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isDark
                ? luxury.gold.withValues(alpha: 0.1)
                : colorScheme.outline.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: luxury.cardShadow.withValues(alpha: isDark ? 0.3 : 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: accentColor.withValues(alpha: isDark ? 0.05 : 0.03),
              blurRadius: 20,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji container with gradient background
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor.withValues(alpha: isDark ? 0.2 : 0.15),
                    accentColor.withValues(alpha: isDark ? 0.08 : 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: accentColor.withValues(alpha: isDark ? 0.2 : 0.15),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  fitnessClass.emoji,
                  style: TextStyle(fontSize: 32.sp),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            // Class info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fitnessClass.name,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      // Instructor avatar placeholder
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              accentColor.withValues(alpha: 0.6),
                              accentColor.withValues(alpha: 0.3),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            fitnessClass.instructor[0].toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        fitnessClass.instructor,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Time and duration
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Time badge with gradient
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor,
                        accentColor.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: isDark ? 0.3 : 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    fitnessClass.time,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                // Duration
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 12.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      fitnessClass.duration,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
