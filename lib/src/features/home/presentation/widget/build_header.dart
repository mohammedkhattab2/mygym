import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Magical Header - Compact Edition
///
/// Features:
/// - Compact greeting with gradient text
/// - Minimal notification button with glow indicator
/// - Refined profile avatar
/// - Full Light/Dark mode compliance
/// - NO animations
class BuildHeader extends StatelessWidget {
  final String userName;

  const BuildHeader({super.key, required this.userName});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: luxury.textTertiary,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: isDark
                            ? [colorScheme.onSurface, luxury.gold]
                            : [colorScheme.primary, colorScheme.secondary],
                      ).createShader(bounds),
                      child: Text(
                        userName,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text('👋', style: TextStyle(fontSize: 18.sp)),
                  ],
                ),
              ],
            ),
          ),
          // Notification
          _CompactIconButton(
            icon: Icons.notifications_outlined,
            hasIndicator: true,
            onTap: () {},
          ),
          SizedBox(width: 10.w),
          // Profile
          _CompactProfileAvatar(userName: userName, onTap: () {}),
        ],
      ),
    );
  }
}

class _CompactIconButton extends StatelessWidget {
  final IconData icon;
  final bool hasIndicator;
  final VoidCallback onTap;

  const _CompactIconButton({
    required this.icon,
    this.hasIndicator = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: isDark ? luxury.surfaceElevated : colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDark ? luxury.borderLight.withOpacity(0.5) : colorScheme.outline.withOpacity(0.1),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: colorScheme.onSurface, size: 20.sp),
            if (hasIndicator)
              Positioned(
                right: -2.w,
                top: -2.h,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    gradient: luxury.goldGradient,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.backgroundDark : colorScheme.surface,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CompactProfileAvatar extends StatelessWidget {
  final String userName;
  final VoidCallback onTap;

  const _CompactProfileAvatar({required this.userName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.secondary.withOpacity(0.8),
              luxury.gold.withOpacity(isDark ? 0.4 : 0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: luxury.gold.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(isDark ? 0.25 : 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            userName[0].toUpperCase(),
            style: GoogleFonts.playfairDisplay(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
