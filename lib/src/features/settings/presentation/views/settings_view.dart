import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/cubit/theme_cubit.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/settings/domain/entities/app_settings.dart';

/// Premium Luxury Settings View
///
/// Features:
/// - Animated floating particles with gold accents
/// - Glowing orbs with parallax effect
/// - Premium glassmorphism settings cards
/// - Gold gradient accents and elegant typography
/// - Smooth animations and press effects
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  
  // Animation controllers
  late AnimationController _glowPulseController;
  late AnimationController _particlesController;
  
  // Particles data
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _setSystemUI();
    _initParticles();
    _initAnimations();
    
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  void _setSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  void _initParticles() {
    final random = math.Random();
    _particles = List.generate(10, (index) {
      final isGold = index % 4 == 0;
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 2 + random.nextDouble() * 3,
        speed: 0.07 + random.nextDouble() * 0.15,
        opacity: 0.05 + random.nextDouble() * 0.12,
        isGold: isGold,
      );
    });
  }

  void _initAnimations() {
    _glowPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _glowPulseController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: luxury.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Animated floating particles
            _buildParticles(),
            
            // Glowing orbs with parallax
            _buildGlowingOrbs(),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Custom app bar
                  _buildLuxuryAppBar(),
                  
                  // Settings content
                  Expanded(
                    child: ListView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      children: [
                        _buildAppearanceSection(context),
                        SizedBox(height: 24.h),
                        _buildGeneralSection(context),
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

  Widget _buildParticles() {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return AnimatedBuilder(
      animation: _particlesController,
      builder: (context, child) {
        return CustomPaint(
          size: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
          ),
          painter: _ParticlesPainter(
            particles: _particles,
            progress: _particlesController.value,
            purpleColor: colorScheme.primary,
            goldColor: luxury.gold,
          ),
        );
      },
    );
  }

  Widget _buildGlowingOrbs() {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return AnimatedBuilder(
      animation: _glowPulseController,
      builder: (context, child) {
        final pulseValue = 0.3 + (_glowPulseController.value * 0.2);
        final parallaxOffset = _scrollOffset * 0.2;
        
        return Stack(
          children: [
            // Top right purple glow
            Positioned(
              top: -40.h - parallaxOffset,
              right: -30.w,
              child: Container(
                width: 140.w,
                height: 140.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.12 * pulseValue),
                      colorScheme.primary.withValues(alpha: 0.03 * pulseValue),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Gold accent glow
            Positioned(
              top: 200.h - parallaxOffset * 0.5,
              left: -40.w,
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      luxury.gold.withValues(alpha: 0.08 * pulseValue),
                      luxury.gold.withValues(alpha: 0.02 * pulseValue),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLuxuryAppBar() {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Back button
          _LuxuryIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 16.w),
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
                color: Colors.white,
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
                  colors: [
                    luxury.surfaceElevated,
                    colorScheme.surface,
                  ],
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
                            color: Colors.white,
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
                          gradientColors: [colorScheme.primary, colorScheme.secondary],
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
                          gradientColors: [const Color(0xFFF59E0B), const Color(0xFFFBBF24)],
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
                color: Colors.white,
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
              onTap: () => context.go(RoutePaths.languageSettings),
            ),
            _SettingsItem(
              icon: Icons.notifications_rounded,
              title: "Notifications",
              subtitle: "Manage notification preferences",
              gradientColors: [luxury.gold, luxury.goldLight],
              onTap: () => context.go(RoutePaths.notificationSettings),
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
                color: Colors.white,
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
              gradientColors: [luxury.success, luxury.success.withValues(alpha: 0.7)],
              onTap: () => context.go('${RoutePaths.settings}/support'),
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
              color: Colors.white,
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
            break;
          case AppThemeMode.dark:
            currentThemeText = 'Dark';
            themeIcon = Icons.dark_mode_rounded;
            iconColors = [luxury.gold, luxury.goldLight];
            break;
          case AppThemeMode.system:
          default:
            currentThemeText = 'System';
            themeIcon = Icons.brightness_auto_rounded;
            iconColors = [colorScheme.primary, colorScheme.secondary];
            break;
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

class _AppearanceButton extends StatefulWidget {
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
  State<_AppearanceButton> createState() => _AppearanceButtonState();
}

class _AppearanceButtonState extends State<_AppearanceButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                luxury.surfaceElevated,
                colorScheme.surface,
              ],
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
                color: Colors.black.withValues(alpha: 0.15),
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
                      widget.gradientColors[0].withValues(alpha: 0.2),
                      widget.gradientColors[1].withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: widget.gradientColors[0].withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: widget.gradientColors,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    widget.icon,
                    color: Colors.white,
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
                      widget.title,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.subtitle,
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
                  color: Colors.white,
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

class _ThemeBottomSheetOption extends StatefulWidget {
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
  State<_ThemeBottomSheetOption> createState() => _ThemeBottomSheetOptionState();
}

class _ThemeBottomSheetOptionState extends State<_ThemeBottomSheetOption> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isSelected
                ? [
                    widget.gradientColors[0].withValues(alpha: 0.15),
                    widget.gradientColors[1].withValues(alpha: 0.08),
                  ]
                : [
                    luxury.surfaceElevated.withValues(alpha: 0.5),
                    colorScheme.surface.withValues(alpha: 0.3),
                  ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: widget.isSelected
                ? widget.gradientColors[0].withValues(alpha: 0.4)
                : colorScheme.outline.withValues(alpha: 0.15),
            width: 1.5,
          ),
          boxShadow: widget.isSelected
              ? [
                  BoxShadow(
                    color: widget.gradientColors[0].withValues(alpha: 0.2),
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
                  colors: widget.isSelected
                      ? [
                          widget.gradientColors[0].withValues(alpha: 0.3),
                          widget.gradientColors[1].withValues(alpha: 0.2),
                        ]
                      : [
                          widget.gradientColors[0].withValues(alpha: 0.15),
                          widget.gradientColors[1].withValues(alpha: 0.1),
                        ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: widget.isSelected
                      ? widget.gradientColors[0].withValues(alpha: 0.4)
                      : widget.gradientColors[0].withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: widget.gradientColors,
                  ).createShader(bounds);
                },
                child: Icon(
                  widget.icon,
                  color: Colors.white,
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
                    widget.title,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: widget.isSelected
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.9),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    widget.subtitle,
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: widget.isSelected
                    ? LinearGradient(colors: widget.gradientColors)
                    : null,
                border: widget.isSelected
                    ? null
                    : Border.all(
                        color: colorScheme.outline,
                        width: 2,
                      ),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: widget.gradientColors[0].withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: widget.isSelected
                  ? Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 16.sp,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// LUXURY ICON BUTTON
// ============================================================================

class _LuxuryIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _LuxuryIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_LuxuryIconButton> createState() => _LuxuryIconButtonState();
}

class _LuxuryIconButtonState extends State<_LuxuryIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                luxury.surfaceElevated,
                colorScheme.surface,
              ],
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
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  Colors.white,
                  luxury.gold.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Icon(
              widget.icon,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
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
          colors: [
            luxury.surfaceElevated,
            colorScheme.surface,
          ],
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
            color: Colors.black.withValues(alpha: 0.15),
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

class _SettingsItemTile extends StatefulWidget {
  final _SettingsItem item;

  const _SettingsItemTile({required this.item});

  @override
  State<_SettingsItemTile> createState() => _SettingsItemTileState();
}

class _SettingsItemTileState extends State<_SettingsItemTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.item.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _isPressed
            ? luxury.gold.withValues(alpha: 0.05)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            // Icon container
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.item.gradientColors[0].withValues(alpha: 0.2),
                    widget.item.gradientColors[1].withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: widget.item.gradientColors[0].withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: widget.item.gradientColors,
                  ).createShader(bounds);
                },
                child: Icon(
                  widget.item.icon,
                  color: Colors.white,
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
                    widget.item.title,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    widget.item.subtitle,
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
                color: Colors.white,
                size: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PARTICLE DATA & PAINTER
// ============================================================================

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final bool isGold;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    this.isGold = false,
  });
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color purpleColor;
  final Color goldColor;

  _ParticlesPainter({
    required this.particles,
    required this.progress,
    required this.purpleColor,
    required this.goldColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final animatedY = (particle.y - (progress * particle.speed)) % 1.0;
      final x = particle.x * size.width;
      final y = animatedY * size.height;

      final fadeMultiplier = animatedY < 0.1
          ? animatedY / 0.1
          : animatedY > 0.9
              ? (1.0 - animatedY) / 0.1
              : 1.0;

      final baseColor = particle.isGold ? goldColor : purpleColor;
      paint.color = baseColor.withValues(alpha: particle.opacity * fadeMultiplier);

      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}