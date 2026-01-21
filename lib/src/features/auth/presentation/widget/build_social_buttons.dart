import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';

class BuildSocialButtons extends StatelessWidget {
  const BuildSocialButtons({
    super.key,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
  });

  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSocialButton(
          text: "Continue with Google",
          icon: Icons.g_mobiledata_rounded,
          iconColor: Colors.white,
          backgroundColor: AppColors.surfaceElevatedDark,
          onTap: onGoogleSignIn,
        ),
        SizedBox(height: 12.h,),
        _buildSocialButton(
          text: 'Continue with Apple', 
          icon: Icons.apple_rounded, 
          iconColor: Colors.black, 
          backgroundColor: Colors.white, 
          textColor: Colors.black,
          onTap: onAppleSignIn,
          )
      ],
    );
  }

  Widget _buildSocialButton({
    required String text,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.borderDark,
            width: 1,
          )
        ),
        child: Row(
          mainAxisAlignment:MainAxisAlignment.center ,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: iconColor,
            ),
            SizedBox(width: 12.w,),
            Text(
              text,
              style: AppTextStyles.bodyLarge.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            )
          ],

        ),
      ),
    );
  }
  
}
