import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/partner/domain/entities/partner_entities.dart';

class PeakHoursSection extends StatelessWidget {
  final List<PeakHourData> peakHours;

  const PeakHoursSection({super.key, required this.peakHours});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    if (peakHours.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: luxury.gold.withValues(alpha:  0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha:  0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.access_time_filled_rounded,
                  color: Colors.orange,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Peak Hours',
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha:  0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: luxury.gold, size: 12.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Promo Time',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Peak Hours List
          ...peakHours.map((peak) {
            final occupancyPercent = (peak.averageOccupancy * 100).toInt();

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Row(
                children: [
                  // Time Badge
                  Container(
                    width: 70.w,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primaryContainer,
                          colorScheme.primaryContainer.withValues(alpha:  0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Text(
                        peak.timeLabel,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Stats
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${peak.averageVisits.toInt()} visits avg',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getOccupancyColor(occupancyPercent)
                                    .withValues(alpha:  0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '$occupancyPercent%',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: _getOccupancyColor(occupancyPercent),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: peak.averageOccupancy,
                            minHeight: 6.h,
                            backgroundColor: colorScheme.outline.withValues(alpha:  0.15),
                            color: _getOccupancyColor(occupancyPercent),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Promo Star
                  if (peak.isRecommendedPromo) ...[
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: luxury.gold.withValues(alpha:  0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star_rounded,
                        color: luxury.gold,
                        size: 16.sp,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getOccupancyColor(int percent) {
    if (percent >= 80) return Colors.red;
    if (percent >= 60) return Colors.orange;
    if (percent >= 40) return Colors.amber;
    return Colors.green;
  }
}
