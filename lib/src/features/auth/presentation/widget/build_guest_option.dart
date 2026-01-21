import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';

class BuildGuestOption extends StatelessWidget {
  const BuildGuestOption({
    super.key,
    required this.onGuestLogin,
  });

  final VoidCallback onGuestLogin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onGuestLogin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline_rounded,
            color:AppColors.textSecondaryDark ,
            size: 20.sp,
          ),
          SizedBox(width: 8.w,),
          Text(
            "Continue as Guest",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          )

        ],
      ),
    );
  }
}