import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/settings_card.dart';

class CapacitySection extends StatelessWidget {
  final PartnerSettings settings;
  const CapacitySection({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    return SettingsCard(
      title: "Capacity", 
      icon: Icons.group_rounded, 
      iconColor: Colors.purple, 
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.purple.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.purple.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10.r)
                ),
                child: Icon(Icons.people_alt_rounded,color: Colors.purple,size: 22.sp,),
              ),
              SizedBox(width: 14.w,),
              Expanded(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Maximum Capacity",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 4.h,),
                    Text(
                      '${settings.maxCapacity} people',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.purple
                      ),
                    )
                  ],
                ) 
              ),
              Icon(
                Icons.info_outline_rounded,
                size: 20.sp,
                color: colorScheme.onSurfaceVariant,
              )
            ],
          ),
        ),
        SizedBox(height: 16.h,),
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.sensors_rounded,
                color: settings.autoUpdateOccupancy? Colors.green : colorScheme.onSurfaceVariant,
                size: 22.sp,
              ),
              SizedBox(width: 12.w,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Auto Update Occupancy",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Track and display current occupancy to members',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    )
                  ],
                )
                ),
                Switch(
                  value: settings.autoUpdateOccupancy, 
                  onChanged: (value){
                    // todo : implement toggle
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
