import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/auth/domain/entities/user.dart';
import 'package:mygym/src/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mygym/src/features/auth/presentation/bloc/auth_state.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == AuthStatus.unauthenticated) {
            return _buildUnauthenticated(context);
          }
          if (state.hasError) {
            return _buildError(context, state.errorMessage);
          }
          final user = state.user;
          if (user == null) {
            return _buildError(context, "User data not available");
          }
          return _buildContent(context, user);
        },
      ),
    );
  }

  Widget _buildUnauthenticated(BuildContext context) {
    return Center(
      child: Text(
        "You are not logged in",
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String? message) {
    return Center(
      child: Text(
        message ?? " Faild to load profile details",
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContent(BuildContext context, User user) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(user),
          SizedBox(height: 24.h),
          _buildSubscriptionSection(user),
          SizedBox(height: 24.h),
          _buildQuickActions(context),
          SizedBox(height: 24.h),
          _buildSettingsSection(context),
          SizedBox(height: 24.h),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(User user) {
    final displayName = user.displayName ?? user.email.split('@').first;
    final initial = (displayName.isNotEmpty ? displayName[0] : "U")
        .toUpperCase();
    return Row(
      children: [
        CircleAvatar(
          radius: 31.r,
          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
          child: Text(
            initial,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                user.email,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (user.selectedCity != null) ...[
                SizedBox(height: 4.h),
                Text(
                  user.selectedCity!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionSection(User user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Subscription",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            user.subscriptionStatus ?? "No active subscription",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          if (user.remainingVisits != null) ...[
            SizedBox(height: 4.h),
            Text(
              'Remaining visits: ${user.remainingVisits}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
          ],
          if (user.points > 0) ...[
            SizedBox(height: 4.h),
            Text(
              'Points: ${user.points}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My Activity",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.history_rounded, color: AppColors.primary),
                title: Text(
                  "Visit History",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                subtitle: Text(
                  'See your previous check-ins',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                onTap: () => context.go(RoutePaths.history),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(
                  Icons.card_giftcard_rounded,
                  color: AppColors.primary,
                ),
                title: Text(
                  'Rewards & Points',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                subtitle: Text(
                  'View your rewards and referral code',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                onTap: () => context.go(RoutePaths.rewardsList),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Account",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_rounded, color: AppColors.primary),
                title:  Text(
                  "Edit Profile",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                  
                    ),
                onTap: () {
                  context.go(RoutePaths.profileEdit);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings_rounded,
                  color: AppColors.primary,
                ),
                title: Text(
                  "Settings",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                onTap: () => context.go(RoutePaths.settings),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          context.read<AuthCubit>().signOut();
        },
        icon: Icon(Icons.logout_rounded, color: AppColors.error),
        label: Text(
          "Sign Out",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
