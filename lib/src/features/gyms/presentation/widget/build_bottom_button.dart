import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';

class BuildBottomButton extends StatelessWidget {
  final BuildContext context;
  final Gym gym;
  const BuildBottomButton({super.key, required this.context , required this.gym});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border:Border(
          top: BorderSide(color: AppColors.borderDark) 
        ) 
        
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: (){
            // TODO: روح لصفحة QR Check-in:
            // context.go(RoutePaths.qr);
          }, 
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r)
            ) 
          ),
          child: Text(
            "Check In ",
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600, 
            ),
          )
          ),
      ),
    );
  }
}
