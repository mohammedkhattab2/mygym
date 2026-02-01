import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/settings_card.dart';

class BlockedUsersSection extends StatelessWidget {
  final List<String> blockedIds;
  const BlockedUsersSection({super.key, required this.blockedIds});

  @override
  Widget build(BuildContext context) {
     final colorScheme = Theme.of(context).colorScheme;
    return SettingsCard(
      title: 'Blocked Users', 
      icon: Icons.block_rounded, 
      iconColor: Colors.red, 
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Text(
          '${blockedIds.length}',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: Colors.red
          ),
        ),
      ),
      children: [
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.red.withValues(alpha: 0.15))
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.red, size: 20.sp,),
              SizedBox(width:12.w ,),
              Expanded(
                child: Text(
                  'You have ${blockedIds.length} blocked user${blockedIds.length > 1 ? 's' : ''}. These users cannot check-in at your gym.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colorScheme.onSurfaceVariant,
                )
                )
                )
            ],

          ),
        ),
        SizedBox(height: 12.h,),
        OutlinedButton.icon(
          onPressed: () => context.go(RoutePaths.partnerBlockedUsers),
          icon: const Icon(Icons.manage_accounts_rounded),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: BorderSide(color: Colors.red.withValues(alpha: 0.5))
          ),
          label: const Text(" Manage Blocked Users"),
          )

      ]
      );
  }
}