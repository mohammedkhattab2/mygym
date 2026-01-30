import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/cubit/theme_cubit.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/settings/domain/entities/app_settings.dart';

/// Premium Luxury Settings View
///
/// Features:
/// - Static layered glowing orbs background
/// - Premium glassmorphism settings cards
/// - Gold gradient accents and elegant typography
/// - Full Light/Dark mode compliance
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  void _setSystemUI(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _setSystemUI(context);
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: luxury.backgroundGradient),
        child: Stack(
          children: [
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Custom app bar
                  _buildLuxuryAppBar(),

                  // Settings content
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 8.h,
                      ),
                      children: [
                        _buildAppearanceSection(context),
                        SizedBox(height: 24.h),
                        _buildGeneralSection(context),
                        SizedBox(height: 24.h),
                        _buildSubscriptionSection(context),
                        SizedBox(height: 24.h),
                        _buildSupportSection(context),
                        SizedBox(height: 24.h),
                        _buildAboutSection(context),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLuxuryAppBar() {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Back button - only show if we can navigate back
          if (context.canPop()) ...[
            _LuxuryIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => context.pop(),
            ),
            SizedBox(width: 16.w),
          ],
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PREFERENCES',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Settings',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [luxury.gold, luxury.goldLight],
                ).createShader(bounds);
              },
              child: Icon(
                Icons.palette_rounded,
                color: colorScheme.onPrimary,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "Display",
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _AppearanceSettingsCard(
          onAppearanceTap: () => _showThemeBottomSheet(context),
        ),
      ],
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          bloc: context.read<ThemeCubit>(),
          builder: (_, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [luxury.surfaceElevated, colorScheme.surface],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                border: Border.all(
                  color: luxury.gold.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    margin: EdgeInsets.only(top: 12.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [luxury.gold, luxury.goldLight],
                            ).createShader(bounds);
                          },
                          child: Icon(
                            Icons.palette_rounded,
                            color: colorScheme.onPrimary,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Appearance',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Text(
                      'Choose how MyGym looks to you',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: luxury.textTertiary,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Theme options
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        _ThemeBottomSheetOption(
                          icon: Icons.brightness_auto_rounded,
                          title: 'System Default',
                          subtitle: 'Automatically match device theme',
                          isSelected: state.themeMode == AppThemeMode.system,
                          gradientColors: [
                            colorScheme.primary,
                            colorScheme.secondary,
                          ],
                          onTap: () {
                            context.read<ThemeCubit>().setSystemTheme();
                            Navigator.pop(bottomSheetContext);
                          },
                        ),
                        SizedBox(height: 10.h),
                        _ThemeBottomSheetOption(
                          icon: Icons.light_mode_rounded,
                          title: 'Light Mode',
                          subtitle: 'Clean and bright appearance',
                          isSelected: state.themeMode == AppThemeMode.light,
                          gradientColors: [
                            const Color(0xFFF59E0B),
                            const Color(0xFFFBBF24),
                          ],
                          onTap: () {
                            context.read<ThemeCubit>().setLightTheme();
                            Navigator.pop(bottomSheetContext);
                          },
                        ),
                        SizedBox(height: 10.h),
                        _ThemeBottomSheetOption(
                          icon: Icons.dark_mode_rounded,
                          title: 'Dark Mode',
                          subtitle: 'Premium dark experience',
                          isSelected: state.themeMode == AppThemeMode.dark,
                          gradientColors: [luxury.gold, luxury.goldLight],
                          onTap: () {
                            context.read<ThemeCubit>().setDarkTheme();
                            Navigator.pop(bottomSheetContext);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Safe area padding
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGeneralSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [luxury.gold, luxury.goldLight],
                ).createShader(bounds);
              },
              child: Icon(
                Icons.tune_rounded,
                color: colorScheme.onPrimary,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "General",
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _LuxurySettingsCard(
          items: [
            _SettingsItem(
              icon: Icons.language_rounded,
              title: "Language",
              subtitle: "Change app language",
              gradientColors: [colorScheme.primary, colorScheme.secondary],
              onTap: () => context.push(RoutePaths.languageSettings),
            ),
            _SettingsItem(
              icon: Icons.notifications_rounded,
              title: "Notifications",
              subtitle: "Manage notification preferences",
              gradientColors: [luxury.gold, luxury.goldLight],
              onTap: () => context.push(RoutePaths.notificationSettings),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [luxury.gold, luxury.goldLight],
                ).createShader(bounds);
              },
              child: Icon(
                Icons.support_agent_rounded,
                color: colorScheme.onPrimary,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "Support",
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _LuxurySettingsCard(
          items: [
            _SettingsItem(
              icon: Icons.help_outline_rounded,
              title: "Help & Support",
              subtitle: "FAQ, contact support, about app",
              gradientColors: [
                luxury.success,
                luxury.success.withValues(alpha: 0.7),
              ],
              onTap: () => context.push('${RoutePaths.settings}/support'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.surfaceElevated.withValues(alpha: 0.6),
            colorScheme.surface.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [colorScheme.primary, luxury.gold],
              ).createShader(bounds);
            },
            child: Icon(
              Icons.fitness_center_rounded,
              color: colorScheme.onPrimary,
              size: 32.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'MyGym',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Version 1.0.0',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: luxury.textTertiary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Premium Fitness Experience',
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: luxury.gold.withValues(alpha: 0.7),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildSubscriptionSection(BuildContext context) {
    final colorSchame = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShaderMask(
              shaderCallback: (bound) {
                return LinearGradient(
                  colors: [luxury.gold, luxury.goldLight],
                  ).createShader(bound);
              },
              child: Icon(
                Icons.workspace_premium_rounded,
                color: colorSchame.onPrimary,
                size: 15.sp,
              ),
            ),
            SizedBox(width: 8.w,),
            Text(
              "Subscription",
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: colorSchame.onSurface,
                letterSpacing: 0.5,
              ),
            )
          ],
        ),
        SizedBox(height: 12.h,),
        _LuxurySettingsCard(
          items: [
            _SettingsItem(
              icon: Icons.card_membership_rounded,
              title: "Subscription Plans",
              subtitle: "View and manage your subscription",
              gradientColors: [ luxury.gold, luxury.goldLight],
              onTap: () => context.push('/member/subscriptions/bundles'),
            ),
            _SettingsItem(
              icon: Icons.receipt_long_rounded,
              title: "Billing & Invoices",
              subtitle: "View payment history and invoices",
              gradientColors: [ colorSchame.tertiary, colorSchame.secondary],
              onTap: () => context.push('/member/subscriptions/invoices'),
            )
          ],
        )
      ],
    );
  }
}

// ============================================================================
// APPEARANCE SETTINGS CARD (Button to open bottom sheet)
// ============================================================================

class _AppearanceSettingsCard extends StatelessWidget {
  final VoidCallback onAppearanceTap;

  const _AppearanceSettingsCard({required this.onAppearanceTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        // Get current theme display text
        String currentThemeText;
        IconData themeIcon;
        List<Color> iconColors;

        switch (state.themeMode) {
          case AppThemeMode.light:
            currentThemeText = 'Light';
            themeIcon = Icons.light_mode_rounded;
            iconColors = [const Color(0xFFF59E0B), const Color(0xFFFBBF24)];
          case AppThemeMode.dark:
            currentThemeText = 'Dark';
            themeIcon = Icons.dark_mode_rounded;
            iconColors = [luxury.gold, luxury.goldLight];
          case AppThemeMode.system:
            currentThemeText = 'System';
            themeIcon = Icons.brightness_auto_rounded;
            iconColors = [colorScheme.primary, colorScheme.secondary];
        }

        return _AppearanceButton(
          icon: themeIcon,
          title: 'Appearance',
          subtitle: currentThemeText,
          gradientColors: iconColors,
          onTap: onAppearanceTap,
        );
      },
    );
  }
}

class _AppearanceButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _AppearanceButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        splashColor: luxury.gold.withValues(alpha: 0.08),
        highlightColor: luxury.gold.withValues(alpha: 0.04),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [luxury.surfaceElevated, colorScheme.surface],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: luxury.gold.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              // Icon container
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      gradientColors[0].withValues(alpha: 0.2),
                      gradientColors[1].withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: gradientColors[0].withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: gradientColors,
                    ).createShader(bounds);
                  },
                  child: Icon(icon, color: colorScheme.onPrimary, size: 20.sp),
                ),
              ),
              SizedBox(width: 14.w),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: luxury.gold,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      luxury.textTertiary,
                      luxury.gold.withValues(alpha: 0.5),
                    ],
                  ).createShader(bounds);
                },
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: colorScheme.onPrimary,
                  size: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// THEME BOTTOM SHEET OPTION
