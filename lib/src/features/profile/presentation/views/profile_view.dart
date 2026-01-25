import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/auth/domain/entities/user.dart';
import 'package:mygym/src/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mygym/src/features/auth/presentation/bloc/auth_state.dart';

/// Premium Luxury Profile View
///
/// Features:
/// - Animated floating particles with gold accents
/// - Glowing orbs with parallax effect
/// - Premium glassmorphism profile card
/// - Gold gradient accents and elegant typography
/// - Smooth animations and press effects
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
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
    final isDark = context.isDarkMode;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  void _initParticles() {
    final random = math.Random();
    _particles = List.generate(12, (index) {
      final isGold = index % 4 == 0;
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 2 + random.nextDouble() * 3,
        speed: 0.08 + random.nextDouble() * 0.18,
        opacity: 0.06 + random.nextDouble() * 0.15,
        isGold: isGold,
      );
    });
  }

  void _initAnimations() {
    _glowPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
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
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withValues(alpha: 0.95),
              luxury.surfaceElevated,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated floating particles
            _buildParticles(colorScheme, luxury),
            
            // Glowing orbs with parallax
            _buildGlowingOrbs(colorScheme, luxury),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Custom app bar
                  _buildLuxuryAppBar(colorScheme, luxury),
                  
                  // Profile content
                  Expanded(
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state.status == AuthStatus.loading) {
                          return _buildLoadingState(colorScheme, luxury);
                        }
                        if (state.status == AuthStatus.unauthenticated) {
                          return _buildUnauthenticated(context, colorScheme, luxury);
                        }
                        if (state.hasError) {
                          return _buildError(context, colorScheme, state.errorMessage);
                        }
                        final user = state.user;
                        if (user == null) {
                          return _buildError(context, colorScheme, "User data not available");
                        }
                        return _buildContent(context, user, colorScheme, luxury);
                      },
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

  Widget _buildParticles(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
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

  Widget _buildGlowingOrbs(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return AnimatedBuilder(
      animation: _glowPulseController,
      builder: (context, child) {
        final pulseValue = 0.35 + (_glowPulseController.value * 0.25);
        final parallaxOffset = _scrollOffset * 0.25;
        
        return Stack(
          children: [
            // Top right purple glow
            Positioned(
              top: -50.h - parallaxOffset,
              right: -40.w,
              child: Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.15 * pulseValue),
                      colorScheme.primary.withValues(alpha: 0.04 * pulseValue),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Gold accent glow
            Positioned(
              top: 150.h - parallaxOffset * 0.5,
              left: -50.w,
              child: Container(
                width: 130.w,
                height: 130.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      luxury.gold.withValues(alpha: 0.1 * pulseValue),
                      luxury.gold.withValues(alpha: 0.03 * pulseValue),
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

  Widget _buildLuxuryAppBar(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
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
                  'MY PROFILE',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Account',
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

  Widget _buildLoadingState(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(luxury.gold),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading profile...',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnauthenticated(BuildContext context, ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
              Icons.person_off_rounded,
              color: Colors.white,
              size: 48.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "You are not logged in",
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, ColorScheme colorScheme, String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.sp,
            color: colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(
            message ?? "Failed to load profile details",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, User user, ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHeader(user: user),
          SizedBox(height: 24.h),
          _SubscriptionCard(user: user),
          SizedBox(height: 24.h),
          _ActivitySection(),
          SizedBox(height: 24.h),
          _AccountSection(),
          SizedBox(height: 32.h),
          _LuxuryLogoutButton(
            onTap: () => context.read<AuthCubit>().signOut(),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

// ============================================================================
// PROFILE HEADER
// ============================================================================

class _ProfileHeader extends StatelessWidget {
  final User user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final displayName = user.displayName ?? user.email.split('@').first;
    final initial = (displayName.isNotEmpty ? displayName[0] : "U").toUpperCase();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.surfaceElevated,
            colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with gradient
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.25),
                  luxury.gold.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: luxury.gold.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      colorScheme.primary,
                      luxury.gold,
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  initial,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 18.w),
          
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  user.email,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (user.selectedCity != null) ...[
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 14.sp,
                        color: luxury.gold.withValues(alpha: 0.7),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        user.selectedCity!,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: luxury.gold.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SUBSCRIPTION CARD
// ============================================================================

class _SubscriptionCard extends StatelessWidget {
  final User user;

  const _SubscriptionCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.15),
            luxury.gold.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
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
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                "Subscription",
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            user.subscriptionStatus ?? "No active subscription",
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          if (user.remainingVisits != null || user.points > 0) ...[
            SizedBox(height: 14.h),
            Row(
              children: [
                if (user.remainingVisits != null)
                  _StatChip(
                    icon: Icons.confirmation_number_rounded,
                    label: '${user.remainingVisits} Visits',
                    colors: [colorScheme.primary, colorScheme.secondary],
                  ),
                if (user.remainingVisits != null && user.points > 0)
                  SizedBox(width: 12.w),
                if (user.points > 0)
                  _StatChip(
                    icon: Icons.stars_rounded,
                    label: '${user.points} Points',
                    colors: [luxury.gold, luxury.goldLight],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> colors;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors[0].withValues(alpha: 0.2),
            colors[1].withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: colors[0].withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(colors: colors).createShader(bounds);
            },
            child: Icon(
              icon,
              color: Colors.white,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: colors[0],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ACTIVITY SECTION
// ============================================================================

class _ActivitySection extends StatelessWidget {
  const _ActivitySection();

  @override
  Widget build(BuildContext context) {
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
                Icons.timeline_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "My Activity",
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
        _LuxuryMenuCard(
          items: [
            _LuxuryMenuItem(
              icon: Icons.history_rounded,
              title: "Visit History",
              subtitle: "See your previous check-ins",
              gradientColors: [colorScheme.primary, colorScheme.secondary],
              onTap: () => context.go(RoutePaths.history),
            ),
            _LuxuryMenuItem(
              icon: Icons.card_giftcard_rounded,
              title: "Rewards & Points",
              subtitle: "View your rewards and referral code",
              gradientColors: [luxury.gold, luxury.goldLight],
              onTap: () => context.go(RoutePaths.rewardsList),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// ACCOUNT SECTION
// ============================================================================

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context) {
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
                Icons.person_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "Account",
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
        _LuxuryMenuCard(
          items: [
            _LuxuryMenuItem(
              icon: Icons.edit_rounded,
              title: "Edit Profile",
              subtitle: "Update your personal information",
              gradientColors: [colorScheme.primary, luxury.gold],
              onTap: () => context.go(RoutePaths.profileEdit),
            ),
            _LuxuryMenuItem(
              icon: Icons.settings_rounded,
              title: "Settings",
              subtitle: "App preferences and configuration",
              gradientColors: [colorScheme.secondary, colorScheme.primary],
              onTap: () => context.go(RoutePaths.settings),
            ),
          ],
        ),
      ],
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
// LUXURY MENU CARD
// ============================================================================

class _LuxuryMenuCard extends StatelessWidget {
  final List<_LuxuryMenuItem> items;

  const _LuxuryMenuCard({required this.items});

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
              _LuxuryMenuItemTile(item: item),
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  indent: 70.w,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _LuxuryMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  _LuxuryMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.onTap,
  });
}

class _LuxuryMenuItemTile extends StatefulWidget {
  final _LuxuryMenuItem item;

  const _LuxuryMenuItemTile({required this.item});

  @override
  State<_LuxuryMenuItemTile> createState() => _LuxuryMenuItemTileState();
}

class _LuxuryMenuItemTileState extends State<_LuxuryMenuItemTile> {
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
// LUXURY LOGOUT BUTTON
// ============================================================================

class _LuxuryLogoutButton extends StatefulWidget {
  final VoidCallback onTap;

  const _LuxuryLogoutButton({required this.onTap});

  @override
  State<_LuxuryLogoutButton> createState() => _LuxuryLogoutButtonState();
}

class _LuxuryLogoutButtonState extends State<_LuxuryLogoutButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: GestureDetector(
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
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.error.withValues(alpha: 0.15),
                  colorScheme.error.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: colorScheme.error.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: colorScheme.error,
                  size: 18.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  "Sign Out",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
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
