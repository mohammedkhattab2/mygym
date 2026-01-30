import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/luxury_theme_extension.dart';

/// Premium Luxury Onboarding View with static slides
///
/// Features:
/// - Static glowing orbs with premium styling
/// - Premium typography with Google Fonts
/// - Elegant page indicators with gold shimmer
/// - Luxurious gradient buttons
/// - Smooth page transitions (built-in PageView)
/// - No custom animations - pure static luxury styling
class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const List<_OnboardingSlideData> _slides = [
    _OnboardingSlideData(
      title: 'Discover Premium Gyms',
      subtitle: 'Your Fitness Journey Begins',
      description:
          'Find and explore 200+ premium gyms near you with real-time availability and crowd insights',
      iconType: _IconType.location,
    ),
    _OnboardingSlideData(
      title: 'One Pass, All Access',
      subtitle: 'Unlimited Flexibility',
      description:
          'Single membership unlocks all partner gyms. No contracts, pure flexibility and freedom',
      iconType: _IconType.card,
    ),
    _OnboardingSlideData(
      title: 'Instant Check-in',
      subtitle: 'Seamless Experience',
      description:
          'Scan QR code at any gym entrance. Quick, contactless, and completely hassle-free',
      iconType: _IconType.qrCode,
    ),
  ];

  bool _systemUISet = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_systemUISet) {
      _systemUISet = true;
      _setSystemUI();
    }
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
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
            // Main content
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(colorScheme, luxury),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _slides.length,
                      itemBuilder: (context, index) => _OnboardingSlide(
                        data: _slides[index],
                        isActive: index == _currentPage,
                      ),
                    ),
                  ),
                  _buildBottom(colorScheme, luxury),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
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
                        colorScheme.onPrimary,
                        luxury.goldLight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.fitness_center_rounded,
                    color: colorScheme.onPrimary,
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

  Widget _buildBottom(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    final isLastPage = _currentPage == _slides.length - 1;

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
                colorScheme: colorScheme,
                goldColor: luxury.gold,
              ),
            ),
          ),
          SizedBox(height: 36.h),
          // Luxury gradient button
          _LuxuryGradientButton(
            onPressed: _nextPage,
            label: isLastPage ? 'Get Started' : 'Continue',
            colorScheme: colorScheme,
            luxury: luxury,
            isLastPage: isLastPage,
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
  final String subtitle;
  final String description;
  final _IconType iconType;

  const _OnboardingSlideData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.iconType,
  });
}

// ============================================================================
// SLIDE WIDGET (Static - No Animation)
// ============================================================================

class _OnboardingSlide extends StatelessWidget {
  final _OnboardingSlideData data;
  final bool isActive;

