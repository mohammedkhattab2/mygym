import 'package:flutter/material.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';

class BuildTerms extends StatelessWidget {
  const BuildTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'By continuing, you agree to our ',
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textTertiaryDark,
        ) ,
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            )
          ),
          const TextSpan(
            text: " and ",
          ),
          TextSpan(
            text: "Privacy Policy",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            )
          )
        ]
      ),
      textAlign: TextAlign.center,
    );
  }
}