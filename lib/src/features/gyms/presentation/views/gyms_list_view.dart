import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';
import 'package:mygym/src/features/gyms/presentation/bloc/gyms_bloc.dart';

class GymsListView extends StatefulWidget {
  const GymsListView({super.key});

  @override
  State<GymsListView> createState() => _GymsListViewState();
}

class _GymsListViewState extends State<GymsListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final bolc = context.read<GymsBloc>();
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          bolc.state.hasMore &&
          bolc.state.status != GymsStatus.loadingMore &&
          bolc.state.status != GymsStatus.loading) {
        bolc.add(const GymsEvent.loadMore());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text(
          "Gyms",
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded),
            color: AppColors.textPrimaryDark,
            onPressed: (){
              context.go(RoutePaths.gymsMap);
            }, 
            
            )
        ],
      ),
      body: BlocBuilder<GymsBloc, GymsState>(
        builder: (context, state) {
          final isInitialLoading =
              state.status == GymsStatus.loading && state.gyms.isEmpty;
          final isLoadingMore = state.status == GymsStatus.loadingMore;
          final hasError =
              state.status == GymsStatus.failure && state.gyms.isEmpty;

          if (isInitialLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (hasError) {
            return Center(
              child: Text(
                state.errorMessage ?? " Faild to load gyms",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          if (state.gyms.isEmpty) {
            return const Center(child: Text("No gyms found"));
          }
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              itemCount: state.gyms.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.gyms.length) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                final gym = state.gyms[index];
                final isFavorite = state.favoriteIds.contains(gym.id);
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _buildGymListIem(context, gym, isFavorite),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget? _buildGymListIem(BuildContext context, Gym gym, bool isFavorite) {
    return GestureDetector(
      onTap: () => _onGymTap(gym),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  gym.name.isNotEmpty ? gym.name[0].toUpperCase() : "G",
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          gym.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textPrimaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (gym.formattedDistance != null) ...[
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.location_on_rounded,
                          color: AppColors.primary,
                          size: 16.sp,
                        ),
                        Text(
                          gym.formattedDistance!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    gym.address,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: AppColors.warning,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        gym.rating.toStringAsFixed(1),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '(${gym.reviewCount})',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      if (gym.crowdLevel != null)
                        Row(
                          children: [
                            Icon(
                              Icons.people_alt_rounded,
                              size: 14.sp,
                              color: AppColors.textSecondaryDark,
                            ),
                            SizedBox(width: 14.w),
                            Text(
                              gym.crowdLevel!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondaryDark,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<GymsBloc>().add(GymsEvent.toggleFavorite(gym.id));
              },
              icon: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border,
                color: isFavorite ? Colors.red : AppColors.textSecondaryDark,
                size: 22.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
