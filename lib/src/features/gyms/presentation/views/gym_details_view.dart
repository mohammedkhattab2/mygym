import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';
import 'package:mygym/src/features/gyms/presentation/bloc/gyms_bloc.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_about_section.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_bottom_button.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_contact_info.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_facilities.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_reviews_section.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_status_and_crowd.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_title_section.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_working_hours.dart';

/// Premium Luxury Gym Details View
///
/// Features:
/// - Animated floating particles with gold accents
/// - Multiple layered glowing orbs
/// - Premium hero header with gradient overlay
/// - Elegant typography with Google Fonts
/// - Gold gradient accents
/// - Smooth parallax scrolling effect
class GymDetailsView extends StatefulWidget {
  final String gymId;
  const GymDetailsView({super.key, required this.gymId});

  @override
  State<GymDetailsView> createState() => _GymDetailsViewState();
}

class _GymDetailsViewState extends State<GymDetailsView>
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
    _particles = List.generate(20, (index) {
      final isGold = index % 3 == 0;
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 2 + random.nextDouble() * 4,
        speed: 0.1 + random.nextDouble() * 0.25,
        opacity: 0.06 + random.nextDouble() * 0.18,
        isGold: isGold,
      );
    });
  }

  void _initAnimations() {
    _glowPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
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
    final isDark = context.isDarkMode;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );

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
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated floating particles
            _buildParticles(colorScheme, luxury),
            
            // Glowing orbs with parallax
            _buildGlowingOrbs(colorScheme, luxury),
            
            // Main content
            BlocBuilder<GymsBloc, GymsState>(
              builder: (context, state) {
                final detailStatus = state.detailStatus;
                final gym = state.selectedGym;

                if (detailStatus == GymsStatus.loading || gym == null) {
                  return _buildLoadingState(colorScheme, luxury);
                }
                if (detailStatus == GymsStatus.failure) {
                  return _buildError(colorScheme, state.errorMessage);
                }
                final isFavorite = state.favoriteIds.contains(gym.id);

                return Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          // Premium hero header
                          _buildSliverHeader(context, gym, isFavorite, colorScheme, luxury),
                          
                          // Content sections
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20.h),
                                  BuildTitleSection(gym: gym),
                                  SizedBox(height: 20.h),
                                  BuildStatusAndCrowd(gym: gym),
                                  SizedBox(height: 20.h),
                                  BuildFacilities(gym: gym),
                                  SizedBox(height: 28.h),
                                  BuildAboutSection(gym: gym),
                                  SizedBox(height: 28.h),
                                  BuildWorkingHours(gym: gym),
                                  SizedBox(height: 28.h),
                                  BuildContactInfo(gym: gym),
                                  SizedBox(height: 28.h),
                                  BuildReviewsSection(context: context, state: state),
                                  SizedBox(height: 100.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bottom action button
                    BuildBottomButton(context: context, gym: gym),
                  ],
                );
              },
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
        final pulseValue = 0.4 + (_glowPulseController.value * 0.3);
        final parallaxOffset = _scrollOffset * 0.3;
        
        return Stack(
          children: [
            // Top right purple glow with parallax
            Positioned(
              top: -80.h - parallaxOffset,
              right: -50.w,
              child: Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.18 * pulseValue),
                      colorScheme.primary.withValues(alpha: 0.05 * pulseValue),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Gold accent glow
            Positioned(
              top: 100.h - parallaxOffset * 0.5,
              left: -60.w,
              child: Container(
                width: 150.w,
                height: 150.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      luxury.gold.withValues(alpha: 0.12 * pulseValue),
                      luxury.gold.withValues(alpha: 0.03 * pulseValue),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Secondary violet glow
            Positioned(
              top: 300.h - parallaxOffset * 0.2,
              right: -30.w,
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.secondary.withValues(alpha: 0.08 * pulseValue),
                      colorScheme.secondary.withValues(alpha: 0.02 * pulseValue),
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

  Widget _buildSliverHeader(BuildContext context, Gym gym, bool isFavorite, ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    final heroLetter = gym.name.isNotEmpty ? gym.name[0].toUpperCase() : "G";
    
    return SliverAppBar(
      expandedHeight: 260.h,
      pinned: true,
      stretch: true,
      backgroundColor: colorScheme.surface,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Hero gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.35),
                    colorScheme.secondary.withValues(alpha: 0.25),
                    luxury.gold.withValues(alpha: 0.15),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Decorative pattern overlay
            Positioned.fill(
              child: CustomPaint(
                painter: _HeroPatternPainter(
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
            // Large hero letter
            Center(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.08),
                      luxury.gold.withValues(alpha: 0.12),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  heroLetter,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 120.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Bottom gradient fade
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      colorScheme.surface.withValues(alpha: 0.6),
                      colorScheme.surface,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // Custom app bar content
      title: AnimatedOpacity(
        opacity: _scrollOffset > 150 ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          gym.name,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: _LuxuryCircleButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: _LuxuryCircleButton(
            icon: isFavorite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            iconColor: isFavorite ? Colors.red : Colors.white,
            onTap: () {
              context.read<GymsBloc>().add(
                GymsEvent.toggleFavorite(gym.id),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50.w,
            height: 50.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(luxury.gold),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading gym details...',
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

  Widget _buildError(ColorScheme colorScheme, String? message) {
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
            message ?? "Failed to load gym details",
            style: TextStyle(
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
}

// ============================================================================
// LUXURY CIRCLE BUTTON
// ============================================================================

class _LuxuryCircleButton extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _LuxuryCircleButton({
    required this.icon,
    this.iconColor = Colors.white,
    required this.onTap,
  });

  @override
  State<_LuxuryCircleButton> createState() => _LuxuryCircleButtonState();
}

class _LuxuryCircleButtonState extends State<_LuxuryCircleButton> {
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
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                luxury.surfaceElevated.withValues(alpha: 0.9),
                colorScheme.surface.withValues(alpha: 0.8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border.all(
              color: luxury.gold.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              widget.icon,
              color: widget.iconColor,
              size: 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HERO PATTERN PAINTER
// ============================================================================

class _HeroPatternPainter extends CustomPainter {
  final Color color;

  _HeroPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    
    // Draw diagonal lines
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
