import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GrowthBadge extends StatelessWidget {
  final double growth; 
  const GrowthBadge({super.key, required this.growth});

  @override
  Widget build(BuildContext context) {
    final isPositive = growth >= 0;
    final color = isPositive ? Colors.green : Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive? Icons.trending_up_rounded : Icons.trending_down_rounded,
            color: color,
            size: 14.sp,
          ),
          SizedBox(width: 4.w,),
          Text(
            '${growth.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: color
            ),
          )
          ],
      ),
    );
  }
}
