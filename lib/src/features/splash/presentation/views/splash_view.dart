import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/luxury_theme_extension.dart';

/// Luxury Premium Splash Screen for MyGym
///
/// Features:
/// - Animated floating particles with gold accents
/// - Multiple layered glowing orbs with purple/gold gradient
/// - Logo with elegant scale animation and magical glow
/// - Gold shimmer effect on app name
/// - Elegant serif tagline
/// - Premium animated loading indicator
/// - Auto-navigation after 3.5 seconds
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _taglineController;
  late AnimationController _dotsController;
  late AnimationController _glowPulseController;
  late AnimationController _particlesController;
  late AnimationController _shimmerController;

  // Logo animations
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoGlowAnimation;

  // Text animations
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  // Tagline animations
  late Animation<double> _taglineFadeAnimation;

  // Particles data
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    _setSystemUI();
    _initParticles();
    _initAnimations();
    _startAnimations();
    _navigateAfterDelay();
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
    _particles = List.generate(30, (index) {
      // Mix of purple and gold particles
      final isGold = index % 5 == 0;
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 2 + random.nextDouble() * 5,
        speed: 0.15 + random.nextDouble() * 0.4,
        opacity: 0.1 + random.nextDouble() * 0.4,
        isGold: isGold,
      );
    });
  }

  void _initAnimations() {
    // Logo animation controller (0ms - 600ms)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOut,
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    // Glow pulse animation (continuous)
    _glowPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _logoGlowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(
        parent: _glowPulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Text animation controller (400ms - 1000ms)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Tagline animation
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _taglineController,
        curve: Curves.easeOut,
      ),
    );

    // Shimmer animation (continuous)
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // Dots animation controller (800ms+)
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Particles animation (continuous)
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  void _startAnimations() {
    // Logo appears immediately (0ms - 600ms)
    _logoController.forward();

    // Text appears after logo (400ms - 1000ms)
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _textController.forward();
      }
    });

    // Tagline appears after text (700ms)
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        _taglineController.forward();
      }
    });
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _taglineController.dispose();
    _dotsController.dispose();
    _glowPulseController.dispose();
    _particlesController.dispose();
    _shimmerController.dispose();
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
            // Animated floating particles (gold & purple)
            _buildParticles(),

            // Multiple layered glowing orbs
            _buildGlowingCircles(),
            
            // Subtle radial gradient overlay
            _buildRadialOverlay(),

            // Main centered content - perfectly centered vertically and horizontally
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo with magical glow
                    _buildAnimatedLogo(),

                    SizedBox(height: 48.h),

                    // App name with gold shimmer
                    _buildAppName(),

                    SizedBox(height: 16.h),

                    // Elegant serif tagline
                    _buildTagline(),
                  ],
                ),
              ),
            ),
            
            // Premium loading indicator - positioned at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: _buildLoadingIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRadialOverlay() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.3),
            radius: 1.2,
            colors: [
              colorScheme.primary.withValues(alpha: 0.08),
              Colors.transparent,
            ],
          ),
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

  Widget _buildGlowingCircles() {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return AnimatedBuilder(
      animation: _glowPulseController,
      builder: (context, child) {
        final pulseValue = _logoGlowAnimation.value;
        return Stack(
          children: [
            // Top right purple glow
            Positioned(
              top: -120.h,
              right: -100.w,
              child: Container(
                width: 300.w,
                height: 300.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.2 * pulseValue),
                      colorScheme.primary.withValues(alpha: 0.08 * pulseValue),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Top left gold accent glow
            Positioned(
              top: -60.h,
              left: -80.w,
              child: Container(
                width: 180.w,
                height: 180.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      luxury.gold.withValues(alpha: 0.12 * pulseValue),
                      luxury.gold.withValues(alpha: 0.04 * pulseValue),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Center glow (behind logo) - main magical effect
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 350.w,
                  height: 350.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.3 * pulseValue),
                        colorScheme.secondary.withValues(alpha: 0.15 * pulseValue),
                        luxury.gold.withValues(alpha: 0.05 * pulseValue),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 0.6, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom gold accent glow
            Positioned(
              bottom: -80.h,
              left: MediaQuery.of(context).size.width * 0.3,
              child: Container(
                width: 220.w,
                height: 220.w,
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
            // Bottom left purple glow
            Positioned(
              bottom: -50.h,
              left: -70.w,
              child: Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.secondary.withValues(alpha: 0.12 * pulseValue),
                      colorScheme.secondary.withValues(alpha: 0.04 * pulseValue),
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

  Widget _buildAnimatedLogo() {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _glowPulseController]),
      builder: (context, child) {
        final glowOpacity = _logoGlowAnimation.value;
        return FadeTransition(
          opacity: _logoFadeAnimation,
          child: ScaleTransition(
            scale: _logoScaleAnimation,
            child: Container(
              width: 130.w,
              height: 130.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                    colorScheme.secondary,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(36.r),
                border: Border.all(
                  color: luxury.gold.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  // Primary glow
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: glowOpacity),
                    blurRadius: 50,
                    spreadRadius: 8,
                  ),
                  // Gold accent glow
                  BoxShadow(
                    color: luxury.gold.withValues(alpha: glowOpacity * 0.3),
                    blurRadius: 60,
                    spreadRadius: 5,
                  ),
                  // Outer purple glow
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: glowOpacity * 0.4),
                    blurRadius: 100,
                    spreadRadius: 25,
                  ),
                  // Deep ambient glow
                  BoxShadow(
                    color: colorScheme.secondary.withValues(alpha: glowOpacity * 0.25),
                    blurRadius: 150,
                    spreadRadius: 50,
                  ),
                ],
              ),
              child: Center(
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        Colors.white,
                        luxury.goldLight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.fitness_center_rounded,
                    size: 60.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppName() {
    return AnimatedBuilder(
      animation: Listenable.merge([_textController, _shimmerController]),
      builder: (context, child) {
        return FadeTransition(
          opacity: _textFadeAnimation,
          child: SlideTransition(
            position: _textSlideAnimation,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: const [
                    Color(0xFF8B5CF6),
                    Colors.white,
                    Color(0xFF8B5CF6),
                  ],
                  stops: [
                    _shimmerController.value - 0.3,
                    _shimmerController.value,
                    _shimmerController.value + 0.3,
                  ].map((s) => s.clamp(0.0, 1.0)).toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Text(
                'MyGym',
                style: TextStyle(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagline() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return AnimatedBuilder(
      animation: _taglineController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _taglineFadeAnimation,
          child: Text(
            'Elevate Your Fitness Experience',
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              letterSpacing: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        return Column(
          children: [
            // Elegant loading bar
            Container(
              width: 120.w,
              height: 3.h,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 120.w * _dotsController.value,
                    height: 3.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          luxury.gold,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(2.r),
                      boxShadow: [
                        BoxShadow(
                          color: luxury.primaryGlow,
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // Loading text
            Text(
              'LOADING',
              style: GoogleFonts.montserrat(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: luxury.textTertiary,
                letterSpacing: 3,
              ),
            ),
          ],
        );
      },
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
      // Calculate animated position (floating upward)
      final animatedY = (particle.y - (progress * particle.speed)) % 1.0;
      final x = particle.x * size.width;
      final y = animatedY * size.height;

      // Fade in/out based on vertical position
      final fadeMultiplier = animatedY < 0.1
          ? animatedY / 0.1
          : animatedY > 0.9
              ? (1.0 - animatedY) / 0.1
              : 1.0;

      // Use gold or purple color based on particle type
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