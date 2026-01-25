import 'dart:math' as math;

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/app_theme.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/core/widgets/app_button.dart';
import 'package:mygym/src/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mygym/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_divider.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_guest_option.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_header.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_phone_input.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_social_buttons.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_terms.dart';

/// Premium Luxury Login View
///
/// Features:
/// - Animated floating particles with gold accents
/// - Multiple layered glowing orbs
/// - Premium glassmorphism card for form
/// - Elegant typography with Google Fonts
/// - Gold gradient accents
/// - Smooth animations
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+20';
  String _selectedCountryFlag = '🇪🇬';
  
  // Animation controllers
  late AnimationController _glowPulseController;
  late AnimationController _particlesController;
  late AnimationController _contentController;
  
  // Particles data
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(AppTheme.darkSystemUiOverlayStyle);
    _initParticles();
    _initAnimations();
  }

  void _initParticles() {
    final random = math.Random();
    _particles = List.generate(20, (index) {
      final isGold = index % 4 == 0;
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 2 + random.nextDouble() * 4,
        speed: 0.1 + random.nextDouble() * 0.25,
        opacity: 0.1 + random.nextDouble() * 0.3,
        isGold: isGold,
      );
    });
  }

  void _initAnimations() {
    _glowPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
    
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _glowPulseController.dispose();
    _particlesController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // ============================================
  // SOCIAL SIGN-IN
  // ============================================

  void _onGoogleSignIn() {
    context.read<AuthCubit>().signInWithGoogle();
  }

  void _onAppleSignIn() {
    context.read<AuthCubit>().signInWithApple();
  }

  // ============================================
  // PHONE OTP
  // ============================================

  void _showCountryPicker() {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _selectedCountryCode = '+${country.phoneCode}';
          _selectedCountryFlag = country.flagEmoji;
        });
      },
      countryListTheme: CountryListThemeData(
        backgroundColor: colorScheme.surface,
        textStyle: TextStyle(color: colorScheme.onSurface, fontSize: 16.sp),
        searchTextStyle: TextStyle(color: colorScheme.onSurface, fontSize: 16.sp),
        inputDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.4)),
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurface.withValues(alpha: 0.4)),
          filled: true,
          fillColor: luxury.surfaceElevated,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
    );
  }

  void _onSendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showError("Please enter a phone number");
      return;
    }
    if (phone.length < 6) {
      _showError("Please enter a valid phone number");
      return;
    }

    final fullPhoneNumber = '$_selectedCountryCode$phone';
    context.read<AuthCubit>().sendOtp(phone: fullPhoneNumber);
  }

  // ============================================
  // GUEST LOGIN
  // ============================================

  void _onGuestLogin() {
    context.read<AuthCubit>().continueAsGuest();
  }

  // ============================================
  // BUILD
  // ============================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Handle OTP sent → navigate to OTP screen
        if (state.isOtpSent) {
          final fullPhoneNumber =
              '$_selectedCountryCode${_phoneController.text.trim()}';
          context.push('/auth/otp', extra: fullPhoneNumber);
        }

        // Handle authenticated → navigate to home
        if (state.isAuthenticated) {
          context.go('/member/home');
        }

        // Handle errors
        if (state.hasError && state.errorMessage != null) {
          _showError(state.errorMessage!);
        }
      },
      child: Scaffold(
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
              
              // Glowing orbs
              _buildGlowingOrbs(),
              
              // Radial overlay
              _buildRadialOverlay(),
              
              // Main content
              SafeArea(
                child: AnimatedBuilder(
                  animation: _contentController,
                  builder: (context, child) {
                    final fadeAnimation = CurvedAnimation(
                      parent: _contentController,
                      curve: Curves.easeOut,
                    );
                    final slideAnimation = CurvedAnimation(
                      parent: _contentController,
                      curve: Curves.easeOutCubic,
                    );
                    
                    return Opacity(
                      opacity: fadeAnimation.value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - slideAnimation.value)),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            children: [
                              SizedBox(height: 40.h),
                              const BuildHeader(),
                              SizedBox(height: 36.h),

                              // Social Buttons with loading state
                              BlocBuilder<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  return BuildSocialButtons(
                                    onGoogleSignIn:
                                        state.isLoading ? null : _onGoogleSignIn,
                                    onAppleSignIn: state.isLoading ? null : _onAppleSignIn,
                                  );
                                },
                              ),

                              SizedBox(height: 28.h),
                              const BuildDivider(),
                              SizedBox(height: 28.h),

                              BuildPhoneInput(
                                phoneController: _phoneController,
                                selectedCountryCode: _selectedCountryCode,
                                selectedCountryFlag: _selectedCountryFlag,
                                onShowCountryPicker: _showCountryPicker,
                              ),

                              SizedBox(height: 28.h),

                              // Send OTP Button with loading state
                              BlocBuilder<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  return _buildLuxuryButton(
                                    text: 'Send Verification Code',
                                    onPressed: state.isLoading ? null : _onSendOtp,
                                    isLoading: state.isLoading,
                                  );
                                },
                              ),

                              SizedBox(height: 24.h),

                              BuildGuestOption(
                                onGuestLogin: _onGuestLogin,
                              ),

                              SizedBox(height: 32.h),
                              const BuildTerms(),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
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

  Widget _buildGlowingOrbs() {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return AnimatedBuilder(
      animation: _glowPulseController,
      builder: (context, child) {
        final pulseValue = 0.3 + (_glowPulseController.value * 0.3);
        
        return Stack(
          children: [
            // Top right purple glow
            Positioned(
              top: -80.h,
              right: -60.w,
              child: Container(
                width: 240.w,
                height: 240.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.2 * pulseValue),
                      colorScheme.primary.withValues(alpha: 0.06 * pulseValue),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Top left gold glow
            Positioned(
              top: -40.h,
              left: -50.w,
              child: Container(
                width: 150.w,
                height: 150.w,
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
            // Bottom glow
            Positioned(
              bottom: -50.h,
              left: MediaQuery.of(context).size.width * 0.3,
              child: Container(
                width: 180.w,
                height: 180.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.secondary.withValues(alpha: 0.1 * pulseValue),
                      colorScheme.secondary.withValues(alpha: 0.03 * pulseValue),
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
            center: const Alignment(0, -0.3),
            radius: 1.2,
            colors: [
              colorScheme.primary.withValues(alpha: 0.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLuxuryButton({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return AnimatedBuilder(
      animation: _glowPulseController,
      builder: (context, child) {
        final glowOpacity = 0.35 + (_glowPulseController.value * 0.2);
        
        return GestureDetector(
          onTap: isLoading ? null : onPressed,
          child: Container(
            width: double.infinity,
            height: 58.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.8),
                  luxury.gold.withValues(alpha: 0.6),
                ],
                stops: const [0.0, 0.6, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: luxury.gold.withValues(alpha: 0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: glowOpacity),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: luxury.gold.withValues(alpha: glowOpacity * 0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 6),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          text,
                          style: GoogleFonts.montserrat(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 20.sp,
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

  void _showError(String message) {
    final colorScheme = Theme.of(context).colorScheme;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        margin: EdgeInsets.all(16.w),
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