  const _OnboardingSlide({
    required this.data,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Static illustration with luxury styling
          _LuxuryStaticIllustration(
            iconType: data.iconType,
            colorScheme: colorScheme,
            luxury: luxury,
          ),
          SizedBox(height: 48.h),
          // Subtitle with gold accent
          Text(
            data.subtitle.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: luxury.gold,
              letterSpacing: 3,
            ),
          ),
          SizedBox(height: 12.h),
          // Title with premium font
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  colorScheme.onSurface,
                  colorScheme.onSurface.withValues(alpha: 0.9),
                  colorScheme.primary.withValues(alpha: 0.8),
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
                color: colorScheme.onSurface,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Description with elegant styling
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: luxury.textTertiary,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LUXURY STATIC ILLUSTRATION
// ============================================================================

class _LuxuryStaticIllustration extends StatelessWidget {
  final _IconType iconType;
  final ColorScheme colorScheme;
  final LuxuryThemeExtension luxury;

  const _LuxuryStaticIllustration({
    required this.iconType,
    required this.colorScheme,
    required this.luxury,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final glowIntensity = isDark ? 1.0 : 0.7;
    
    return SizedBox(
      width: 260.w,
      height: 260.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ambient glow
          _buildAmbientGlow(glowIntensity),
          // Outer glow ring
          _buildLuxuryGlowRing(1.0, glowIntensity),
          // Middle glow ring
          _buildLuxuryGlowRing(0.75, glowIntensity),
          // Inner glow ring with gold accent
          _buildLuxuryGlowRing(0.5, glowIntensity),
          // Main icon container with glassmorphism
          _buildLuxuryMainIcon(glowIntensity),
          // Static decorative particles
          ..._buildStaticDecorations(),
        ],
      ),
    );
  }

  Widget _buildAmbientGlow(double glowIntensity) {
    return Container(
      width: 220.w,
      height: 220.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.2 * glowIntensity),
            luxury.gold.withValues(alpha: 0.08 * glowIntensity),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildLuxuryGlowRing(double scale, double glowIntensity) {
    final baseSize = 190.w * scale;
    final opacity = (0.15 * scale * glowIntensity).clamp(0.02, 0.15);
    
    // Alternate between primary and gold for different rings
    final ringColor = scale == 0.75
        ? luxury.gold
        : colorScheme.primary;

    return Container(
      width: baseSize,
      height: baseSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ringColor.withValues(alpha: opacity),
          width: scale == 1.0 ? 1.0 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ringColor.withValues(alpha: 0.1 * glowIntensity),
            blurRadius: 20 * scale,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildLuxuryMainIcon(double glowIntensity) {
    return Container(
      width: 130.w,
      height: 130.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.25),
            colorScheme.primary.withValues(alpha: 0.08),
            luxury.gold.withValues(alpha: 0.05),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: _buildLuxuryIconContent(),
      ),
    );
  }

  Widget _buildLuxuryIconContent() {
    switch (iconType) {
      case _IconType.location:
        return _LuxuryLocationIcon(
          colorScheme: colorScheme,
          goldColor: luxury.gold,
        );
      case _IconType.card:
        return _LuxuryCardIcon(
          colorScheme: colorScheme,
          goldColor: luxury.gold,
        );
      case _IconType.qrCode:
        return _LuxuryQRCodeIcon(
          colorScheme: colorScheme,
          goldColor: luxury.gold,
        );
    }
  }

  List<Widget> _buildStaticDecorations() {
    // Static decorative particles positioned around the icon
    final positions = [
      const Offset(0.85, 0.15),
      const Offset(0.15, 0.85),
      const Offset(0.92, 0.5),
      const Offset(0.08, 0.5),
      const Offset(0.7, 0.9),
      const Offset(0.3, 0.1),
    ];
    
    return positions.asMap().entries.map((entry) {
      final index = entry.key;
      final pos = entry.value;
      final isGold = index % 2 == 0;
      final particleColor = isGold ? luxury.gold : colorScheme.primary;
      final particleSize = isGold ? 6.w : 8.w;
      
      return Positioned(
        left: 260.w * pos.dx - particleSize / 2,
        top: 260.w * pos.dy - particleSize / 2,
        child: Container(
          width: particleSize,
          height: particleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: particleColor.withValues(alpha: 0.6),
            boxShadow: [
              BoxShadow(
                color: particleColor.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

// ============================================================================
// LUXURY CUSTOM ICONS (Static - No Animation)
// ============================================================================

class _LuxuryLocationIcon extends StatelessWidget {
  final ColorScheme colorScheme;
  final Color goldColor;

  const _LuxuryLocationIcon({
    required this.colorScheme,
    required this.goldColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pin body with gradient
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                colorScheme.primary,
                goldColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds);
          },
          child: Icon(
            Icons.location_on_rounded,
            size: 60.sp,
            color: colorScheme.onPrimary,
          ),
        ),
        // Static glow dot at bottom
        Positioned(
          bottom: 6.h,
          child: Container(
            width: 14.w,
            height: 14.w,
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
    );
  }
}

class _LuxuryCardIcon extends StatelessWidget {
  final ColorScheme colorScheme;
  final Color goldColor;

  const _LuxuryCardIcon({
    required this.colorScheme,
    required this.goldColor,
  });

  @override
  Widget build(BuildContext context) {
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
                color: colorScheme.shadow.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
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
                colorScheme.primary,
                colorScheme.primary.withValues(alpha: 0.8),
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
                        color: colorScheme.onPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      height: 3.h,
                      width: 22.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.r),
                        color: colorScheme.onPrimary.withValues(alpha: 0.35),
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
                colors: [colorScheme.onPrimary, goldColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Icon(
              Icons.vpn_key_rounded,
              size: 22.sp,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _LuxuryQRCodeIcon extends StatelessWidget {
  final ColorScheme colorScheme;
  final Color goldColor;

  const _LuxuryQRCodeIcon({
    required this.colorScheme,
    required this.goldColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // QR Code container with premium styling
        Container(
          width: 65.w,
          height: 65.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: colorScheme.onPrimary,
            border: Border.all(
              color: goldColor.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: EdgeInsets.all(7.w),
          child: _buildQRPattern(),
        ),
        // Static scan line with gold gradient
        Positioned(
          top: 20.h,
          child: Container(
            width: 55.w,
            height: 2.5.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  goldColor.withValues(alpha: 0),
                  colorScheme.primary,
                  goldColor,
                  colorScheme.primary,
                  goldColor.withValues(alpha: 0),
                ],
                stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        // Corner brackets with gold accent
        ..._buildLuxuryCornerBrackets(),
      ],
    );
  }

  Widget _buildQRPattern() {
    return CustomPaint(
      size: Size(51.w, 51.w),
      painter: _LuxuryQRPatternPainter(
        primaryColor: colorScheme.scrim,
        goldColor: goldColor,
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
          primaryColor: colorScheme.primary,
          goldColor: goldColor,
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
          primaryColor: colorScheme.primary,
          goldColor: goldColor,
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
          primaryColor: colorScheme.primary,
          goldColor: goldColor,
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
          primaryColor: colorScheme.primary,
          goldColor: goldColor,
          size: bracketSize,
          thickness: bracketThickness,
          rotation: 2,
        ),
      ),
    ];
  }
}

class _LuxuryCornerBracket extends StatelessWidget {
  final Color primaryColor;
  final Color goldColor;
  final double size;
  final double thickness;
  final int rotation;

  const _LuxuryCornerBracket({
    required this.primaryColor,
    required this.goldColor,
    required this.size,
    required this.thickness,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation * 3.14159 / 2,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _LuxuryCornerBracketPainter(
            primaryColor: primaryColor,
            goldColor: goldColor,
            thickness: thickness,
          ),
        ),
      ),
    );
  }
}

class _LuxuryCornerBracketPainter extends CustomPainter {
  final Color primaryColor;
  final Color goldColor;
  final double thickness;

  _LuxuryCornerBracketPainter({
    required this.primaryColor,
    required this.goldColor,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [primaryColor, goldColor],
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
  final Color primaryColor;
  final Color goldColor;

  _LuxuryQRPatternPainter({
    required this.primaryColor,
    required this.goldColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = primaryColor;
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
// LUXURY PAGE INDICATOR (Static)
// ============================================================================

class _LuxuryPageIndicator extends StatelessWidget {
  final bool isActive;
  final ColorScheme colorScheme;
  final Color goldColor;

  const _LuxuryPageIndicator({
    required this.isActive,
    required this.colorScheme,
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
                  colorScheme.primary,
                  goldColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isActive ? null : colorScheme.onSurface.withValues(alpha: 0.2),
        border: isActive
            ? Border.all(
                color: goldColor.withValues(alpha: 0.3),
                width: 1,
              )
            : null,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.5),
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
// LUXURY GRADIENT BUTTON (Static - No Animation)
// ============================================================================

class _LuxuryGradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final ColorScheme colorScheme;
  final LuxuryThemeExtension luxury;
  final bool isLastPage;

  const _LuxuryGradientButton({
    required this.onPressed,
    required this.label,
    required this.colorScheme,
    required this.luxury,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          width: double.infinity,
          height: 60.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isLastPage
                  ? [
                      luxury.gold,
                      colorScheme.primary,
                      luxury.gold.withValues(alpha: 0.8),
                    ]
                  : [
                      colorScheme.primary,
                      colorScheme.primary.withValues(alpha: 0.85),
                      luxury.gold.withValues(alpha: 0.7),
                    ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isLastPage
                  ? luxury.gold.withValues(alpha: 0.4)
                  : colorScheme.primary.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 25,
                offset: const Offset(0, 10),
                spreadRadius: 0,
              ),
              if (isLastPage)
                BoxShadow(
                  color: luxury.gold.withValues(alpha: 0.25),
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
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimary,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(width: 10.w),
              Icon(
                isLastPage
                    ? Icons.arrow_forward_rounded
                    : Icons.arrow_forward_ios_rounded,
                size: isLastPage ? 22.sp : 16.sp,
                color: colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}