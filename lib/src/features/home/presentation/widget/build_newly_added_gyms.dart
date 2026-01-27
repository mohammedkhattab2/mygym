import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/core/theme/widgets/luxury_gym_card.dart';
import 'package:mygym/src/core/theme/widgets/luxury_section_header.dart';
import 'package:mygym/src/features/home/data/datasources/home_dummy_data_source.dart';
import 'package:mygym/src/features/home/domain/entities/gym_entity.dart';

/// Premium Luxury Newly Added Gyms Section
///
/// Features:
/// - Unified luxury gym cards with "NEW" badge
/// - Subtle distinction through badge styling
/// - Same premium design system
/// - Full Light/Dark mode compliance
/// - NO animations
class BuildNewlyAddedGyms extends StatelessWidget {
  const BuildNewlyAddedGyms({super.key});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    
    // Get only the last 2 gyms as "newly added" for demo
    final newGyms = HomeDummyDataSource.gyms.take(2).toList();

    return Column(
      children: [
        // Section header with badge
        LuxurySectionHeaderWithBadge(
          title: 'Newly Added',
          badgeText: '${newGyms.length} NEW',
          badgeColor: luxury.success,
          onSeeAllTap: () => _onSeeAllGyms(context),
        ),
        SizedBox(height: 16.h),
        // Gym cards list - horizontal scroll with medium cards
        SizedBox(
          height: 290.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            physics: const BouncingScrollPhysics(),
            itemCount: newGyms.length,
            itemBuilder: (itemContext, index) {
              final gym = newGyms[index];
              return Padding(
                padding: EdgeInsets.only(right: 14.w),
                child: LuxuryGymCard(
                  id: gym.id,
                  name: gym.name,
                  emoji: gym.emoji,
                  location: gym.location,
                  rating: gym.rating,
                  distance: gym.distance,
                  isNew: true,
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