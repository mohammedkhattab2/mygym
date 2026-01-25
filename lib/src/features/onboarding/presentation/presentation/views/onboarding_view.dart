import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/luxury_theme_extension.dart';

/// Premium Luxury Onboarding View with animated slides
///
/// Features:
/// - Animated floating particles with gold accents
/// - Multiple layered glowing orbs
/// - Premium typography with Google Fonts
/// - Elegant page indicators with gold shimmer
/// - Luxurious gradient buttons
/// - Smooth page transitions
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _backgroundController;
  late final AnimationController _contentController;
  late final AnimationController _particlesController;
  late final AnimationController _glowPulseController;
  
  // Particles data
  late List<_Particle> _particles;
  
  int _currentPage = 0;

  static const List<_OnboardingSlideData> _slides = [
    _OnboardingSlideData(
      title: 'Discover Premium Gyms',
      subtitle: 'Your Fitness Journey Begins',
      description:
          'Find and explore 200+ premium gyms near you with real-time availability and crowd insights',
      accentColor: Color(0xFF9333EA), // Royal Purple
      secondaryColor: Color(0xFFD4AF37), // Gold
      iconType: _IconType.location,
    ),
    _OnboardingSlideData(
      title: 'One Pass, All Access',
      subtitle: 'Unlimited Flexibility',
      description:
          'Single membership unlocks all partner gyms. No contracts, pure flexibility and freedom',
      accentColor: Color(0xFF6366F1), // Deep Violet
      secondaryColor: Color(0xFFE8A0BF), // Rose Gold
      iconType: _IconType.card,
    ),
    _OnboardingSlideData(
      title: 'Instant Check-in',
      subtitle: 'Seamless Experience',
      description:
          'Scan QR code at any gym entrance. Quick, contactless, and completely hassle-free',
      accentColor: Color(0xFF14B8A6), // Teal
      secondaryColor: Color(0xFFD4AF37), // Gold
      iconType: _IconType.qrCode,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setSystemUI();
    _initParticles();
    _pageController = PageController();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
    _glowPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
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
    _particles = List.generate(25, (index) {
      final isGold = index % 4 == 0;
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 2 + random.nextDouble() * 4,
        speed: 0.1 + random.nextDouble() * 0.3,
        opacity: 0.1 + random.nextDouble() * 0.35,
        isGold: isGold,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundController.dispose();
    _contentController.dispose();
    _particlesController.dispose();
    _glowPulseController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _contentController.reset();
    _contentController.forward();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    context.go('/auth/login');
  }

  void _skip() {
    _completeOnboarding();
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
            
            // Multiple layered glowing orbs
            _buildGlowingOrbs(),
            
            // Radial gradient overlay
            _buildRadialOverlay(),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _slides.length,
                      itemBuilder: (context, index) => _OnboardingSlide(
                        data: _slides[index],
                        contentController: _contentController,
                        isActive: index == _currentPage,
                        glowPulseController: _glowPulseController,
                      ),
                    ),
                  ),
                  _buildBottom(),
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
    final luxury = context.luxury;
    
    return AnimatedBuilder(
      animation: _glowPulseController,
      builder: (context, child) {
        final pulseValue = 0.3 + (_glowPulseController.value * 0.3);
        final currentSlide = _slides[_currentPage];
        
        return Stack(
          children: [
            // Top right glow (slide accent color)
            Positioned(
              top: -100.h,
              right: -80.w,
              child: Container(
                width: 280.w,
                height: 280.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      currentSlide.accentColor.withValues(alpha: 0.18 * pulseValue),
                      currentSlide.accentColor.withValues(alpha: 0.06 * pulseValue),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Top left gold accent glow
            Positioned(
              top: -50.h,
              left: -60.w,
              child: Container(
                width: 160.w,
                height: 160.w,
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
            // Bottom glow
            Positioned(
              bottom: -60.h,
              left: MediaQuery.of(context).size.width * 0.25,
              child: Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      currentSlide.secondaryColor.withValues(alpha: 0.12 * pulseValue),
                      currentSlide.secondaryColor.withValues(alpha: 0.04 * pulseValue),
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

  Widget _buildRadialOverlay() {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 1.3,
            colors: [
              colorScheme.primary.withValues(alpha: 0.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo with luxury styling
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: luxury.gold.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: luxury.primaryGlow,
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
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
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'MyGym',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          // Skip button with gold accent
          TextButton(
            onPressed: _skip,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Skip',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: luxury.textTertiary,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12.sp,
                  color: luxury.gold.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    final luxury = context.luxury;
    final isLastPage = _currentPage == _slides.length - 1;
    final currentSlide = _slides[_currentPage];

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 40.h),
      child: Column(
        children: [
          // Luxury page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (index) => _LuxuryPageIndicator(
                isActive: index == _currentPage,
                accentColor: currentSlide.accentColor,
                goldColor: luxury.gold,
              ),
            ),
          ),
          SizedBox(height: 36.h),
          // Luxury gradient button
          _LuxuryGradientButton(
            onPressed: _nextPage,
            label: isLastPage ? 'Get Started' : 'Continue',
            accentColor: currentSlide.accentColor,
            secondaryColor: currentSlide.secondaryColor,
            isLastPage: isLastPage,
          ),
        ],
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

// ============================================================================
// DATA CLASSES
// ============================================================================

enum _IconType { location, card, qrCode }

class _OnboardingSlideData {
  final String title;
  final String subtitle;
  final String description;
  final Color accentColor;
  final Color secondaryColor;
  final _IconType iconType;

  const _OnboardingSlideData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.accentColor,
    required this.secondaryColor,
    required this.iconType,
  });
}

// ============================================================================
// SLIDE WIDGET
// ============================================================================

class _OnboardingSlide extends StatelessWidget {
  final _OnboardingSlideData data;
  final AnimationController contentController;
  final AnimationController glowPulseController;
  final bool isActive;

  const _OnboardingSlide({
    required this.data,
    required this.contentController,
    required this.glowPulseController,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: contentController,
      builder: (context, child) {
        final slideAnimation = CurvedAnimation(
          parent: contentController,
          curve: Curves.easeOutCubic,
        );

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated illustration with luxury styling
              Transform.translate(
                offset: Offset(0, 30 * (1 - slideAnimation.value)),
                child: Opacity(
                  opacity: slideAnimation.value,
                  child: _LuxuryAnimatedIllustration(
                    iconType: data.iconType,
                    accentColor: data.accentColor,
                    secondaryColor: data.secondaryColor,
                    isActive: isActive,
                    glowPulseController: glowPulseController,
                  ),
                ),
              ),
              SizedBox(height: 48.h),
              // Subtitle with gold accent
              Transform.translate(
                offset: Offset(0, 20 * (1 - slideAnimation.value)),
                child: Opacity(
                  opacity: slideAnimation.value * 0.8,
                  child: Builder(
                    builder: (context) {
                      final luxury = context.luxury;
                      return Text(
                        data.subtitle.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: luxury.gold,
                          letterSpacing: 3,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              // Title with premium font
              Transform.translate(
                offset: Offset(0, 20 * (1 - slideAnimation.value)),
                child: Opacity(
                  opacity: slideAnimation.value,
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white.withValues(alpha: 0.9),
                          data.accentColor.withValues(alpha: 0.8),
                        ],
                        stops: const [0.0, 0.7, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds);
                    },
                    child: Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              // Description with elegant styling
              Transform.translate(
                offset: Offset(0, 20 * (1 - slideAnimation.value)),
                child: Opacity(
                  opacity: slideAnimation.value * 0.9,
                  child: Builder(
                    builder: (context) {
                      final luxury = context.luxury;
                      return Text(
                        data.description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: luxury.textTertiary,
                          height: 1.7,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// LUXURY ANIMATED ILLUSTRATIONS
// ============================================================================

class _LuxuryAnimatedIllustration extends StatefulWidget {
  final _IconType iconType;
  final Color accentColor;
  final Color secondaryColor;
  final bool isActive;
  final AnimationController glowPulseController;

  const _LuxuryAnimatedIllustration({
    required this.iconType,
    required this.accentColor,
    required this.secondaryColor,
    required this.isActive,
    required this.glowPulseController,
  });

  @override
  State<_LuxuryAnimatedIllustration> createState() =>
      _LuxuryAnimatedIllustrationState();
}

class _LuxuryAnimatedIllustrationState extends State<_LuxuryAnimatedIllustration>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260.w,
      height: 260.w,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _pulseController,
          _rotateController,
          _floatController,
          widget.glowPulseController,
        ]),
        builder: (context, child) {
          final pulseValue = _pulseController.value;
          final floatValue = math.sin(_floatController.value * math.pi) * 10;
          final glowValue = 0.3 + (widget.glowPulseController.value * 0.3);

          return Transform.translate(
            offset: Offset(0, floatValue),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ambient glow
                _buildAmbientGlow(glowValue),
                // Outer glow ring
                _buildLuxuryGlowRing(pulseValue, 1.0),
                // Middle glow ring
                _buildLuxuryGlowRing(pulseValue, 0.75),
                // Inner glow ring with gold accent
                _buildLuxuryGlowRing(pulseValue, 0.5),
                // Main icon container with glassmorphism
                _buildLuxuryMainIcon(glowValue),
                // Orbiting particles (mix of accent and gold)
                ..._buildLuxuryOrbitingParticles(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmbientGlow(double glowValue) {
    return Container(
      width: 220.w,
      height: 220.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            widget.accentColor.withValues(alpha: 0.25 * glowValue),
            widget.secondaryColor.withValues(alpha: 0.1 * glowValue),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildLuxuryGlowRing(double pulseValue, double scale) {
    final baseSize = 190.w * scale;
    final animatedSize = baseSize + (25.w * pulseValue * scale);
    final opacity = 0.18 - (0.12 * pulseValue * scale);
    
    // Alternate between accent and gold for different rings
    final ringColor = scale == 0.75
        ? widget.secondaryColor
        : widget.accentColor;

    return Container(
      width: animatedSize,
      height: animatedSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ringColor.withValues(alpha: opacity.clamp(0.02, 0.18)),
          width: scale == 1.0 ? 1.0 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ringColor.withValues(alpha: 0.12 * (1 - pulseValue)),
            blurRadius: 35 * scale,
            spreadRadius: 6 * scale,
          ),
        ],
      ),
    );
  }

  Widget _buildLuxuryMainIcon(double glowValue) {
    return Container(
      width: 130.w,
      height: 130.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.accentColor.withValues(alpha: 0.25),
            widget.accentColor.withValues(alpha: 0.08),
            widget.secondaryColor.withValues(alpha: 0.05),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.secondaryColor.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          // Primary glow
          BoxShadow(
            color: widget.accentColor.withValues(alpha: 0.5 * glowValue),
            blurRadius: 50,
            spreadRadius: 5,
          ),
          // Secondary gold glow
          BoxShadow(
            color: widget.secondaryColor.withValues(alpha: 0.25 * glowValue),
            blurRadius: 60,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: _buildLuxuryIconContent(),
      ),
    );
  }

  Widget _buildLuxuryIconContent() {
    switch (widget.iconType) {
      case _IconType.location:
        return _LuxuryLocationIcon(
          accentColor: widget.accentColor,
          goldColor: widget.secondaryColor,
          pulseController: _pulseController,
        );
      case _IconType.card:
        return _LuxuryCardIcon(
          accentColor: widget.accentColor,
          goldColor: widget.secondaryColor,
          pulseController: _pulseController,
        );
      case _IconType.qrCode:
        return _LuxuryQRCodeIcon(
          accentColor: widget.accentColor,
          goldColor: widget.secondaryColor,
          pulseController: _pulseController,
        );
    }
  }

  List<Widget> _buildLuxuryOrbitingParticles() {
    return List.generate(8, (index) {
      final angle =
          (_rotateController.value * 2 * math.pi) + (index * math.pi / 4);
      final radius = 110.w;
      final x = math.cos(angle) * radius;
      final y = math.sin(angle) * radius;

      // Alternate between accent and gold particles
      final isGold = index % 3 == 0;
      final particleColor = isGold ? widget.secondaryColor : widget.accentColor;
      final particleSize = isGold ? 6.w : 8.w;

      return Positioned(
        left: 130.w + x - particleSize / 2,
        top: 130.w + y - particleSize / 2,
        child: Container(
          width: particleSize,
          height: particleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: particleColor.withValues(alpha: 0.7),
            boxShadow: [
              BoxShadow(
                color: particleColor.withValues(alpha: 0.6),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ============================================================================
// LUXURY CUSTOM ICONS
// ============================================================================

class _LuxuryLocationIcon extends StatelessWidget {
  final Color accentColor;
  final Color goldColor;
  final AnimationController pulseController;

  const _LuxuryLocationIcon({
    required this.accentColor,
    required this.goldColor,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final scale = 1.0 + (pulseController.value * 0.08);
        return Transform.scale(
          scale: scale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pin body with gradient
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      accentColor,
                      goldColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds);
                },
                child: Icon(
                  Icons.location_on_rounded,
                  size: 60.sp,
                  color: Colors.white,
                ),
              ),
              // Pulsing dot at bottom
              Positioned(
                bottom: 6.h,
                child: Container(
                  width: 14.w * (1 + pulseController.value * 0.5),
                  height: 14.w * (1 + pulseController.value * 0.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        goldColor.withValues(alpha: 0.5),
                        goldColor.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LuxuryCardIcon extends StatelessWidget {
  final Color accentColor;
  final Color goldColor;
  final AnimationController pulseController;

  const _LuxuryCardIcon({
    required this.accentColor,
    required this.goldColor,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final glowIntensity = 0.35 + (pulseController.value * 0.35);
        return Stack(
          alignment: Alignment.center,
          children: [
            // Glow effect behind card
            Container(
              width: 75.w,
              height: 52.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: glowIntensity),
                    blurRadius: 30,
                    spreadRadius: 6,
                  ),
                  BoxShadow(
                    color: goldColor.withValues(alpha: glowIntensity * 0.4),
                    blurRadius: 40,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            // Card icon with premium gradient
            Container(
              width: 68.w,
              height: 48.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor,
                    accentColor.withValues(alpha: 0.8),
                    goldColor.withValues(alpha: 0.6),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
                border: Border.all(
                  color: goldColor.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  // Gold chip
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      width: 18.w,
                      height: 14.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.r),
                        gradient: LinearGradient(
                          colors: [
                            goldColor,
                            goldColor.withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: goldColor.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Lines
                  Positioned(
                    bottom: 8.h,
                    left: 8.w,
                    right: 8.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 3.h,
                          width: 34.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.r),
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          height: 3.h,
                          width: 22.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.r),
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Key icon overlay with gold tint
            Positioned(
              right: 2.w,
              top: -2.h,
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [Colors.white, goldColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Icon(
                  Icons.vpn_key_rounded,
                  size: 22.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LuxuryQRCodeIcon extends StatefulWidget {
  final Color accentColor;
  final Color goldColor;
  final AnimationController pulseController;

  const _LuxuryQRCodeIcon({
    required this.accentColor,
    required this.goldColor,
    required this.pulseController,
  });

  @override
  State<_LuxuryQRCodeIcon> createState() => _LuxuryQRCodeIconState();
}

class _LuxuryQRCodeIconState extends State<_LuxuryQRCodeIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanLineController;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          Listenable.merge([widget.pulseController, _scanLineController]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // QR Code container with premium styling
            Container(
              width: 65.w,
              height: 65.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.white,
                border: Border.all(
                  color: widget.goldColor.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: 0.35),
                    blurRadius: 25,
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: widget.goldColor.withValues(alpha: 0.15),
                    blurRadius: 35,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: EdgeInsets.all(7.w),
              child: _buildQRPattern(),
            ),
            // Scan line with gold gradient
            Positioned(
              top: 7.h + (_scanLineController.value * 51.h),
              child: Container(
                width: 55.w,
                height: 2.5.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.goldColor.withValues(alpha: 0),
                      widget.accentColor,
                      widget.goldColor,
                      widget.accentColor,
                      widget.goldColor.withValues(alpha: 0),
                    ],
                    stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.8),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            // Corner brackets with gold accent
            ..._buildLuxuryCornerBrackets(),
          ],
        );
      },
    );
  }

  Widget _buildQRPattern() {
    return CustomPaint(
      size: Size(51.w, 51.w),
      painter: _LuxuryQRPatternPainter(
        accentColor: widget.accentColor,
        goldColor: widget.goldColor,
      ),
    );
  }

  List<Widget> _buildLuxuryCornerBrackets() {
    final bracketSize = 14.w;
    final bracketThickness = 3.w;

    return [
      // Top left
      Positioned(
        left: -5.w,
        top: -5.h,
        child: _LuxuryCornerBracket(
          accentColor: widget.accentColor,
          goldColor: widget.goldColor,
          size: bracketSize,
          thickness: bracketThickness,
          rotation: 0,
        ),
      ),
      // Top right
      Positioned(
        right: -5.w,
        top: -5.h,
        child: _LuxuryCornerBracket(
          accentColor: widget.accentColor,
          goldColor: widget.goldColor,
          size: bracketSize,
          thickness: bracketThickness,
          rotation: 1,
        ),
      ),
      // Bottom left
      Positioned(
        left: -5.w,
        bottom: -5.h,
        child: _LuxuryCornerBracket(
          accentColor: widget.accentColor,
          goldColor: widget.goldColor,
          size: bracketSize,
          thickness: bracketThickness,
          rotation: 3,
        ),
      ),
      // Bottom right
      Positioned(
        right: -5.w,
        bottom: -5.h,
        child: _LuxuryCornerBracket(
          accentColor: widget.accentColor,
          goldColor: widget.goldColor,
          size: bracketSize,
          thickness: bracketThickness,
          rotation: 2,
        ),
      ),
    ];
  }
}

class _LuxuryCornerBracket extends StatelessWidget {
  final Color accentColor;
  final Color goldColor;
  final double size;
  final double thickness;
  final int rotation;

  const _LuxuryCornerBracket({
    required this.accentColor,
    required this.goldColor,
    required this.size,
    required this.thickness,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation * math.pi / 2,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _LuxuryCornerBracketPainter(
            accentColor: accentColor,
            goldColor: goldColor,
            thickness: thickness,
          ),
        ),
      ),
    );
  }
}

class _LuxuryCornerBracketPainter extends CustomPainter {
  final Color accentColor;
  final Color goldColor;
  final double thickness;

  _LuxuryCornerBracketPainter({
    required this.accentColor,
    required this.goldColor,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [accentColor, goldColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LuxuryQRPatternPainter extends CustomPainter {
  final Color accentColor;
  final Color goldColor;

  _LuxuryQRPatternPainter({
    required this.accentColor,
    required this.goldColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1A1A2E);
    final goldPaint = Paint()..color = goldColor.withValues(alpha: 0.8);
    final unitSize = size.width / 7;

    // QR code pattern (simplified)
    final pattern = [
      [1, 1, 1, 0, 1, 1, 1],
      [1, 2, 1, 0, 1, 2, 1],
      [1, 1, 1, 0, 1, 1, 1],
      [0, 0, 0, 2, 0, 0, 0],
      [1, 1, 1, 0, 1, 0, 1],
      [1, 2, 1, 2, 0, 2, 0],
      [1, 1, 1, 0, 1, 0, 1],
    ];

    for (var row = 0; row < pattern.length; row++) {
      for (var col = 0; col < pattern[row].length; col++) {
        if (pattern[row][col] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * unitSize,
              row * unitSize,
              unitSize * 0.88,
              unitSize * 0.88,
            ),
            paint,
          );
        } else if (pattern[row][col] == 2) {
          // Gold accent squares
          canvas.drawRect(
            Rect.fromLTWH(
              col * unitSize,
              row * unitSize,
              unitSize * 0.88,
              unitSize * 0.88,
            ),
            goldPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


// ============================================================================
// LUXURY PAGE INDICATOR
// ============================================================================

class _LuxuryPageIndicator extends StatelessWidget {
  final bool isActive;
  final Color accentColor;
  final Color goldColor;

  const _LuxuryPageIndicator({
    required this.isActive,
    required this.accentColor,
    required this.goldColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      width: isActive ? 36.w : 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        gradient: isActive
            ? LinearGradient(
                colors: [
                  accentColor,
                  goldColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isActive ? null : Colors.white.withValues(alpha: 0.2),
        border: isActive
            ? Border.all(
                color: goldColor.withValues(alpha: 0.3),
                width: 1,
              )
            : null,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.5),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: goldColor.withValues(alpha: 0.2),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
    );
  }
}

// ============================================================================
// LUXURY GRADIENT BUTTON
// ============================================================================

class _LuxuryGradientButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final Color accentColor;
  final Color secondaryColor;
  final bool isLastPage;

  const _LuxuryGradientButton({
    required this.onPressed,
    required this.label,
    required this.accentColor,
    required this.secondaryColor,
    required this.isLastPage,
  });

  @override
  State<_LuxuryGradientButton> createState() => _LuxuryGradientButtonState();
}

class _LuxuryGradientButtonState extends State<_LuxuryGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        final glowOpacity = 0.35 + (_glowController.value * 0.25);

        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onPressed();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutCubic,
            child: Container(
              width: double.infinity,
              height: 60.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isLastPage
                      ? [
                          const Color(0xFFD4AF37),
                          widget.accentColor,
                          const Color(0xFFAA8C2C),
                        ]
                      : [
                          widget.accentColor,
                          widget.accentColor.withValues(alpha: 0.85),
                          widget.secondaryColor.withValues(alpha: 0.7),
                        ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: widget.isLastPage
                      ? const Color(0xFFD4AF37).withValues(alpha: 0.4)
                      : widget.accentColor.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: glowOpacity),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                    spreadRadius: 0,
                  ),
                  if (widget.isLastPage)
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withValues(alpha: glowOpacity * 0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.label,
                    style: GoogleFonts.montserrat(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Icon(
                    widget.isLastPage
                        ? Icons.arrow_forward_rounded
                        : Icons.arrow_forward_ios_rounded,
                    size: widget.isLastPage ? 22.sp : 16.sp,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}