import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury Header for Home screen
///
/// Features:
/// - Elegant greeting with premium typography
/// - Notification button with gold accent
/// - Profile avatar with gradient and glow
/// - Full Light/Dark mode compliance
/// - NO animations (static luxury design)
class BuildHeader extends StatelessWidget {
  final String userName;

  const BuildHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting with gold accent
                Row(
                  children: [
                    Text(
                      "Hi, ",
                      style: GoogleFonts.inter(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: isDark
                              ? [colorScheme.onSurface, luxury.goldLight]
                              : [colorScheme.primary, colorScheme.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: Text(
                        "$userName ",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      "👋",
                      style: TextStyle(fontSize: 22.sp),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  'Ready to elevate your fitness?',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          // Notification button with luxury styling
          _LuxuryIconButton(
            icon: Icons.notifications_outlined,
            onTap: _onNotificationsTab,
            hasNotification: true,
          ),
          SizedBox(width: 12.w),
          // Profile avatar with gradient and glow
          _LuxuryProfileAvatar(
            userName: userName,
            onTap: _onProfileTab,
          ),
        ],
      ),
    );
  }

  void _onNotificationsTab() {
    // todo: navigate to notifications screen
  }

  void _onProfileTab() {
    // todo: navigate to profile screen
  }
}

/// Static Luxury Icon Button (no animations)
class _LuxuryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasNotification;

  const _LuxuryIconButton({
    required this.icon,
    required this.onTap,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(11.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [luxury.surfaceElevated, luxury.surfacePremium]
                : [colorScheme.surface, colorScheme.surfaceContainerHighest ?? colorScheme.surface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isDark
                ? luxury.gold.withValues(alpha: 0.15)
                : colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: luxury.cardShadow.withValues(alpha: isDark ? 0.3 : 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: isDark
                      ? [colorScheme.onSurface, luxury.gold.withValues(alpha: 0.7)]
                      : [colorScheme.onSurface, colorScheme.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Icon(
                icon,
                color: colorScheme.onSurface,
                size: 22.sp,
              ),
            ),
            // Notification indicator
            if (hasNotification)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        luxury.gold,
                        luxury.gold.withValues(alpha: 0.8),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: luxury.gold.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Static Luxury Profile Avatar (no animations)
class _LuxuryProfileAvatar extends StatelessWidget {
  final String userName;
  final VoidCallback onTap;

  const _LuxuryProfileAvatar({
    required this.userName,
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
        width: 46.w,
        height: 46.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.primary.withValues(alpha: 0.8),
              luxury.gold.withValues(alpha: isDark ? 0.6 : 0.4),
            ],
            stops: const [0.0, 0.6, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: luxury.gold.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: isDark ? 0.3 : 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: luxury.gold.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            userName[0].toUpperCase(),
            style: GoogleFonts.playfairDisplay(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
