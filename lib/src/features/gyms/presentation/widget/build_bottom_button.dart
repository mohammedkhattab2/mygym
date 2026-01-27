import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/auth/domain/entities/user.dart';
import 'package:mygym/src/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mygym/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';
import 'package:go_router/go_router.dart';

/// Luxury Bottom Action Button
///
/// Premium check-in button with gradient background,
/// gold accents, and elegant styling - no animations.
class BuildBottomButton extends StatelessWidget {
  final BuildContext context;
  final Gym gym;
  const BuildBottomButton({
    super.key,
    required this.context,
    required this.gym,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface.withValues(alpha: 0.0),
            colorScheme.surface.withValues(alpha: 0.9),
            colorScheme.surface,
          ],
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
      child: SafeArea(
        top: false,
        child: BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (prev, curr) =>
              prev.user?.subscriptionStatus != curr.user?.subscriptionStatus ||
              prev.user?.remainingVisits != curr.user?.remainingVisits,
          builder: (context, AuthState) {
            final user = AuthState.user;
            final hasActiveSubscription = _hasActiveSubscription(user);

            if (hasActiveSubscription) {
              return _checkInButton(gym: gym);
            } else {
              return _SubscriptionButton();
            }
          },
        ),
      ),
    );
  }

  bool _hasActiveSubscription(dynamic user) {
    if (user == null) return false;

    final status = user.subscriptionStatus?.toLowerCase() ?? '';
    final remainingVisits = user.remainingVisits;

    final hasValidStatus =
        status.isNotEmpty &&
        !status.contains('no active') &&
        !status.contains('expired');
    final hasVisits = remainingVisits == null || remainingVisits > 0;
    return hasValidStatus && hasVisits;
  }
}

class _checkInButton extends StatelessWidget {
  final Gym gym;
  const _checkInButton({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.go(RoutePaths.qr),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
              colorScheme.primary.withValues(alpha: 0.9)
            ],
            stops:  const [0.0, 0.5, 1.0],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: luxury.gold.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: luxury.gold.withValues(alpha: isDark? 0.15 : 0.1),
                blurRadius: 30,
                offset: const Offset(0, 12),
                spreadRadius: -6,
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10.r)
              ),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: colorScheme.onPrimary,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 14.w,),
            Text(
              "Check In Now",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimary,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: 8.w,),
            Icon(
              Icons.arrow_forward_rounded,
              color: colorScheme.onPrimary.withValues(alpha: 0.8),
              size: 18.sp,
            )

          ],
        ),
      ),
    ) ;
  }
}

class _SubscriptionButton extends StatelessWidget {
  const _SubscriptionButton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.push('/member/subscriptions/bundles'),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              luxury.gold,
              luxury.goldLight,
              luxury.gold.withValues(alpha: 0.9),
            ],
            stops: const [0.0, 0.5, 1.0],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: luxury.goldLight.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: luxury.gold.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: luxury.goldLight.withValues(alpha: isDark? 0.2 : 0.15),
                blurRadius: 30,
                offset: const Offset(0, 12),
                spreadRadius: -6,
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.workspace_premium_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 14.w,),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Subscribe to Check-in",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "Get access to this gym",
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.8),

                  ),

                )
              ],
            ),
            SizedBox(width: 16.w,),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white.withValues(alpha: 0.8),
              size: 18.sp,
            )
          ],
        ),
      ),
    );
  }
}
