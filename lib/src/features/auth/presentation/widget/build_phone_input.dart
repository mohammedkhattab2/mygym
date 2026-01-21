import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';

class BuildPhoneInput extends StatelessWidget {
  const BuildPhoneInput({
    super.key,
    required this.phoneController,
    required this.selectedCountryCode,
    required this.selectedCountryFlag,
    required this.onShowCountryPicker,
  });

  final TextEditingController phoneController;
  final String selectedCountryCode;
  final String selectedCountryFlag;
  final VoidCallback onShowCountryPicker;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        children: [
          // Country code selector
          GestureDetector(
            onTap: onShowCountryPicker,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: AppColors.borderDark),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedCountryFlag,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    selectedCountryCode,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white70,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
          // Phone input field
          Expanded(
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.sp,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
              decoration: InputDecoration(
                hintText: 'Phone number',
                hintStyle: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}