import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/settings_card.dart';

class NetworkSettingsSection extends StatelessWidget {
  final PartnerSettings settings;
  const NetworkSettingsSection({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    return SettingsCard(
      title: "Network Settings", 
      icon: Icons.hub_rounded, 
      iconColor: Colors.teal, 
      children: [
        Container(
          padding:EdgeInsets.all(14.w) ,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.15))
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: settings.allowNetworkSubscriptions
                     ? Colors.teal.withValues(alpha: 0.15)
                     : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10.r)
                ),
                child: Icon(
                  Icons.public_rounded,
                  color: settings.allowNetworkSubscriptions
                     ? Colors.teal
                     : colorScheme.onSurfaceVariant,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 14.w,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Members with network plans can visit your gym",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    )
                  ],
                )
                ),
                Switch(
                  value: settings.allowNetworkSubscriptions, 
                  onChanged: (value){
                    // TODO: Implement toggle
                  },
                  activeThumbColor: luxury.gold,
                  )
            ],
          ),
        )
      ]
      );
  }
}