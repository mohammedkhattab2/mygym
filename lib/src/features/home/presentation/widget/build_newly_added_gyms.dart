import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/core/theme/widgets/luxury_gym_card.dart';
import 'package:mygym/src/core/theme/widgets/luxury_section_header.dart';
import 'package:mygym/src/features/home/data/datasources/home_dummy_data_source.dart';
import 'package:mygym/src/features/home/domain/entities/gym_entity.dart';

/// Compact Luxury Newly Added Gyms Section
///
/// Features:
/// - Compact gym cards with "NEW" badge
/// - Clean design without glow
/// - Optimized spacing
/// - Full Light/Dark mode compliance
/// - NO animations, NO glow
class BuildNewlyAddedGyms extends StatelessWidget {
  const BuildNewlyAddedGyms({super.key});

  @override
  Widget build(BuildContext context) {
    final luxury = context.luxury;
    
    // Get only the last 3 gyms as "newly added" for demo
    final newGyms = HomeDummyDataSource.gyms.take(3).toList();

    return Column(
      children: [
        // Section header with badge
        LuxurySectionHeaderWithBadge(
          title: 'Newly Added',
          badgeText: '${newGyms.length} NEW',
          badgeColor: luxury.success,
          onSeeAllTap: () => _onSeeAllGyms(context),
        ),
        SizedBox(height: 12.h),
        // Compact gym cards list
        SizedBox(
          height: 160.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            physics: const BouncingScrollPhysics(),
            itemCount: newGyms.length,
            itemBuilder: (itemContext, index) {
              final gym = newGyms[index];
              return Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: LuxuryGymCard(
                  id: gym.id,
                  name: gym.name,
                  emoji: gym.emoji,
                  location: gym.location,
                  rating: gym.rating,
                  distance: gym.distance,
                  isNew: true,
                  size: LuxuryGymCardSize.small,
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