// ============================================================================

class _ThemeBottomSheetOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _ThemeBottomSheetOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        splashColor: gradientColors[0].withValues(alpha: 0.1),
        highlightColor: gradientColors[0].withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSelected
                  ? [
                      gradientColors[0].withValues(alpha: 0.15),
                      gradientColors[1].withValues(alpha: 0.08),
                    ]
                  : [
                      luxury.surfaceElevated.withValues(alpha: 0.5),
                      colorScheme.surface.withValues(alpha: 0.3),
                    ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? gradientColors[0].withValues(alpha: 0.4)
                  : colorScheme.outline.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: gradientColors[0].withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              // Icon container
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSelected
                        ? [
                            gradientColors[0].withValues(alpha: 0.3),
                            gradientColors[1].withValues(alpha: 0.2),
                          ]
                        : [
                            gradientColors[0].withValues(alpha: 0.15),
                            gradientColors[1].withValues(alpha: 0.1),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? gradientColors[0].withValues(alpha: 0.4)
                        : gradientColors[0].withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: gradientColors,
                    ).createShader(bounds);
                  },
                  child: Icon(icon, color: colorScheme.onPrimary, size: 20.sp),
                ),
              ),
              SizedBox(width: 14.w),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: isSelected
                            ? colorScheme.onSurface
                            : colorScheme.onSurface.withValues(alpha: 0.9),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: luxury.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // Selection indicator
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSelected
                      ? LinearGradient(colors: gradientColors)
                      : null,
                  border: isSelected
                      ? null
                      : Border.all(color: colorScheme.outline, width: 2),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: gradientColors[0].withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        color: colorScheme.onPrimary,
                        size: 16.sp,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LUXURY ICON BUTTON
