import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Magical Subscription Promo - Compact Edition
///
/// Features:
/// - Compact glowing gold card
/// - Refined icon and text
/// - Full Light/Dark mode compliance
/// - NO animations
class BuildSubscriptionPromo extends StatelessWidget {
  const BuildSubscriptionPromo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GestureDetector(
        onTap: () => context.push('/member/subscriptions/bundles'),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [luxury.gold.withValues(alpha: 0.1), luxury.gold.withValues(alpha: 0.04)]
                  : [colorScheme.primaryContainer, colorScheme.primaryContainer.withValues(alpha: 0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark ? luxury.gold.withValues(alpha: 0.25) : colorScheme.primary.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? luxury.gold : colorScheme.primary).withValues(alpha: isDark ? 0.15 : 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  gradient: isDark ? luxury.goldGradient : luxury.primaryGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: isDark ? AppColors.backgroundDark : Colors.white,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "PREMIUM",
                          style: GoogleFonts.montserrat(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark ? luxury.gold : colorScheme.primary,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: luxury.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            "20% OFF",
                            style: GoogleFonts.montserrat(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w700,
                              color: luxury.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      "Unlock All Gyms",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: (isDark ? luxury.gold : colorScheme.primary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: isDark ? luxury.gold : colorScheme.primary,
                  size: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}