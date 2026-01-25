import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_theme.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/home/presentation/widget/build_bannar.dart';
import 'package:mygym/src/features/home/presentation/widget/build_header.dart';
import 'package:mygym/src/features/home/presentation/widget/build_nearby_gyms.dart';
import 'package:mygym/src/features/home/presentation/widget/build_popular_classes.dart';
import 'package:mygym/src/features/home/presentation/widget/build_search_bar.dart';

/// Premium Luxury Home View
///
/// Features:
/// - Animated floating particles with gold accents
/// - Multiple layered glowing orbs
/// - Immersive hero banner section
/// - Premium glassmorphism cards
/// - Elegant typography with Google Fonts
/// - Smooth scroll animations
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  final String _userName = "Ahmed";
  int _currentNavIndex = 0;
  
  // Animation controllers
  late AnimationController _glowPulseController;
  late AnimationController _particlesController;
  
  // Particles data
  late List<_Particle> _particles;
  
  // Scroll controller for parallax effects
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _setSystemUI();
    _initParticles();
    _initAnimations();
    _scrollController.addListener(_onScroll);
  }

  void _setSystemUI() {
    // System UI is now managed by the app.dart based on theme
  }

  void _initParticles() {
    final random = math.Random();
    _particles = List.generate(18, (index) {
      final isGold = index % 4 == 0;
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 2 + random.nextDouble() * 3,
        speed: 0.08 + random.nextDouble() * 0.2,
        opacity: 0.08 + random.nextDouble() * 0.25,
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
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _glowPulseController.dispose();
    _particlesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });
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
            
            // Glowing orbs with parallax effect
            _buildGlowingOrbs(),
            
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildHeader(userName: _userName),
                    SizedBox(height: 16.h),
                    const BuildSearchBar(),
                    SizedBox(height: 24.h),
                    const BuildBannar(),
                    SizedBox(height: 28.h),
                    const BuildNearbyGyms(),
                    SizedBox(height: 28.h),
                    const BuildPopularClasses(),
                    SizedBox(height: 32.h),
                  ],
                ),
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
        final pulseValue = 0.3 + (_glowPulseController.value * 0.25);
        // Apply parallax based on scroll offset
        final parallaxOffset = _scrollOffset * 0.3;
        
        return Stack(
          children: [
            // Top right purple glow with parallax
            Positioned(
              top: -80.h - parallaxOffset * 0.5,
              right: -50.w,
              child: Container(
                width: 220.w,
                height: 220.w,
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
            // Top left gold glow
            Positioned(
              top: -30.h - parallaxOffset * 0.3,
              left: -40.w,
              child: Container(
                width: 140.w,
                height: 140.w,
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
            // Middle section glow (behind banner)
            Positioned(
              top: 200.h - parallaxOffset * 0.2,
              left: MediaQuery.of(context).size.width * 0.2,
              child: Container(
                width: 250.w,
                height: 250.w,
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

