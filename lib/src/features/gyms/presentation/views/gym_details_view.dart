import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/core/theme/app_theme.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';
import 'package:mygym/src/features/gyms/presentation/bloc/gyms_bloc.dart';

class GymDetailsView extends StatelessWidget {
  final String gymId;
  const GymDetailsView({super.key, required this.gymId});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(AppTheme.darkSystemUiOverlayStyle);
    return BlocBuilder<GymsBloc, GymsState>(
      builder: (context, state) {
        final isloading = state.detailStatus == GymsStatus.loading;
        final hasError = state.detailStatus == GymsStatus.failure;
        final gym = state.selectedGym;
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0A0A14), Color(0xFF0F0F1A)],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: isloading
                        ? const Center(child: CircularProgressIndicator())
                        : hasError
                        ? _buildError(state.errorMessage)
                        : gym == null
                        ? const Center(child: Text('Gym not found'))
                        : _buildcontent(context, state, gym),
                  ),
                  if (!isloading && !hasError && gym != null)
                    _buildBottomButton(context, gym),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildError(String? message) {
    return Center(
      child: Text(
        message ?? "Failed to load gym details",
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, Gym gym) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(top: BorderSide(color: AppColors.borderDark)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            context.go(RoutePaths.qr);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Text(
            " Check In",
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildcontent(BuildContext context, GymsState state, Gym gym) {
    final isFavorite = state.favoriteIds.contains(gym.id);
    final reviews = state.reviews;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleSection(context, gym, isFavorite),
          SizedBox(height: 16.h),
          // _buildAmenities(gym),
          SizedBox(height: 24.h),
          // _buildAboutSection(gym),
          SizedBox(height: 24.h),
          // _buildOpeningHours(gym),
          SizedBox(height: 24.h),
          // _buildReviewsSection(context, state, reviews),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, Gym gym, bool isfavorite) {
    return Stack(
      children: [
        Container(
          height: 220.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.4),
                AppColors.secondary.withValues(alpha: 0.4),
              ],
            ),
          ),
          child: Center(child: Icon(Icons.fitness_center, size: 64.sp)),
        ),
        Positioned(
          top: 16.h,
          left: 16.w,
          right: 16.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _circularButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
              _circularButton(
                icon: isfavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconColor: isfavorite ? Colors.red : Colors.white,
                onTap: () {
                  context.read<GymsBloc>().add(
                    GymsEvent.toggleFavorite(gym.id),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circularButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: iconColor, size: 16.sp),
      ),
    );
  }
}
