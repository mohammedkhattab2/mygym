import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/settings_card.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/settings_row.dart';

class GymInfoSection extends StatelessWidget {
  final PartnerSettings settings;
  const GymInfoSection({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SettingsCard(
      title: 'Gym Information',
      icon: Icons.fitness_center_rounded,
      iconColor: Colors.blue,
      children: [
        SettingsRow(
          icon: Icons.tag_rounded,
          label: 'Gym ID',
          value: settings.gymId,
          onCopy: () {
            Clipboard.setData(ClipboardData(text: settings.gymId));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gym ID copied!')),
            );
          },
        ),
        Divider(height: 24.h, color: colorScheme.outline.withValues(alpha: 0.15),),
        SettingsRow(
          icon: Icons.check_circle_rounded, 
          label: "Status", 
          value: "active Partner",
          valueColor: Colors.green,
          )
      ],
    );
  }
}