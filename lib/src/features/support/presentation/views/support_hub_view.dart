import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';

class SupportHubView extends StatelessWidget {
  const SupportHubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text(
          " Help & Support",
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w), 
        children: [
          _buildTile(
            context,
            icon: Icons.help_outline_rounded,
            title: "FAQ",
            subtitle: "Frequently asked questions",
            onTap: () => context.go('${RoutePaths.settings}/support/faq'),
          ),
          SizedBox(height: 8.h,),
          _buildTile(
            context, 
            icon: Icons.support_agent_rounded, 
            title: "Contact Support", 
            subtitle: "Open a support ticket", 
            onTap: () => context.go('${RoutePaths.settings}/support/tickets'),
            ),
            SizedBox(height: 8.h,),
            _buildTile(
              context, 
              icon: Icons.info_outline_rounded, 
              title: "About", 
              subtitle: 'About the app & legal', 
              onTap: () => context.go('${RoutePaths.settings}/support/about'),
              )
          ]),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderDark)
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary,),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondaryDark,
            fontWeight: FontWeight.bold
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
