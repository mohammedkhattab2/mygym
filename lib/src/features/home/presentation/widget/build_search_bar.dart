import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury Search Bar
///
/// Features:
/// - Glassmorphism effect with gold accent border
/// - Gradient search icon
/// - Elegant filter button with glow
/// - Full Light/Dark mode compliance
/// - NO animations (static luxury design)
class BuildSearchBar extends StatelessWidget {
  const BuildSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GestureDetector(
        onTap: _onSearchTab,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
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
                  ? luxury.gold.withValues(alpha: 0.12)
                  : colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: luxury.cardShadow.withValues(alpha: isDark ? 0.3 : 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Search icon with gradient
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: isDark
                        ? [colorScheme.onSurface.withValues(alpha: 0.7), luxury.gold.withValues(alpha: 0.6)]
                        : [colorScheme.onSurface.withValues(alpha: 0.6), colorScheme.primary.withValues(alpha: 0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Icon(
                  Icons.search_rounded,
                  color: colorScheme.onSurface,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  "Search gyms, classes...",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
              // Filter button with luxury styling
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            colorScheme.primary.withValues(alpha: 0.15),
                            luxury.gold.withValues(alpha: 0.08),
                          ]
                        : [
                            colorScheme.primary.withValues(alpha: 0.1),
                            colorScheme.secondary.withValues(alpha: 0.08),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isDark
                        ? luxury.gold.withValues(alpha: 0.15)
                        : colorScheme.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        colorScheme.primary,
                        isDark ? luxury.gold : colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.tune_rounded,
                    color: colorScheme.onSurface,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchTab() {
    // todo: navigate to search screen
  }
}