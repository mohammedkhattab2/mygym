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
import 'package:mygym/src/features/gyms/presentation/widget/build_about_section.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_bottom_button.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_contact_info.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_facilities.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_reviews_section.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_status_and_crowd.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_title_section.dart';
import 'package:mygym/src/features/gyms/presentation/widget/build_working_hours.dart';
import 'package:mygym/src/features/gyms/presentation/widget/circule_icon_button.dart';

class GymDetailsView extends StatelessWidget {
  final String gymId;
  const GymDetailsView({super.key, required this.gymId});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(AppTheme.darkSystemUiOverlayStyle);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0A14), Color(0xFF0F0F1A)],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<GymsBloc, GymsState>(
            builder: (context, state) {
              final detailStatus = state.detailStatus;
              final gym = state.selectedGym;

              if (detailStatus == GymsStatus.loading || gym == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (detailStatus == GymsStatus.failure) {
                return _buildError(state.errorMessage);
              }
              final isFavorite = state.favoriteIds.contains(gym.id);

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeaderImage(context, gym, isFavorite),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BuildTitleSection(gym: gym),
                                SizedBox(height: 16.h),
                                BuildStatusAndCrowd(gym: gym),
                                SizedBox(height: 16.h),
                                BuildFacilities(gym: gym),
                                SizedBox(height: 24.h),
                                BuildAboutSection(gym: gym),
                                SizedBox(height: 24.h),
                                BuildWorkingHours(gym: gym),
                                SizedBox(height: 24.h),
                                BuildContactInfo(gym: gym),
                                SizedBox(height: 24.h),
                                BuildReviewsSection(context: context, state: state),
                                SizedBox(height: 24.h),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                     BuildBottomButton(context: context, gym: gym)
                ],
              );
            },
          ),
        ),
      ),
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

  Widget _buildHeaderImage(BuildContext context, Gym gym, bool isFavorite) {
    final heroLetter = gym.name.isNotEmpty ? gym.name[0].toUpperCase() : "G";
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
          child: Center(
            child: Text(
              heroLetter,
              style: TextStyle(
                fontSize: 72.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),
        ),
        Positioned(
          top: 16.h,
          left: 16.w,
          right: 16.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CirculeIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
              CirculeIconButton(
                icon: isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconColor: isFavorite ? Colors.red : Colors.white,
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
}
