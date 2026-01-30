import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GrowthBadge extends StatelessWidget {
  final double growth;
  final bool compact;
  const GrowthBadge({super.key, required this.growth, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final isPositive = growth >= 0;
    final color = isPositive ? Colors.green : Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6.w : 10.w,
        vertical: compact ? 3.h : 5.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha:  0.2))
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              color: color,
              size: compact ? 12.sp : 14.sp,
            ),
            SizedBox(width: compact ? 2.w : 4.w,),
            Text(
              '${growth.abs().toStringAsFixed(compact ? 0 : 1)}%',
              style: TextStyle(
                fontSize: compact ? 10.sp : 12.sp,
                fontWeight: FontWeight.w700,
                color: color
              ),
            )
          ],
        ),
      ),
    );
  }
}