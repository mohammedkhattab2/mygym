import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/qr_checkin/domain/entities/qr_token.dart';
import 'package:mygym/src/features/qr_checkin/presentation/bloc/qr_checkin_cubit.dart';

/// Premium Luxury Visit History View
///
/// Features:
/// - Animated floating particles with gold accents
/// - Glowing orbs with parallax effect
/// - Premium glassmorphism visit cards
/// - Gold gradient accents and elegant typography
/// - Timeline connector design
/// - Smooth animations and press effects
class VisitHistoryView extends StatefulWidget {
  const VisitHistoryView({super.key});

  @override
  State<VisitHistoryView> createState() => _VisitHistoryViewState();
}

class _VisitHistoryViewState extends State<VisitHistoryView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  late Future<List<VisitEntry>> _futureVisits;
  
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
    _futureVisits = context.read<QrCheckinCubit>().getVisitHistory(limit: 50);
    
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
        speed: 0.07 + random.nextDouble() * 0.15,
        opacity: 0.05 + random.nextDouble() * 0.12,
        isGold: isGold,
      );
    });
  }

  void _initAnimations() {
    _glowPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
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
                  
                  // Visit history content
                  Expanded(
                    child: FutureBuilder<List<VisitEntry>>(
                      future: _futureVisits,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return _buildLoadingState(colorScheme, luxury);
                        }
                        if (snapshot.hasError) {
                          return _buildErrorState(colorScheme);
                        }
                        final visits = snapshot.data ?? [];
                        if (visits.isEmpty) {
                          return _buildEmptyState(colorScheme, luxury);
                        }
                        return _buildVisitsList(visits);
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
        final pulseValue = 0.3 + (_glowPulseController.value * 0.2);
        final parallaxOffset = _scrollOffset * 0.2;
        
        return Stack(
          children: [
            // Top right purple glow
            Positioned(
              top: -40.h - parallaxOffset,
              right: -30.w,
              child: Container(
                width: 140.w,
                height: 140.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.12 * pulseValue),
                      colorScheme.primary.withValues(alpha: 0.03 * pulseValue),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Gold accent glow
            Positioned(
              top: 200.h - parallaxOffset * 0.5,
              left: -40.w,
              child: Container(
                width: 100.w,
                height: 100.w,
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
                  'YOUR ACTIVITY',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Visit History',
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
            'Loading history...',
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

  Widget _buildErrorState(ColorScheme colorScheme) {
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
            "Failed to load visit history",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    luxury.surfaceElevated.withValues(alpha: 0.6),
                    colorScheme.surface.withValues(alpha: 0.4),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      luxury.textTertiary,
                      luxury.gold.withValues(alpha: 0.5),
                    ],
                  ).createShader(bounds);
                },
                child: Icon(
                  Icons.history_rounded,
                  color: Colors.white,
                  size: 48.sp,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "No visits yet",
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Your gym check-in history will appear here after your first visit.",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: luxury.textTertiary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitsList(List<VisitEntry> visits) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      itemCount: visits.length,
      itemBuilder: (context, index) {
        final visit = visits[index];
        final isFirst = index == 0;
        final isLast = index == visits.length - 1;
        return _LuxuryVisitCard(
          visit: visit,
          isFirst: isFirst,
          isLast: isLast,
        );
      },
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
// LUXURY VISIT CARD
// ============================================================================

class _LuxuryVisitCard extends StatefulWidget {
  final VisitEntry visit;
  final bool isFirst;
  final bool isLast;

  const _LuxuryVisitCard({
    required this.visit,
    required this.isFirst,
    required this.isLast,
  });

  @override
  State<_LuxuryVisitCard> createState() => _LuxuryVisitCardState();
}

class _LuxuryVisitCardState extends State<_LuxuryVisitCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final checkIn = widget.visit.checkInTime;
    final checkOut = widget.visit.checkOutTime;
    final isActive = checkOut == null;
    final dateStr =
        '${checkIn.day.toString().padLeft(2, '0')}/${checkIn.month.toString().padLeft(2, '0')}/${checkIn.year}';
    final timeStr =
        '${checkIn.hour.toString().padLeft(2, '0')}:${checkIn.minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            SizedBox(
              width: 30.w,
              child: Column(
                children: [
                  if (!widget.isFirst)
                    Container(
                      width: 2,
                      height: 10.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            luxury.gold.withValues(alpha: 0.1),
                            luxury.gold.withValues(alpha: 0.3),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isActive
                            ? [luxury.success, luxury.success.withValues(alpha: 0.7)]
                            : [luxury.gold, luxury.goldLight],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isActive ? luxury.success : luxury.gold)
                              .withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  if (!widget.isLast)
                    Container(
                      width: 2,
                      height: 80.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            luxury.gold.withValues(alpha: 0.3),
                            luxury.gold.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 14.w),
            
            // Visit card
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 14.h),
                padding: EdgeInsets.all(16.w),
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
                    color: isActive
                        ? luxury.success.withValues(alpha: 0.3)
                        : luxury.gold.withValues(alpha: 0.1),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gym avatar
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.2),
                            luxury.gold.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: luxury.gold.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              colors: [colorScheme.primary, luxury.gold],
                            ).createShader(bounds);
                          },
                          child: Text(
                            widget.visit.gymName.isNotEmpty
                                ? widget.visit.gymName[0].toUpperCase()
                                : "G",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    
                    // Visit details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.visit.gymName,
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              // Status badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isActive
                                        ? [
                                            luxury.success.withValues(alpha: 0.2),
                                            luxury.success.withValues(alpha: 0.1),
                                          ]
                                        : [
                                            colorScheme.surface,
                                            colorScheme.surface,
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isActive
                                        ? luxury.success.withValues(alpha: 0.3)
                                        : colorScheme.outline.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  isActive ? 'Active' : 'Done',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isActive
                                        ? luxury.success
                                        : luxury.textTertiary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          
                          // Date and time
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 12.sp,
                                color: luxury.textTertiary,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '$dateStr • $timeStr',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          
                          // Duration
                          Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 12.sp,
                                color: luxury.textTertiary,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'Duration: ${widget.visit.formattedDuration}',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          
                          // Remaining visits
                          if (widget.visit.visitsAfter != null) ...[
                            SizedBox(height: 6.h),
                            Row(
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) {
                                    return LinearGradient(
                                      colors: [luxury.gold, luxury.goldLight],
                                    ).createShader(bounds);
                                  },
                                  child: Icon(
                                    Icons.confirmation_number_rounded,
                                    size: 12.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  '${widget.visit.visitsAfter} visits remaining',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: luxury.gold,
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
              ),
            ),
          ],
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
