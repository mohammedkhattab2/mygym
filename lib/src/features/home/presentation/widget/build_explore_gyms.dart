import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/widgets/luxury_gym_card.dart';
import 'package:mygym/src/core/theme/widgets/luxury_section_header.dart';
import 'package:mygym/src/features/home/data/datasources/home_dummy_data_source.dart';
import 'package:mygym/src/features/home/domain/entities/gym_entity.dart';

/// Premium Luxury Explore Gyms Section
///
/// Features:
/// - Large luxury gym cards for exploration
/// - Cinematic presentation
/// - Premium spacing and layout
/// - Full Light/Dark mode compliance
/// - NO animations
class BuildExploreGyms extends StatelessWidget {
  const BuildExploreGyms({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section header
        LuxurySectionHeader(
          title: 'Explore Gyms & Facilities',
          subtitle: 'Premium fitness destinations',
          onSeeAllTap: () => _onSeeAllGyms(context),
        ),
        SizedBox(height: 16.h),
        // Large gym cards list - horizontal scroll
        SizedBox(
          height: 350.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            physics: const BouncingScrollPhysics(),
            itemCount: HomeDummyDataSource.gyms.length,
            itemBuilder: (itemContext, index) {
              final gym = HomeDummyDataSource.gyms[index];
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: LuxuryGymCard(
                  id: gym.id,
                  name: gym.name,
                  emoji: gym.emoji,
                  location: gym.location,
                  rating: gym.rating,
                  distance: gym.distance,
                  isPremium: true,
                  size: LuxuryGymCardSize.large,
                  onTap: () => _onGymTap(itemContext, gym),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onSeeAllGyms(BuildContext context) {
    context.go(RoutePaths.gymsList);
  }

  void _onGymTap(BuildContext context, GymEntity gym) {
    context.go('${RoutePaths.gyms}/${gym.id}');
  }
}