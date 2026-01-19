import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Splash Screen - Premium Dark Design
/// 
/// Features:
/// - Animated logo with glow effect
/// - Gradient background
/// - Smooth fade and scale animations
/// - Auto-navigation after delay
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _dotsController;
  
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
    _navigateAfterDelay();
  }

  void _initAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    
    // Text animation controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );
    
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );
    
    // Dots animation controller
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  void _startAnimations() {
    _logoController.forward();
    
    // Start text animation after logo
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _textController.forward();
      }
    });
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        // TODO: Check if user is logged in and has completed onboarding
        // For now, always go to onboarding
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(AppTheme.darkSystemUiOverlayStyle);
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F1A),
              Color(0xFF1A1A2E),
              Color(0xFF0F0F1A),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background glow effect
            _buildBackgroundGlow(),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  
                  // Logo
                  _buildLogo(),
                  
                  SizedBox(height: 32.h),
                  
                  // App name and tagline
                  _buildText(),
                  
                  const Spacer(flex: 2),
                  
                  // Loading dots
                  _buildLoadingDots(),
                  
                  SizedBox(height: 48.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundGlow() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.25,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _logoController,
        builder: (context, child) {
          return Opacity(
            opacity: _logoFadeAnimation.value * 0.6,
            child: Container(
              height: 300.h,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha:  0.3),
                    AppColors.primary.withValues(alpha:  0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _logoFadeAnimation,
          child: ScaleTransition(
            scale: _logoScaleAnimation,
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(32.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGlow,
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha:  0.3),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.fitness_center_rounded,
                  size: 56.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _textFadeAnimation,
          child: SlideTransition(
            position: _textSlideAnimation,
            child: Column(
              children: [
                // App name with gradient
                ShaderMask(
                  shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    'MyGym',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                
                SizedBox(height: 12.h),
                
                // Tagline
                Text(
                  'Your Fitness Journey Starts Here',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondaryDark,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingDots() {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animValue = ((_dotsController.value - delay) % 1.0).clamp(0.0, 1.0);
            final scale = 0.5 + (0.5 * (1 - (2 * animValue - 1).abs()));
            final opacity = 0.3 + (0.7 * (1 - (2 * animValue - 1).abs()));
            
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}