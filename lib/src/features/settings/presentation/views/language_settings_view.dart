import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/settings/domain/entities/app_settings.dart';
import 'package:mygym/src/features/settings/presentation/cubit/settings_cubit.dart';

class LanguageSettingsView extends StatelessWidget {
  const LanguageSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text(
          "Language",
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final currentLang = state.appSettings.language;
          return Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "choose your language",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16.h),
                _buildLangTile(
                  context: context,
                  language: AppLanguage.english,
                  selected: currentLang == AppLanguage.english,
                ),
                _buildLangTile(
                  context: context, 
                  language: AppLanguage.arabic, 
                  selected: currentLang == AppLanguage.arabic
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLangTile({
    required BuildContext context,
    required AppLanguage language,
    required bool selected,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.borderDark,
        ),
      ),
      child: ListTile(
        title: Text(
          language.displayName,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
        subtitle: Text(
          language.nativeName,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        trailing: selected
            ? Icon(Icons.check_rounded, color: AppColors.primary)
            : null,
        onTap: () async {
          await context.read<SettingsCubit>().changeLanguage(language);
           // todo : هنا فعليًا حفظنا القيمة، تقدر بعدين تربطها بـ EasyLocalization
        },
      ),
    );
  }
}
