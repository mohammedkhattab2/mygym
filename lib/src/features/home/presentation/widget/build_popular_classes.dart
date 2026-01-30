import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/home/data/datasources/home_dummy_data_source.dart';
import 'package:mygym/src/features/home/domain/entities/fitness_class_entity.dart';

/// Premium Magical Popular Classes - Compact Edition
///
/// Features:
/// - Compact section header
/// - Refined class cards with glow
/// - Full Light/Dark mode compliance
/// - NO animations
class BuildPopularClasses extends StatelessWidget {
  const BuildPopularClasses({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Column(
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 3.w,
                    height: 18.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.secondary, isDark ? luxury.gold : colorScheme.primary],
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
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.push(RoutePaths.classesCalendar),
                child: Text(
                  "See all",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? luxury.gold : colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14.h),
        // Class cards
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: HomeDummyDataSource.classes.asMap().entries.map((entry) {
              final index = entry.key;
              final fitnessClass = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _CompactClassCard(
                  fitnessClass: fitnessClass,
                  index: index,
                  onTap: () {},
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _CompactClassCard extends StatelessWidget {
  final FitnessClassEntity fitnessClass;
  final int index;
  final VoidCallback onTap;

  const _CompactClassCard({
    required this.fitnessClass,
    required this.index,
    required this.onTap,
  });

  Color _getAccentColor(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    final colors = [colorScheme.primary, colorScheme.secondary, colorScheme.tertiary, luxury.gold];
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
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDark ? luxury.surfaceElevated : colorScheme.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isDark ? accentColor.withValues(alpha: 0.12) : colorScheme.outline.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: isDark ? 0.08 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji container
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha:  isDark ? 0.15 : 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(fitnessClass.emoji, style: TextStyle(fontSize: 24.sp)),
              ),
            ),
            SizedBox(width: 12.w),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fitnessClass.name,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Container(
                        width: 18.w,
                        height: 18.w,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha:  0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            fitnessClass.instructor[0],
                            style: GoogleFonts.inter(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        fitnessClass.instructor,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: luxury.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    fitnessClass.time,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 11.sp, color: luxury.textMuted),
                    SizedBox(width: 3.w),
                    Text(
                      fitnessClass.duration,
                      style: GoogleFonts.inter(fontSize: 10.sp, color: luxury.textMuted),
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
