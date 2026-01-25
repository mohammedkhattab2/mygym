import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';

/// Luxury Status and Crowd Level Display
///
/// Features premium gradient badges with glow effects
/// for open/closed status and crowd level indicators.
class BuildStatusAndCrowd extends StatelessWidget {
  final Gym gym;
  const BuildStatusAndCrowd({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final crowdPercentage = gym.crowdPercentage;
    final crowdLevel = gym.crowdLevel;
    
    // Status configuration
    Color statusColor;
    String statusText;
    IconData statusIcon;
    List<Color> statusGradient;
    
    if (!gym.isAvailable) {
      statusColor = colorScheme.error;
      statusText = "Closed";
      statusIcon = Icons.cancel_outlined;
      statusGradient = [
        colorScheme.error.withValues(alpha: 0.2),
        colorScheme.error.withValues(alpha: 0.08),
      ];
    } else {
      statusColor = luxury.success;
      statusText = "Open Now";
      statusIcon = Icons.check_circle;
      statusGradient = [
        luxury.success.withValues(alpha: 0.2),
        luxury.success.withValues(alpha: 0.08),
      ];
    }
    
    // Crowd configuration
    Color crowdColor = colorScheme.onSurfaceVariant;
    String crowdLabel = "Not Available";
    List<Color> crowdGradient = [
      colorScheme.onSurfaceVariant.withValues(alpha: 0.15),
      colorScheme.onSurfaceVariant.withValues(alpha: 0.05),
    ];
    
    // Warning color for medium crowd
    const warningColor = Color(0xFFFFB020);
    
    if (crowdLevel == "low") {
      crowdColor = luxury.success;
      crowdLabel = "Low";
      crowdGradient = [
        luxury.success.withValues(alpha: 0.2),
        luxury.success.withValues(alpha: 0.08),
      ];
    } else if (crowdLevel == "medium") {
      crowdColor = warningColor;
      crowdLabel = "Medium";
      crowdGradient = [
        warningColor.withValues(alpha: 0.2),
        warningColor.withValues(alpha: 0.08),
      ];
    } else if (crowdLevel == "high") {
      crowdColor = colorScheme.error;
      crowdLabel = "High";
      crowdGradient = [
        colorScheme.error.withValues(alpha: 0.2),
        colorScheme.error.withValues(alpha: 0.08),
      ];
    }

    return Row(
      children: [
        // Status badge with gradient and glow
        _LuxuryStatusBadge(
          icon: statusIcon,
          text: statusText,
          color: statusColor,
          gradient: statusGradient,
        ),
        SizedBox(width: 12.w),
        
        // Crowd level badge
        if (crowdLevel != null || crowdPercentage != null)
          _LuxuryStatusBadge(
            icon: Icons.people_alt_rounded,
            text: crowdPercentage != null
                ? '$crowdLabel • $crowdPercentage%'
                : crowdLabel,
            color: crowdColor,
            gradient: crowdGradient,
          ),
      ],
    );
  }
}

/// Premium status badge with gradient background and subtle glow
class _LuxuryStatusBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final List<Color> gradient;

  const _LuxuryStatusBadge({
    required this.icon,
    required this.text,
    required this.color,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
