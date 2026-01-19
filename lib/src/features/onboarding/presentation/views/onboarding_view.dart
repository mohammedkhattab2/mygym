import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Premium Onboarding View with animated slides
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
  
  int _currentPage = 0;

  static const List<_OnboardingSlideData> _slides = [
    _OnboardingSlideData(
      title: 'Discover Gyms',
      description:
          'Find and explore 200+ premium gyms near you with real-time availability',
      accentColor: Color(0xFF8B5CF6),
      iconType: _IconType.location,
    ),
    _OnboardingSlideData(
      title: 'One Pass, All Access',
      description:
          'Single membership unlocks all partner gyms. No contracts, pure flexibility',
      accentColor: Color(0xFF3B82F6),
      iconType: _IconType.card,
    ),
    _OnboardingSlideData(
      title: 'Instant Check-in',
      description:
          'Scan QR code at any gym entrance. Quick, contactless, hassle-free',
      accentColor: Color(0xFF14B8A6),
      iconType: _IconType.qrCode,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundController.dispose();
    _contentController.dispose();
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
    context.go('/onboarding/city');
  }

  void _skip() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A14),
              Color(0xFF12121F),
              Color(0xFF0F0F1A),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
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
                  ),
                ),
              ),
              _buildBottom(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.fitness_center_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'MyGym',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          // Skip button
          TextButton(
            onPressed: _skip,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
            child: Text(
              'Skip',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    final isLastPage = _currentPage == _slides.length - 1;
    final currentSlide = _slides[_currentPage];

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
      child: Column(
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (index) => _PageIndicator(
                isActive: index == _currentPage,
                accentColor: currentSlide.accentColor,
              ),
            ),
          ),
          SizedBox(height: 32.h),
          // Next / Get Started button
          _GradientButton(
            onPressed: _nextPage,
            label: isLastPage ? 'Get Started' : 'Next',
            accentColor: currentSlide.accentColor,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DATA CLASSES
// ============================================================================

enum _IconType { location, card, qrCode }

class _OnboardingSlideData {
  final String title;
  final String description;
  final Color accentColor;
  final _IconType iconType;

  const _OnboardingSlideData({
    required this.title,
    required this.description,
    required this.accentColor,
    required this.iconType,
  });
}

// ============================================================================
// SLIDE WIDGET
// ============================================================================

class _OnboardingSlide extends StatelessWidget {
  final _OnboardingSlideData data;
  final AnimationController contentController;
  final bool isActive;

  const _OnboardingSlide({
    required this.data,
    required this.contentController,
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
              // Animated illustration
              Transform.translate(
                offset: Offset(0, 30 * (1 - slideAnimation.value)),
                child: Opacity(
                  opacity: slideAnimation.value,
                  child: _AnimatedIllustration(
                    iconType: data.iconType,
                    accentColor: data.accentColor,
                    isActive: isActive,
                  ),
                ),
              ),
              SizedBox(height: 48.h),
              // Title
              Transform.translate(
                offset: Offset(0, 20 * (1 - slideAnimation.value)),
                child: Opacity(
                  opacity: slideAnimation.value,
                  child: Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Description
              Transform.translate(
                offset: Offset(0, 20 * (1 - slideAnimation.value)),
                child: Opacity(
                  opacity: slideAnimation.value * 0.9,
                  child: Text(
                    data.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9CA3AF),
                      height: 1.6,
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

// ============================================================================
// ANIMATED ILLUSTRATIONS
// ============================================================================

class _AnimatedIllustration extends StatefulWidget {
  final _IconType iconType;
  final Color accentColor;
  final bool isActive;

  const _AnimatedIllustration({
    required this.iconType,
    required this.accentColor,
    required this.isActive,
  });

  @override
  State<_AnimatedIllustration> createState() => _AnimatedIllustrationState();
}

class _AnimatedIllustrationState extends State<_AnimatedIllustration>
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
      duration: const Duration(seconds: 8),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
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
      width: 240.w,
      height: 240.w,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _pulseController,
          _rotateController,
          _floatController,
        ]),
        builder: (context, child) {
          final pulseValue = _pulseController.value;
          final floatValue = math.sin(_floatController.value * math.pi) * 8;

          return Transform.translate(
            offset: Offset(0, floatValue),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                _buildGlowRing(pulseValue, 1.0),
                // Middle glow ring
                _buildGlowRing(pulseValue, 0.75),
                // Inner glow ring
                _buildGlowRing(pulseValue, 0.5),
                // Main icon container
                _buildMainIcon(),
                // Orbiting particles
                ..._buildOrbitingParticles(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlowRing(double pulseValue, double scale) {
    final baseSize = 180.w * scale;
    final animatedSize = baseSize + (20.w * pulseValue * scale);
    final opacity = 0.15 - (0.1 * pulseValue * scale);

    return Container(
      width: animatedSize,
      height: animatedSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.accentColor.withValues(alpha: opacity.clamp(0.02, 0.15)),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.accentColor.withValues(alpha: 0.1 * (1 - pulseValue)),
            blurRadius: 30 * scale,
            spreadRadius: 5 * scale,
          ),
        ],
      ),
    );
  }

  Widget _buildMainIcon() {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.accentColor.withValues(alpha: 0.2),
            widget.accentColor.withValues(alpha: 0.05),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.accentColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.accentColor.withValues(alpha: 0.4),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: _buildIconContent(),
      ),
    );
  }

  Widget _buildIconContent() {
    switch (widget.iconType) {
      case _IconType.location:
        return _LocationIcon(
          accentColor: widget.accentColor,
          pulseController: _pulseController,
        );
      case _IconType.card:
        return _CardIcon(
          accentColor: widget.accentColor,
          pulseController: _pulseController,
        );
      case _IconType.qrCode:
        return _QRCodeIcon(
          accentColor: widget.accentColor,
          pulseController: _pulseController,
        );
    }
  }

  List<Widget> _buildOrbitingParticles() {
    return List.generate(6, (index) {
      final angle = (_rotateController.value * 2 * math.pi) +
          (index * math.pi / 3);
      final radius = 100.w;
      final x = math.cos(angle) * radius;
      final y = math.sin(angle) * radius;

      return Positioned(
        left: 120.w + x - 4.w,
        top: 120.w + y - 4.w,
        child: Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.accentColor.withValues(alpha: 0.6),
            boxShadow: [
              BoxShadow(
                color: widget.accentColor.withValues(alpha: 0.5),
                blurRadius: 8,
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
// CUSTOM ICONS
// ============================================================================

class _LocationIcon extends StatelessWidget {
  final Color accentColor;
  final AnimationController pulseController;

  const _LocationIcon({
    required this.accentColor,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final scale = 1.0 + (pulseController.value * 0.1);
        return Transform.scale(
          scale: scale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pin body
              Icon(
                Icons.location_on_rounded,
                size: 56.sp,
                color: accentColor,
              ),
              // Pulsing dot at bottom
              Positioned(
                bottom: 8.h,
                child: Container(
                  width: 12.w * (1 + pulseController.value * 0.5),
                  height: 12.w * (1 + pulseController.value * 0.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withValues(alpha: 0.3),
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

class _CardIcon extends StatelessWidget {
  final Color accentColor;
  final AnimationController pulseController;

  const _CardIcon({
    required this.accentColor,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final glowIntensity = 0.3 + (pulseController.value * 0.4);
        return Stack(
          alignment: Alignment.center,
          children: [
            // Glow effect behind card
            Container(
              width: 70.w,
              height: 50.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: glowIntensity),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            // Card icon
            Container(
              width: 64.w,
              height: 44.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor,
                    accentColor.withValues(alpha: 0.7),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  // Chip
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      width: 16.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.r),
                        color: Colors.amber.withValues(alpha: 0.8),
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
                          width: 32.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.r),
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          height: 3.h,
                          width: 20.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2.r),
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Key icon overlay
            Positioned(
              right: 4.w,
              top: 0,
              child: Icon(
                Icons.vpn_key_rounded,
                size: 20.sp,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QRCodeIcon extends StatefulWidget {
  final Color accentColor;
  final AnimationController pulseController;

  const _QRCodeIcon({
    required this.accentColor,
    required this.pulseController,
  });

  @override
  State<_QRCodeIcon> createState() => _QRCodeIconState();
}

class _QRCodeIconState extends State<_QRCodeIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanLineController;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
      animation: Listenable.merge([widget.pulseController, _scanLineController]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // QR Code container
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.all(6.w),
              child: _buildQRPattern(),
            ),
            // Scan line
            Positioned(
              top: 6.h + (_scanLineController.value * 48.h),
              child: Container(
                width: 52.w,
                height: 2.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.accentColor.withValues(alpha: 0),
                      widget.accentColor,
                      widget.accentColor.withValues(alpha: 0),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.8),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
            // Corner brackets
            ..._buildCornerBrackets(),
          ],
        );
      },
    );
  }

  Widget _buildQRPattern() {
    return CustomPaint(
      size: Size(48.w, 48.w),
      painter: _QRPatternPainter(accentColor: widget.accentColor),
    );
  }

  List<Widget> _buildCornerBrackets() {
    final bracketColor = widget.accentColor;
    final bracketSize = 12.w;
    final bracketThickness = 3.w;

    return [
      // Top left
      Positioned(
        left: -4.w,
        top: -4.h,
        child: _CornerBracket(
          color: bracketColor,
          size: bracketSize,
          thickness: bracketThickness,
          rotation: 0,
        ),
      ),
      // Top right
      Positioned(
        right: -4.w,
        top: -4.h,
        child: _CornerBracket(
          color: bracketColor,
          size: bracketSize,
          thickness: bracketThickness,
          rotation: 1,
        ),
      ),
      // Bottom left
      Positioned(
        left: -4.w,
        bottom: -4.h,
        child: _CornerBracket(
          color: bracketColor,
          size: bracketSize,
          thickness: bracketThickness,
          rotation: 3,
        ),
      ),
      // Bottom right
      Positioned(
        right: -4.w,
        bottom: -4.h,
        child: _CornerBracket(
          color: bracketColor,
          size: bracketSize,
          thickness: bracketThickness,
          rotation: 2,
        ),
      ),
    ];
  }
}

class _CornerBracket extends StatelessWidget {
  final Color color;
  final double size;
  final double thickness;
  final int rotation; // 0 = top-left, 1 = top-right, 2 = bottom-right, 3 = bottom-left

  const _CornerBracket({
    required this.color,
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
          painter: _CornerBracketPainter(color: color, thickness: thickness),
        ),
      ),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  final Color color;
  final double thickness;

  _CornerBracketPainter({required this.color, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
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

class _QRPatternPainter extends CustomPainter {
  final Color accentColor;

  _QRPatternPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1A1A2E);
    final unitSize = size.width / 7;

    // QR code pattern (simplified)
    final pattern = [
      [1, 1, 1, 0, 1, 1, 1],
      [1, 0, 1, 0, 1, 0, 1],
      [1, 1, 1, 0, 1, 1, 1],
      [0, 0, 0, 1, 0, 0, 0],
      [1, 1, 1, 0, 1, 0, 1],
      [1, 0, 1, 1, 0, 1, 0],
      [1, 1, 1, 0, 1, 0, 1],
    ];

    for (var row = 0; row < pattern.length; row++) {
      for (var col = 0; col < pattern[row].length; col++) {
        if (pattern[row][col] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
              col * unitSize,
              row * unitSize,
              unitSize * 0.9,
              unitSize * 0.9,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================================
// PAGE INDICATOR
// ============================================================================

class _PageIndicator extends StatelessWidget {
  final bool isActive;
  final Color accentColor;

  const _PageIndicator({
    required this.isActive,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 32.w : 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        gradient: isActive
            ? LinearGradient(
                colors: [accentColor, accentColor.withValues(alpha: 0.6)],
              )
            : null,
        color: isActive ? null : const Color(0xFF2A2A3E),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
    );
  }
}

// ============================================================================
// GRADIENT BUTTON
// ============================================================================

class _GradientButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final Color accentColor;

  const _GradientButton({
    required this.onPressed,
    required this.label,
    required this.accentColor,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
        final glowOpacity = 0.3 + (_glowController.value * 0.2);

        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onPressed();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.accentColor,
                    widget.accentColor.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: glowOpacity),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}