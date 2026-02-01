import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/settings_card.dart';
import 'package:mygym/src/features/partner/presentation/widget/setting/support_item.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    return SettingsCard(
      title: "Support", 
      icon: Icons.support_agent_rounded, 
      iconColor: Colors.blue, 
      children: [
        SupportItem(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'Contact Support',
          subtitle: 'Get help with your account',
          color: Colors.blue,
          onTap: () {
            // TODO: Implement contact support
          },
        ),
        SizedBox(height: 10.h,),
        SupportItem(
          icon: Icons.article_outlined, 
          title: "Help Center", 
          subtitle: "Browse FAQs and guides", 
          color: Colors.purple, 
          onTap: () {
            // TODO: Implement help center
          },
          ),
          SizedBox(height: 10.h,),
          SupportItem(
            icon: Icons.feedback_outlined, 
            title: 'Send Feedback', 
            subtitle:'Share your suggestions', 
            color: Colors.orange, 
            onTap: () {
            // TODO: Implement feedback
          },
            )
      ]
      );
  }
}