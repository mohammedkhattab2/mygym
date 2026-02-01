import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LimitCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;
  const LimitCard({super.key, 
     required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,color: color, size: 18.sp,),
              SizedBox(width: 6.w,),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            ],
          ),
          SizedBox(height: 10.h,),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: color
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 10.sp,
              color: colorScheme.onSurfaceVariant,
            ),
          )
        ],
      ),
    );
  }
}