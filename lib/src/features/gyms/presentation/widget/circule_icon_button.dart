import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CirculeIconButton extends StatelessWidget {
  final IconData icon ;
  final VoidCallback onTap ;
  final Color iconColor ;
  const CirculeIconButton({super.key, required this.icon , required this.onTap, this.iconColor= Colors.white  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 18.sp,
        ),
      ),
    );
  }
}