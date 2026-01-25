import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/gyms/domain/repositories/gym_repository.dart';
import 'package:mygym/src/features/gyms/presentation/bloc/gyms_bloc.dart';
import 'package:mygym/src/features/gyms/presentation/widget/show_add_review_bottom_sheet.dart';

/// Luxury Reviews Section
///
/// Displays gym reviews in premium styled cards with
/// gold star ratings and elegant user avatars.
class BuildReviewsSection extends StatelessWidget {
  final BuildContext context;
  final GymsState state;
  const BuildReviewsSection({
    super.key,
    required this.context,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final reviewStatus = state.reviewStatus;
    final reviews = state.reviews;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with gold accent
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                    Icons.rate_review_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  "Reviews",
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            if (reviews.isNotEmpty)
              Text(
                '${reviews.length} reviews',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: luxury.textTertiary,
                ),
              ),
          ],
        ),
        SizedBox(height: 14.h),
        
        // Reviews content
        if (reviewStatus == GymsStatus.loading)
          Center(
            child: SizedBox(
              width: 30.w,
              height: 30.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(luxury.gold),
              ),
            ),
          )
        else if (reviews.isEmpty)
          _buildEmptyState(context)
        else
          Column(
            children: reviews.take(3).map((r) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _LuxuryReviewCard(review: r),
              );
            }).toList(),
          ),
        SizedBox(height: 16.h),
        
        // Add review button
        _LuxuryAddReviewButton(
          onTap: () => showAddReviewBottomSheet(context),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.surfaceElevated.withValues(alpha: 0.6),
            colorScheme.surface.withValues(alpha: 0.4),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  luxury.textTertiary,
                  luxury.gold.withValues(alpha: 0.5),
                ],
              ).createShader(bounds);
            },
            child: Icon(
              Icons.star_border_rounded,
              color: Colors.white,
              size: 40.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'No reviews yet',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Be the first to share your experience!',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: luxury.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium review card with gradient and gold stars
class _LuxuryReviewCard extends StatelessWidget {
  final GymReview review;

  const _LuxuryReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final initial = (review.userName?.isNotEmpty == true
            ? review.userName![0]
            : "U")
        .toUpperCase();
        
    return Container(
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
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User avatar with gradient
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.25),
                      luxury.gold.withValues(alpha: 0.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
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
                      ).createShader(bounds);
                    },
                    child: Text(
                      initial,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              
              // User name and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName ?? "User",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Verified Member',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: luxury.gold.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Gold star rating
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      luxury.gold.withValues(alpha: 0.15),
                      luxury.gold.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: luxury.gold.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
                        size: 14.sp,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      review.rating.toString(),
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: luxury.gold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Review comment
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              review.comment!,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Premium add review button with gradient
class _LuxuryAddReviewButton extends StatefulWidget {
  final VoidCallback onTap;

  const _LuxuryAddReviewButton({required this.onTap});

  @override
  State<_LuxuryAddReviewButton> createState() => _LuxuryAddReviewButtonState();
}

class _LuxuryAddReviewButtonState extends State<_LuxuryAddReviewButton> {
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
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.15),
                luxury.gold.withValues(alpha: 0.08),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      colorScheme.primary,
                      luxury.gold,
                    ],
                  ).createShader(bounds);
                },
                child: Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      colorScheme.primary,
                      luxury.gold,
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  'Write a Review',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
