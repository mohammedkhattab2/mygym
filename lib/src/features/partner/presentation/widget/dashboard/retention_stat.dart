import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RetentionStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const RetentionStat({super.key, required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha:  0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withValues(alpha:  0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20.sp,),
          SizedBox(height: 8.h,),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 2.h,),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}