import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/auth/domain/entities/user.dart';
import 'package:mygym/src/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mygym/src/features/auth/presentation/bloc/auth_state.dart';

/// Premium Luxury Profile View
///
/// Features:
/// - Static layered glowing orbs background
/// - Premium glassmorphism profile card
/// - Gold gradient accents and elegant typography
/// - Full Light/Dark mode compliance
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  void _setSystemUI(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _setSystemUI(context);
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Navigate to login when user signs out
        if (state.status == AuthStatus.unauthenticated) {
          context.go(RoutePaths.login);
        }
      },
      child: Scaffold(
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
                    // Custom app bar
                    _buildLuxuryAppBar(colorScheme, luxury),

                    // Profile content
                    Expanded(
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if (state.status == AuthStatus.loading) {
                            return _buildLoadingState(colorScheme, luxury);
                          }
                          if (state.status == AuthStatus.unauthenticated) {
                            return _buildUnauthenticated(
                              context,
                              colorScheme,
                              luxury,
                            );
                          }
                          if (state.hasError) {
                            return _buildError(
                              context,
                              colorScheme,
                              state.errorMessage,
                            );
                          }
                          final user = state.user;
                          if (user == null) {
                            return _buildError(
                              context,
                              colorScheme,
                              "User data not available",
                            );
                          }
                          return _buildContent(
                            context,
                            user,
                            colorScheme,
                            luxury,
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
      ),
    );
  }

  Widget _buildLuxuryAppBar(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Back button - navigate to home instead of pop
          _LuxuryIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => context.go(RoutePaths.memberHome),
          ),
          SizedBox(width: 16.w),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MY PROFILE',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Account',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(luxury.gold),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading profile...',
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

  Widget _buildUnauthenticated(
    BuildContext context,
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              Icons.person_off_rounded,
              color: colorScheme.onPrimary,
              size: 48.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "You are not logged in",
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

  Widget _buildError(
    BuildContext context,
    ColorScheme colorScheme,
    String? message,
  ) {
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
            message ?? "Failed to load profile details",
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

  Widget _buildContent(
    BuildContext context,
    User user,
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHeader(user: user),
          SizedBox(height: 24.h),
          _SubscriptionCard(user: user),
          SizedBox(height: 24.h),
          _ActivitySection(),
          SizedBox(height: 24.h),
          _AccountSection(),
          SizedBox(height: 32.h),
          _LuxuryLogoutButton(onTap: () => context.read<AuthCubit>().signOut()),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

// ============================================================================
// PROFILE HEADER
// ============================================================================

class _ProfileHeader extends StatelessWidget {
  final User user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final displayName = user.displayName ?? user.email.split('@').first;
    final initial = (displayName.isNotEmpty ? displayName[0] : "U")
        .toUpperCase();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [luxury.surfaceElevated, colorScheme.surface],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with gradient
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.25),
                  luxury.gold.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: luxury.gold.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [colorScheme.primary, luxury.gold],
                  ).createShader(bounds);
                },
                child: Text(
                  initial,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 18.w),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  user.email,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (user.selectedCity != null) ...[
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 14.sp,
                        color: luxury.gold.withValues(alpha: 0.7),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        user.selectedCity!,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: luxury.gold.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SUBSCRIPTION CARD
// ============================================================================

class _SubscriptionCard extends StatelessWidget {
  final User user;

  const _SubscriptionCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    // Subscription status check - used for future conditional rendering
    final _ =
        user.subscriptionStatus != null &&
        user.subscriptionStatus!.toLowerCase() != "no active subscription";

    return GestureDetector(
      onTap: () => context.push('/member/subscriptions/bundles'),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withValues(alpha: 0.15),
              luxury.gold.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: luxury.gold.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        luxury.gold, luxury.goldLight
                      ],
                      ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    color: colorScheme.onPrimary,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 10.w,),
                Expanded(
                  child: Text(
                    "Subscription",
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                      letterSpacing: 0.5,
                    ),
                  )
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================================
// ACTIVITY SECTION
// ============================================================================

class _ActivitySection extends StatelessWidget {
  const _ActivitySection();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [luxury.gold, luxury.goldLight],
                ).createShader(bounds);
              },
              child: Icon(
                Icons.timeline_rounded,
                color: colorScheme.onPrimary,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "My Activity",
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _LuxuryMenuCard(
          items: [
            _LuxuryMenuItem(
              icon: Icons.history_rounded,
              title: "Visit History",
              subtitle: "See your previous check-ins",
              gradientColors: [colorScheme.primary, colorScheme.secondary],
              onTap: () => context.push(RoutePaths.history),
            ),
            _LuxuryMenuItem(
              icon: Icons.fitness_center_rounded,
              title: "Fitness Classes",
              subtitle: "Browse and book classes",
              gradientColors: [colorScheme.secondary, colorScheme.tertiary],
              onTap: () => context.push('/member/classes'),
            ),
            _LuxuryMenuItem(
              icon: Icons.event_available_rounded,
              title: "My Class Bookings",
              subtitle: "View your upcoming & past bookings",
              gradientColors: [Colors.teal, Colors.teal.shade300],
              onTap: () => context.push('/member/classes/bookings'),
            ),
            _LuxuryMenuItem(
              icon: Icons.card_giftcard_rounded,
              title: "Rewards & Points",
              subtitle: "View your rewards and referral code",
              gradientColors: [luxury.gold, luxury.goldLight],
              onTap:  () => context.push('/member/rewards'),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// ACCOUNT SECTION
// ============================================================================

class _AccountSection extends StatelessWidget {
  const _AccountSection();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [luxury.gold, luxury.goldLight],
                ).createShader(bounds);
              },
              child: Icon(
                Icons.person_rounded,
                color: colorScheme.onPrimary,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "Account",
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _LuxuryMenuCard(
          items: [

            _LuxuryMenuItem(
              icon: Icons.card_membership_rounded, 
              title: "Subscription Plans", 
              subtitle: "View and manage your subscription", 
              gradientColors: [luxury.gold, luxury.goldLight], 
              onTap: () => context.push('/member/subscriptions/bundles'),
              ),
            _LuxuryMenuItem(
              icon: Icons.receipt_long_rounded, 
              title: "Billing & Invoices", 
              subtitle: "View payment history", 
              gradientColors: [colorScheme.tertiary, colorScheme.secondary], 
              onTap: () => context.push('/member/subscriptions/invoices'),
              ),
            _LuxuryMenuItem(
              icon: Icons.edit_rounded,
              title: "Edit Profile",
              subtitle: "Update your personal information",
              gradientColors: [colorScheme.primary, luxury.gold],
              onTap: () => context.push(RoutePaths.profileEdit),
            ),
            _LuxuryMenuItem(
              icon: Icons.settings_rounded,
              title: "Settings",
              subtitle: "App preferences and configuration",
              gradientColors: [colorScheme.secondary, colorScheme.primary],
              onTap: () => context.push(RoutePaths.settings),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================================================
// LUXURY ICON BUTTON
// ============================================================================

class _LuxuryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _LuxuryIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [luxury.surfaceElevated, colorScheme.surface],
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
              color: colorScheme.shadow.withValues(alpha: 0.2),
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
          child: Icon(icon, color: colorScheme.onPrimary, size: 20.sp),
        ),
      ),
    );
  }
}

// ============================================================================
// LUXURY MENU CARD
// ============================================================================

class _LuxuryMenuCard extends StatelessWidget {
  final List<_LuxuryMenuItem> items;

  const _LuxuryMenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [luxury.surfaceElevated, colorScheme.surface],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: luxury.gold.withValues(alpha: 0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _LuxuryMenuItemTile(item: item),
              if (index < items.length - 1)
                Divider(
                  height: 1,
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  indent: 70.w,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _LuxuryMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  _LuxuryMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.onTap,
  });
}

class _LuxuryMenuItemTile extends StatelessWidget {
  final _LuxuryMenuItem item;

  const _LuxuryMenuItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        splashColor: luxury.gold.withValues(alpha: 0.08),
        highlightColor: luxury.gold.withValues(alpha: 0.04),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              // Icon container
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      item.gradientColors[0].withValues(alpha: 0.2),
                      item.gradientColors[1].withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: item.gradientColors[0].withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: item.gradientColors,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    item.icon,
                    color: colorScheme.onPrimary,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 14.w),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: luxury.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
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
                  Icons.arrow_forward_ios_rounded,
                  color: colorScheme.onPrimary,
                  size: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LUXURY LOGOUT BUTTON
// ============================================================================

class _LuxuryLogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LuxuryLogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          splashColor: colorScheme.error.withValues(alpha: 0.1),
          highlightColor: colorScheme.error.withValues(alpha: 0.05),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.error.withValues(alpha: 0.15),
                  colorScheme.error.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: colorScheme.error.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: colorScheme.error,
                  size: 18.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  "Sign Out",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
