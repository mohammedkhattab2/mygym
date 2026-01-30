// lib/src/features/home/presentation/widget/build_classes_promo.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Classes Promotion Card for Home Screen
class BuildClassesPromo extends StatelessWidget {
  const BuildClassesPromo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GestureDetector(
        onTap: () => context.push('/member/classes'),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      colorScheme.secondary.withValues(alpha: 0.15),
                      colorScheme.primary.withValues(alpha: 0.05),
                    ]
                  : [
                      colorScheme.secondaryContainer,
                      colorScheme.secondaryContainer.withValues(alpha: 0.7),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isDark
                  ? colorScheme.secondary.withValues(alpha: 0.3)
                  : colorScheme.secondary.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : colorScheme.secondary.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.secondary.withValues(alpha: 0.2)
                      : colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: Text(
                    '🧘',
                    style: TextStyle(fontSize: 28.sp),
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'FITNESS CLASSES',
                          style: GoogleFonts.montserrat(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.secondary,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'NEW',
                            style: GoogleFonts.montserrat(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Book Your Workout',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Yoga, HIIT, Strength & more',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isDark
                      ? colorScheme.secondary.withValues(alpha: 0.2)
                      : colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: colorScheme.secondary,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}