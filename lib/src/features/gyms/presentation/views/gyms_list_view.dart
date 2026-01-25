import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';
import 'package:mygym/src/features/gyms/presentation/bloc/gyms_bloc.dart';

/// Premium Luxury Gyms List View
///
/// Features:
/// - Animated floating particles with gold accents
/// - Multiple layered glowing orbs
/// - Premium glassmorphism gym cards
/// - Elegant typography with Google Fonts
/// - Gold gradient accents
/// - Smooth animations
class GymsListView extends StatefulWidget {
  const GymsListView({super.key});

  @override
  State<GymsListView> createState() => _GymsListViewState();
}

class _GymsListViewState extends State<GymsListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  
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
      final bloc = context.read<GymsBloc>();
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          bloc.state.hasMore &&
          bloc.state.status != GymsStatus.loadingMore &&
          bloc.state.status != GymsStatus.loading) {
        bloc.add(const GymsEvent.loadMore());
      }
    });
  }

  void _setSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: context.isDarkMode ? Brightness.light : Brightness.dark,
        statusBarBrightness: context.isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
  }

  void _initParticles() {
    final random = math.Random();
    _particles = List.generate(15, (index) {
      final isGold = index % 4 == 0;
      return _Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 2 + random.nextDouble() * 3,
        speed: 0.08 + random.nextDouble() * 0.2,
        opacity: 0.08 + random.nextDouble() * 0.2,
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

  Future<void> _onRefresh() async {
    context.read<GymsBloc>().add(const GymsEvent.loadGyms(refresh: true));
  }

  void _onGymTap(Gym gym) {
    context.go('${RoutePaths.gyms}/${gym.id}');
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
            
            // Glowing orbs
            _buildGlowingOrbs(colorScheme, luxury),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Custom luxury app bar
                  _buildLuxuryAppBar(colorScheme, luxury),
                  
                  // Gyms list
                  Expanded(
                    child: BlocBuilder<GymsBloc, GymsState>(
                      builder: (context, state) {
                        final isInitialLoading =
                            state.status == GymsStatus.loading && state.gyms.isEmpty;
                        final isLoadingMore = state.status == GymsStatus.loadingMore;
                        final hasError =
                            state.status == GymsStatus.failure && state.gyms.isEmpty;

                        if (isInitialLoading) {
                          return _buildLoadingState(colorScheme, luxury);
                        }
                        if (hasError) {
                          return _buildErrorState(colorScheme, state.errorMessage);
                        }
                        if (state.gyms.isEmpty) {
                          return _buildEmptyState(colorScheme, luxury);
                        }
                        return RefreshIndicator(
                          onRefresh: _onRefresh,
                          color: luxury.gold,
                          backgroundColor: luxury.surfaceElevated,
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.gyms.length + (isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= state.gyms.length) {
                                return _buildLoadMoreIndicator(luxury);
                              }
                              final gym = state.gyms[index];
                              final isFavorite = state.favoriteIds.contains(gym.id);
                              return Padding(
                                padding: EdgeInsets.only(bottom: 14.h),
                                child: _LuxuryGymCard(
                                  gym: gym,
                                  isFavorite: isFavorite,
                                  onTap: () => _onGymTap(gym),
                                  onFavoriteTap: () {
                                    context.read<GymsBloc>().add(
                                      GymsEvent.toggleFavorite(gym.id),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
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
        final pulseValue = 0.3 + (_glowPulseController.value * 0.25);
        
        return Stack(
          children: [
            // Top right purple glow
            Positioned(
              top: -60.h,
              right: -40.w,
              child: Container(
                width: 180.w,
                height: 180.w,
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
            // Top left gold glow
            Positioned(
              top: -30.h,
              left: -30.w,
              child: Container(
                width: 120.w,
                height: 120.w,
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
                  'DISCOVER',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Premium Gyms',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          // Map button
          _LuxuryIconButton(
            icon: Icons.map_rounded,
            onTap: () => context.go(RoutePaths.gymsMap),
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
            width: 50.w,
            height: 50.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(luxury.gold),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading gyms...',
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

  Widget _buildErrorState(ColorScheme colorScheme, String? message) {
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
            message ?? "Failed to load gyms",
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

  Widget _buildEmptyState(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center_rounded,
            size: 48.sp,
            color: luxury.textTertiary,
          ),
          SizedBox(height: 16.h),
          Text(
            'No gyms found',
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

  Widget _buildLoadMoreIndicator(LuxuryThemeExtension luxury) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: SizedBox(
          width: 30.w,
          height: 30.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(luxury.gold),
          ),
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
// LUXURY GYM CARD
// ============================================================================

class _LuxuryGymCard extends StatefulWidget {
  final Gym gym;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const _LuxuryGymCard({
    required this.gym,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  State<_LuxuryGymCard> createState() => _LuxuryGymCardState();
}

class _LuxuryGymCardState extends State<_LuxuryGymCard> {
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
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                luxury.surfaceElevated,
                colorScheme.surface,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: luxury.gold.withValues(alpha: 0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gym avatar with gradient
              Container(
                width: 58.w,
                height: 58.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.2),
                      colorScheme.secondary.withValues(alpha: 0.1),
                      luxury.gold.withValues(alpha: 0.08),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: luxury.gold.withValues(alpha: 0.15),
                    width: 1,
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
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      widget.gym.name.isNotEmpty
                          ? widget.gym.name[0].toUpperCase()
                          : "G",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              // Gym info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and distance
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.gym.name,
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.gym.formattedDistance != null) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  color: colorScheme.primary,
                                  size: 12.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  widget.gym.formattedDistance!,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 6.h),
                    // Address
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 12.sp,
                          color: luxury.textTertiary,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            widget.gym.address,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    // Rating and crowd level
                    Row(
                      children: [
                        // Gold rating
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [
                                luxury.gold,
                                luxury.goldLight,
                              ],
                            ).createShader(bounds);
                          },
                          child: Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          widget.gym.rating.toStringAsFixed(1),
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(${widget.gym.reviewCount})',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: luxury.textTertiary,
                          ),
                        ),
                        if (widget.gym.crowdLevel != null) ...[
                          SizedBox(width: 12.w),
                          Container(
                            width: 1,
                            height: 12.h,
                            color: colorScheme.outline.withValues(alpha: 0.3),
                          ),
                          SizedBox(width: 12.w),
                          Icon(
                            Icons.people_alt_rounded,
                            size: 14.sp,
                            color: luxury.textTertiary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            widget.gym.crowdLevel!,
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Favorite button
              GestureDetector(
                onTap: widget.onFavoriteTap,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: widget.isFavorite
                            ? [Colors.red, Colors.redAccent]
                            : [
                                colorScheme.onSurfaceVariant,
                                luxury.gold.withValues(alpha: 0.5),
                              ],
                      ).createShader(bounds);
                    },
                    child: Icon(
                      widget.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
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