// ============================================================================

class _LuxuryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _LuxuryIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [luxury.surfaceElevated, colorScheme.surface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: luxury.gold.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                colorScheme.onSurface,
                luxury.gold.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Icon(icon, color: colorScheme.onPrimary, size: 20.sp),
        ),
      ),
    );
  }
}

// ============================================================================
// LUXURY SETTINGS CARD
// ============================================================================

class _LuxurySettingsCard extends StatelessWidget {
  final List<_SettingsItem> items;

  const _LuxurySettingsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [luxury.surfaceElevated, colorScheme.surface],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: luxury.gold.withValues(alpha: 0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _SettingsItemTile(item: item),
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  indent: 70.w,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.onTap,
  });
}

class _SettingsItemTile extends StatelessWidget {
  final _SettingsItem item;

  const _SettingsItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        splashColor: luxury.gold.withValues(alpha: 0.08),
        highlightColor: luxury.gold.withValues(alpha: 0.04),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              // Icon container
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      item.gradientColors[0].withValues(alpha: 0.2),
                      item.gradientColors[1].withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: item.gradientColors[0].withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: item.gradientColors,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    item.icon,
                    color: colorScheme.onPrimary,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 14.w),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: luxury.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      luxury.textTertiary,
                      luxury.gold.withValues(alpha: 0.5),
                    ],
                  ).createShader(bounds);
                },
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: colorScheme.onPrimary,
                  size: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
