import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

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
        onTap: ()=>  context.push('/member/subscriptions/bundles'),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark?[
                luxury.gold.withValues(alpha: 0.15),
                luxury.gold.withValues(alpha: 0.05),
              ]:[
                colorScheme.primaryContainer,
                colorScheme.primaryContainer.withValues(alpha: 0.7)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isDark
                ? luxury.gold.withValues(alpha: 0.3)
                : colorScheme.primary.withValues(alpha: 0.2),
                width: 1
              ),
              boxShadow: [BoxShadow(
                color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                :colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
              ]
          ),
          child: Row(
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: isDark
                  ? luxury.gold.withValues(alpha:  0.2)
                  :colorScheme.primary.withValues(alpha:  0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: isDark? luxury.gold : colorScheme.primary,
                  size: 25.sp,
                ),
              ),
              SizedBox(width: 16.w,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "PREMIUM",
                          style: GoogleFonts.montserrat(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark? luxury.gold:colorScheme.primary,
                            letterSpacing: 2
                          ),
                        ),
                        SizedBox(width: 8.w,),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha:  0.2),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            "SAVE 20%",
                            style: GoogleFonts.montserrat(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 4.h,),
                    Text(
                      "Unlock All Gyms",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h,),
                    Text(
                      "Get unlimited access to premium facilities",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurface.withValues(alpha:  0.6),
                      ),
                    )
                  ],
                )
                ),
                Container(
                  width: 4.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: isDark
                    ? luxury.gold.withValues(alpha: 0.2)
                    : colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: isDark? luxury.gold : colorScheme.primary ,
                    size: 20.sp,
                  ),
                )
            ],
          ),
        ),
      ),
      );
  }
}