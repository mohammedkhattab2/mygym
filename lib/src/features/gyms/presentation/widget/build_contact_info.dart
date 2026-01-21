import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';

class BuildContactInfo extends StatelessWidget {
  final Gym gym;
  const BuildContactInfo({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    final contact = gym.contactInfo;
    if (contact == null) return const SizedBox.shrink();
    final items = <Widget>[];
    if (contact.phone != null && contact.phone!.isNotEmpty) {
      items.add(_contactRow(Icons.phone_rounded, contact.phone!));
    }
    if (contact.email != null && contact.email!.isNotEmpty) {
      items.add(_contactRow(Icons.email_rounded, contact.email!));
    }
    if (contact.website != null && contact.website!.isNotEmpty) {
      items.add(_contactRow(Icons.public_rounded, contact.website!));
    }
    if (contact.whatsapp != null && contact.whatsapp!.isNotEmpty) {
      items.add(
        _contactRow(Icons.contact_emergency_rounded, contact.whatsapp!),
      );
    }
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact",
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h,),
        ...items,
      ],
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: AppColors.textSecondaryDark),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
