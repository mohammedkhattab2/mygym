import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';

/// Luxury Facilities Section
///
/// Displays gym facilities as premium gradient chips
/// with gold accents and elegant typography.
class BuildFacilities extends StatelessWidget {
  final Gym gym;
  const BuildFacilities({super.key, required this.gym});

  // Map facility names to appropriate icons
  IconData _getFacilityIcon(String facility) {
    final lower = facility.toLowerCase();
    if (lower.contains('pool') || lower.contains('swim')) {
      return Icons.pool_rounded;
    } else if (lower.contains('sauna') || lower.contains('steam')) {
      return Icons.hot_tub_rounded;
    } else if (lower.contains('parking')) {
      return Icons.local_parking_rounded;
    } else if (lower.contains('wifi') || lower.contains('internet')) {
      return Icons.wifi_rounded;
    } else if (lower.contains('locker')) {
      return Icons.lock_rounded;
    } else if (lower.contains('shower')) {
      return Icons.shower_rounded;
    } else if (lower.contains('cafe') || lower.contains('juice')) {
      return Icons.local_cafe_rounded;
    } else if (lower.contains('towel')) {
      return Icons.dry_cleaning_rounded;
    } else if (lower.contains('trainer') || lower.contains('personal')) {
      return Icons.person_rounded;
    } else if (lower.contains('class') || lower.contains('group')) {
      return Icons.groups_rounded;
    } else if (lower.contains('yoga') || lower.contains('pilates')) {
      return Icons.self_improvement_rounded;
    } else if (lower.contains('cardio')) {
      return Icons.monitor_heart_rounded;
    } else if (lower.contains('weight') || lower.contains('strength')) {
      return Icons.fitness_center_rounded;
    } else if (lower.contains('spa') || lower.contains('massage')) {
      return Icons.spa_rounded;
    } else if (lower.contains('air') || lower.contains('ac')) {
      return Icons.ac_unit_rounded;
    }
    return Icons.check_circle_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    if (gym.facilities.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with gold accent
        Row(
          children: [
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
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "Facilities",
              style: GoogleFonts.montserrat(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        
        // Facilities chips
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: gym.facilities.map((facility) {
            return _LuxuryFacilityChip(
              label: facility,
              icon: _getFacilityIcon(facility),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Premium facility chip with gradient and icon
class _LuxuryFacilityChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _LuxuryFacilityChip({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.surfaceElevated,
            colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  colorScheme.primary,
                  luxury.gold.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Icon(
              icon,
              color: Colors.white,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
