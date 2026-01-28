import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/widgets/luxury_gym_card.dart';
import 'package:mygym/src/core/theme/widgets/luxury_section_header.dart';
import 'package:mygym/src/features/home/data/datasources/home_dummy_data_source.dart';
import 'package:mygym/src/features/home/domain/entities/gym_entity.dart';

/// Compact Luxury Nearby Gyms Section
///
/// Features:
/// - Clean section header
/// - Compact gym cards
/// - Horizontal scrollable list
/// - Optimized spacing
/// - Full Light/Dark mode compliance
/// - NO animations, NO glow
class BuildNearbyGyms extends StatelessWidget {
  const BuildNearbyGyms({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section header
        LuxurySectionHeader(
          title: 'Nearby Gyms',
          subtitle: 'Fitness spots around you',
          onSeeAllTap: () => _onSeeAllGyms(context),
        ),
        SizedBox(height: 12.h),
        // Compact gym cards list
        SizedBox(
          height: 175.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            itemCount: HomeDummyDataSource.gyms.length,
            itemBuilder: (itemContext, index) {
              final gym = HomeDummyDataSource.gyms[index];
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: LuxuryGymCard(
                  id: gym.id,
                  name: gym.name,
                  emoji: gym.emoji,
                  location: gym.location,
                  rating: gym.rating,
                  distance: gym.distance,
                  isPremium: index == 0,
                  size: LuxuryGymCardSize.medium,
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
    context.push(RoutePaths.gymsList);
  }

  void _onGymTap(BuildContext context, GymEntity gym) {
    context.push('${RoutePaths.gyms}/${gym.id}');
  }
}
