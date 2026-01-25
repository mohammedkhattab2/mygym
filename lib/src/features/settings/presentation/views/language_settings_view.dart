import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/settings/domain/entities/app_settings.dart';
import 'package:mygym/src/features/settings/presentation/cubit/settings_cubit.dart';

class LanguageSettingsView extends StatelessWidget {
  const LanguageSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Language",
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
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
                  "Choose your language",
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16.h),
                _LanguageTile(
                  language: AppLanguage.english,
                  selected: currentLang == AppLanguage.english,
                ),
                _LanguageTile(
                  language: AppLanguage.arabic,
                  selected: currentLang == AppLanguage.arabic,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final AppLanguage language;
  final bool selected;

  const _LanguageTile({
    required this.language,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: selected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        title: Text(
          language.displayName,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          language.nativeName,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: selected
            ? Icon(Icons.check_rounded, color: colorScheme.primary)
            : null,
        onTap: () async {
          await context.read<SettingsCubit>().changeLanguage(language);
        },
      ),
    );
  }
}
