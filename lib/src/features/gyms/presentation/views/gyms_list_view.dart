import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/core/theme/widgets/luxury_gym_list_card.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';
import 'package:mygym/src/features/gyms/presentation/bloc/gyms_bloc.dart';

/// Premium Luxury Gyms List View
///
/// Features:
/// - Static decorative glowing orbs with gold accents
/// - Premium glassmorphism gym cards
/// - Elegant typography with Google Fonts
/// - Gold gradient accents
/// - Full Light/Dark mode compliance
/// - No animations
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
      final bloc = context.read<GymsBloc>();
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          bloc.state.hasMore &&
          bloc.state.status != GymsStatus.loadingMore &&
          bloc.state.status != GymsStatus.loading) {
        bloc.add(const GymsEvent.loadMore());
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
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Set system UI overlay style based on theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withValues(alpha: 0.95),
              luxury.surfaceElevated,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Custom luxury app bar
                  _buildLuxuryAppBar(colorScheme, luxury),
                  
                  // Gyms list
                  Expanded(
                    child: BlocBuilder<GymsBloc, GymsState>(
                      builder: (context, state) {
                        final isInitialLoading =
                            state.status == GymsStatus.loading && state.gyms.isEmpty;
                        final isLoadingMore = state.status == GymsStatus.loadingMore;
                        final hasError =
                            state.status == GymsStatus.failure && state.gyms.isEmpty;

                        if (isInitialLoading) {
                          return _buildLoadingState(colorScheme, luxury);
                        }
                        if (hasError) {
                          return _buildErrorState(colorScheme, state.errorMessage);
                        }
                        if (state.gyms.isEmpty) {
                          return _buildEmptyState(colorScheme, luxury);
                        }
                        return RefreshIndicator(
                          onRefresh: _onRefresh,
                          color: luxury.gold,
                          backgroundColor: luxury.surfaceElevated,
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.gyms.length + (isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= state.gyms.length) {
                                return _buildLoadMoreIndicator(luxury);
                              }
                              final gym = state.gyms[index];
                              final isFavorite = state.favoriteIds.contains(gym.id);
                              return Padding(
                                padding: EdgeInsets.only(bottom: 14.h),
                                child: LuxuryGymListCard(
                                  id: gym.id,
                                  name: gym.name,
                                  address: gym.address,
                                  rating: gym.rating,
                                  reviewCount: gym.reviewCount,
                                  formattedDistance: gym.formattedDistance,
                                  crowdLevel: gym.crowdLevel,
                                  isFavorite: isFavorite,
                                  onTap: () => _onGymTap(gym),
                                  onFavoriteTap: () {
                                    context.read<GymsBloc>().add(
                                      GymsEvent.toggleFavorite(gym.id),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLuxuryAppBar(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Back button
          _LuxuryIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 16.w),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DISCOVER',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Premium Gyms',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          // Map button
          _LuxuryIconButton(
            icon: Icons.map_rounded,
            onTap: () => context.go(RoutePaths.gymsMap),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50.w,
            height: 50.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(luxury.gold),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading gyms...',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ColorScheme colorScheme, String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.sp,
            color: colorScheme.error,
          ),
          SizedBox(height: 16.h),
          Text(
            message ?? "Failed to load gyms",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center_rounded,
            size: 48.sp,
            color: luxury.textTertiary,
          ),
          SizedBox(height: 16.h),
          Text(
            'No gyms found',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreIndicator(LuxuryThemeExtension luxury) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: SizedBox(
          width: 30.w,
          height: 30.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(luxury.gold),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LUXURY ICON BUTTON - No animations
// ============================================================================

class _LuxuryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _LuxuryIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              luxury.surfaceElevated,
              colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: luxury.gold.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: isDark ? 0.3 : 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                colorScheme.onSurface,
                luxury.gold.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Icon(
            icon,
            color: colorScheme.onSurface,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}
