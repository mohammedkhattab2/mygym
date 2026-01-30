import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/presentation/widget/growth_badge.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final double? growth;
  final Color color;
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.growth,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withValues(alpha: 0.2))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r)
                ),
                child: Icon(icon, color: color, size: 16.sp,),
              ),
              if (growth != null)
                Flexible(
                  child: GrowthBadge(growth: growth!, compact: true,),
                ),
            ],
          ),
          SizedBox(height: 12.h,),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h,),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          )
        ],
      ),
    );
  }
}
