import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mygym/src/features/admin/presentation/bloc/subscription_plans_cubit.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/subscription_plan.dart';
import '../../domain/entities/admin_subscription.dart';

class AdminSubscriptionPlansView extends StatefulWidget {
  const AdminSubscriptionPlansView({super.key});

  @override
  State<AdminSubscriptionPlansView> createState() =>
      _AdminSubscriptionPlansViewState();
}

class _AdminSubscriptionPlansViewState
    extends State<AdminSubscriptionPlansView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<SubscriptionPlansCubit>().loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [
                    Color(0xFF0A0A0F),
                    Color(0xFF0F0F18),
                    Color(0xFF0A0A0F),
                  ]
                : const [
                    Color(0xFFFFFBF8),
                    Color(0xFFF8F5FF),
                    Color(0xFFFFFBF8),
                  ],
          ),
        ),
        child: Stack(
          children: [
            ..._buildBackgroundOrbs(isDark),
            BlocBuilder<SubscriptionPlansCubit, SubscriptionPlansState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () => _buildLoadingState(context),
                  error: (msg) => _buildErrorState(context, msg),
                  loaded: (plans, promotions, tab) {
                    return Column(
                      children: [
                        _buildHeader(context, plans.length, promotions.length),
                        _buildTabs(context),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _buildPlansTab(context, plans),
                              _buildPromotionsTab(context, promotions),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BACKGROUND ORBS
  // ═══════════════════════════════════════════════════════════════════════════

  List<Widget> _buildBackgroundOrbs(bool isDark) {
    return [
      Positioned(
        top: -80.r,
        right: -40.r,
        child: Container(
          width: 250.r,
          height: 250.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDark
                  ? [
                      AppColors.primary.withValues(alpha: 0.12),
                      AppColors.primary.withValues(alpha: 0.04),
                      Colors.transparent,
                    ]
                  : [
                      AppColors.primary.withValues(alpha: 0.06),
                      AppColors.primary.withValues(alpha: 0.02),
                      Colors.transparent,
                    ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 400.r,
        left: -100.r,
        child: Container(
          width: 200.r,
          height: 200.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDark
                  ? [
                      AppColors.gold.withValues(alpha: 0.1),
                      AppColors.gold.withValues(alpha: 0.03),
                      Colors.transparent,
                    ]
                  : [
                      AppColors.gold.withValues(alpha: 0.05),
                      AppColors.gold.withValues(alpha: 0.015),
                      Colors.transparent,
                    ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 100.r,
        right: -60.r,
        child: Container(
          width: 180.r,
          height: 180.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: isDark
                  ? [
                      AppColors.secondary.withValues(alpha: 0.08),
                      AppColors.secondary.withValues(alpha: 0.02),
                      Colors.transparent,
                    ]
                  : [
                      AppColors.secondary.withValues(alpha: 0.04),
                      AppColors.secondary.withValues(alpha: 0.01),
                      Colors.transparent,
                    ],
            ),
          ),
        ),
      ),
    ];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader(
      BuildContext context, int plansCount, int promosCount) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      margin: EdgeInsets.fromLTRB(16.r, 12.r, 16.r, 8.r),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 14.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withValues(alpha: 0.95),
                  const Color(0xFF312E81).withValues(alpha: 0.85),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                ],
        ),
        border: Border.all(
          color: isDark
              ? AppColors.gold.withValues(alpha: 0.25)
              : AppColors.gold.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gold.withValues(alpha: isDark ? 0.25 : 0.15),
                      AppColors.gold.withValues(alpha: isDark ? 0.1 : 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.gold
                        .withValues(alpha: isDark ? 0.4 : 0.25),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                  ).createShader(bounds),
                  child: Icon(
                    Icons.card_membership_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Title & subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: isDark
                            ? [Colors.white, const Color(0xFFE8E0FF)]
                            : [
                                const Color(0xFF1A1A2E),
                                const Color(0xFF312E81)
                              ],
                      ).createShader(bounds),
                      child: Text(
                        'Plans & Offers',
                        style: GoogleFonts.raleway(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '$plansCount Plans • $promosCount Promotions',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),

              // Refresh button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.onSurfaceVariant
                          .withValues(alpha: isDark ? 0.15 : 0.08),
                      colorScheme.onSurfaceVariant
                          .withValues(alpha: isDark ? 0.08 : 0.04),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        context.read<SubscriptionPlansCubit>().loadAll(),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.all(10.r),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                        ).createShader(bounds),
                        child: Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TABS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTabs(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withValues(alpha: 0.6),
                  const Color(0xFF312E81).withValues(alpha: 0.4),
                ]
              : [
                  Colors.white.withValues(alpha: 0.8),
                  const Color(0xFFF5F0FF).withValues(alpha: 0.6),
                ],
        ),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.gold,
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: AppColors.gold,
        unselectedLabelColor: isDark
            ? AppColors.textTertiaryDark
            : AppColors.textTertiary,
        labelStyle: GoogleFonts.inter(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.workspace_premium_rounded, size: 16.sp),
                SizedBox(width: 6.w),
                const Text('Plans'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_offer_rounded, size: 16.sp),
                SizedBox(width: 6.w),
                const Text('Promotions'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PLANS TAB
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPlansTab(BuildContext context, List<SubscriptionPlan> plans) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 900.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAddButton(
                context,
                label: 'Add New Plan',
                icon: Icons.add_rounded,
                onTap: () => _showPlanForm(context),
              ),
              SizedBox(height: 20.h),
              Wrap(
                spacing: 16.w,
                runSpacing: 16.h,
                children: plans
                    .map((plan) => _buildPlanCard(context, plan))
                    .toList(),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, SubscriptionPlan plan) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    final tierColors = {
      SubscriptionTier.basic: AppColors.grey500,
      SubscriptionTier.plus: AppColors.info,
      SubscriptionTier.premium: AppColors.gold,
    };
    final tierColor = tierColors[plan.tier]!;

    final secondaryColor = HSLColor.fromColor(tierColor)
        .withLightness(
            (HSLColor.fromColor(tierColor).lightness + 0.15).clamp(0.0, 1.0))
        .toColor();

    return Container(
      width: 320.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withValues(alpha: 0.9),
                  const Color(0xFF312E81).withValues(alpha: 0.75),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                ],
        ),
        border: Border.all(
          color: plan.isPopular
              ? tierColor.withValues(alpha: isDark ? 0.5 : 0.4)
              : tierColor.withValues(alpha: isDark ? 0.3 : 0.2),
          width: plan.isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: tierColor.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      tierColor.withValues(alpha: isDark ? 0.2 : 0.1),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        gradient: LinearGradient(
                          colors: [
                            tierColor.withValues(
                                alpha: isDark ? 0.25 : 0.15),
                            tierColor.withValues(
                                alpha: isDark ? 0.12 : 0.08),
                          ],
                        ),
                        border: Border.all(
                          color: tierColor.withValues(
                              alpha: isDark ? 0.4 : 0.25),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: tierColor.withValues(
                                alpha: isDark ? 0.2 : 0.1),
                            blurRadius: 8,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [tierColor, secondaryColor],
                        ).createShader(bounds),
                        child: Icon(
                          Icons.workspace_premium_rounded,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: isDark
                                  ? [Colors.white, const Color(0xFFE8E0FF)]
                                  : [
                                      const Color(0xFF1A1A2E),
                                      const Color(0xFF312E81)
                                    ],
                            ).createShader(bounds),
                            child: Text(
                              plan.name,
                              style: GoogleFonts.raleway(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            plan.description,
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: isDark
                                  ? AppColors.textTertiaryDark
                                  : AppColors.textTertiary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Badges
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (plan.isPopular)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  tierColor,
                                  tierColor.withValues(alpha: 0.8)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'Popular',
                              style: GoogleFonts.inter(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        SizedBox(height: 4.h),
                        _buildStatusBadge(plan.isActive),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Pricing Section
          Padding(
            padding: EdgeInsets.all(18.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRICING',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiary,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildPriceRow(context, 'Monthly', plan.monthlyPrice,
                    plan.monthlyVisitLimit, tierColor),
                SizedBox(height: 8.h),
                _buildPriceRow(context, 'Quarterly', plan.quarterlyPrice,
                    plan.quarterlyVisitLimit, tierColor),
                SizedBox(height: 8.h),
                _buildPriceRow(context, 'Yearly', plan.yearlyPrice,
                    plan.yearlyVisitLimit, tierColor),
              ],
            ),
          ),

          // Features Preview
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FEATURES (${plan.features.length})',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiary,
                  ),
                ),
                SizedBox(height: 8.h),
                ...plan.features.take(3).map(
                      (f) => Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) =>
                                  const LinearGradient(
                                colors: [
                                  Color(0xFF10B981),
                                  Color(0xFF34D399)
                                ],
                              ).createShader(bounds),
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                f,
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  color: colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                if (plan.features.length > 3)
                  Text(
                    '+${plan.features.length - 3} more',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: tierColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // Actions
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color:
                      tierColor.withValues(alpha: isDark ? 0.15 : 0.08),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    color: AppColors.info,
                    onTap: () => _showPlanForm(context, plan: plan),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: plan.isActive
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    label: plan.isActive ? 'Hide' : 'Show',
                    color:
                        plan.isActive ? AppColors.warning : AppColors.success,
                    onTap: () => context
                        .read<SubscriptionPlansCubit>()
                        .togglePlanStatus(plan.id),
                  ),
                ),
                SizedBox(width: 8.w),
                _buildIconButton(
                  context,
                  icon: Icons.delete_outline,
                  color: AppColors.error,
                  onTap: () => _showDeleteConfirmation(
                      context, plan.id, plan.name,
                      isPlan: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context, String duration, double price,
      int? visits, Color tierColor) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.02),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            duration,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Row(
            children: [
              Text(
                'EGP ${price.toStringAsFixed(0)}',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              if (visits != null) ...[
                SizedBox(width: 6.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color:
                        tierColor.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '$visits visits',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: tierColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PROMOTIONS TAB
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPromotionsTab(
      BuildContext context, List<Promotion> promotions) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 900.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAddButton(
                context,
                label: 'Create Promotion',
                icon: Icons.local_offer_rounded,
                onTap: () => _showPromotionForm(context),
              ),
              SizedBox(height: 20.h),
              ...promotions
                  .map((promo) => _buildPromotionCard(context, promo))
                  .toList(),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionCard(BuildContext context, Promotion promo) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    final typeColors = {
      PromotionType.discount: AppColors.success,
      PromotionType.flashSale: AppColors.error,
      PromotionType.seasonal: AppColors.warning,
      PromotionType.referral: AppColors.info,
      PromotionType.firstTime: AppColors.gold,
      PromotionType.renewal: AppColors.primary,
      PromotionType.bundle: AppColors.secondary,
    };
    final typeColor = typeColors[promo.type] ?? AppColors.gold;

    final secondaryColor = HSLColor.fromColor(typeColor)
        .withLightness(
            (HSLColor.fromColor(typeColor).lightness + 0.15).clamp(0.0, 1.0))
        .toColor();

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF1E1B4B).withValues(alpha: 0.9),
                  const Color(0xFF312E81).withValues(alpha: 0.75),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                ],
        ),
        border: Border.all(
          color: promo.isExpired
              ? AppColors.error.withValues(alpha: isDark ? 0.4 : 0.3)
              : typeColor.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: typeColor.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      typeColor.withValues(alpha: isDark ? 0.2 : 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: LinearGradient(
                      colors: [
                        typeColor.withValues(
                            alpha: isDark ? 0.25 : 0.15),
                        typeColor.withValues(
                            alpha: isDark ? 0.12 : 0.08),
                      ],
                    ),
                    border: Border.all(
                      color: typeColor.withValues(
                          alpha: isDark ? 0.4 : 0.25),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: typeColor.withValues(
                            alpha: isDark ? 0.2 : 0.1),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [typeColor, secondaryColor],
                    ).createShader(bounds),
                    child: Icon(
                      Icons.local_offer_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: isDark
                                    ? [
                                        Colors.white,
                                        const Color(0xFFE8E0FF)
                                      ]
                                    : [
                                        const Color(0xFF1A1A2E),
                                        const Color(0xFF312E81)
                                      ],
                              ).createShader(bounds),
                              child: Text(
                                promo.name,
                                style: GoogleFonts.raleway(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          _buildTypeBadge(promo.type, typeColor),
                        ],
                      ),
                      if (promo.description != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          promo.description!,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                // Discount Display
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        typeColor,
                        typeColor.withValues(alpha: 0.85)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color:
                            typeColor.withValues(alpha: isDark ? 0.4 : 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: Text(
                    promo.isPercentage
                        ? '${promo.discountValue.toStringAsFixed(0)}%'
                        : 'EGP ${promo.discountValue.toStringAsFixed(0)}',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: EdgeInsets.all(18.r),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildPromoDetail(
                          context, 'Promo Code', promo.promoCode ?? 'Auto'),
                    ),
                    Expanded(
                      child: _buildPromoDetail(
                        context,
                        'Valid Period',
                        '${DateFormat('MMM d').format(promo.startDate)} - ${DateFormat('MMM d').format(promo.endDate)}',
                      ),
                    ),
                    Expanded(
                      child: _buildPromoDetail(
                        context,
                        'Usage',
                        promo.usageLimit != null
                            ? '${promo.usageCount}/${promo.usageLimit}'
                            : 'Unlimited',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                // Status & Actions
                Row(
                  children: [
                    if (promo.isExpired)
                      _buildStatusChip('Expired', AppColors.error)
                    else if (promo.isNotStarted)
                      _buildStatusChip('Scheduled', AppColors.info)
                    else if (promo.isUsageLimitReached)
                      _buildStatusChip('Limit Reached', AppColors.warning)
                    else if (promo.isActive)
                      _buildStatusChip('Active', AppColors.success)
                    else
                      _buildStatusChip('Inactive', AppColors.grey500),
                    const Spacer(),
                    _buildActionButton(
                      context,
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      color: AppColors.info,
                      onTap: () =>
                          _showPromotionForm(context, promotion: promo),
                    ),
                    SizedBox(width: 8.w),
                    _buildActionButton(
                      context,
                      icon: promo.isActive
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      label: promo.isActive ? 'Pause' : 'Activate',
                      color: promo.isActive
                          ? AppColors.warning
                          : AppColors.success,
                      onTap: () => context
                          .read<SubscriptionPlansCubit>()
                          .togglePromotionStatus(promo.id),
                    ),
                    SizedBox(width: 8.w),
                    _buildIconButton(
                      context,
                      icon: Icons.delete_outline,
                      color: AppColors.error,
                      onTap: () => _showDeleteConfirmation(
                          context, promo.id, promo.name,
                          isPlan: false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoDetail(
      BuildContext context, String label, String value) {
    final isDark = context.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: isDark
                ? AppColors.textTertiaryDark
                : AppColors.textTertiary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeBadge(PromotionType type, Color color) {
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.2 : 0.12),
            color.withValues(alpha: isDark ? 0.1 : 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.3 : 0.2),
        ),
      ),
      child: Text(
        type.displayName,
        style: GoogleFonts.inter(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.15 : 0.1),
            color.withValues(alpha: isDark ? 0.08 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.35 : 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER WIDGETS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStatusBadge(bool isActive) {
    final isDark = context.isDarkMode;
    final color = isActive ? AppColors.success : AppColors.grey500;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.2 : 0.12),
            color.withValues(alpha: isDark ? 0.1 : 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.35 : 0.25),
        ),
      ),
      child: Text(
        isActive ? 'Active' : 'Hidden',
        style: GoogleFonts.inter(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAddButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFD700),
                Color(0xFFD4A574),
                Color(0xFFFFD700)
              ],
              stops: [0.0, 0.5, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold
                    .withValues(alpha: isDark ? 0.4 : 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
                spreadRadius: -4,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: isDark ? 0.15 : 0.08),
                color.withValues(alpha: isDark ? 0.08 : 0.04),
              ],
            ),
            border: Border.all(
              color: color.withValues(alpha: isDark ? 0.35 : 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ).createShader(bounds),
                child: Icon(icon, size: 14.sp, color: Colors.white),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: isDark ? 0.15 : 0.08),
                color.withValues(alpha: isDark ? 0.08 : 0.04),
              ],
            ),
            border: Border.all(
              color: color.withValues(alpha: isDark ? 0.3 : 0.2),
            ),
          ),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
            ).createShader(bounds),
            child: Icon(icon, size: 16.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOADING & ERROR STATES
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLoadingState(BuildContext context) {
    final isDark = context.isDarkMode;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.gold.withValues(alpha: isDark ? 0.2 : 0.1),
                  AppColors.gold.withValues(alpha: isDark ? 0.08 : 0.04),
                  Colors.transparent,
                ],
              ),
            ),
            child: SizedBox(
              width: 48.r,
              height: 48.r,
              child: CircularProgressIndicator(
                color: AppColors.gold,
                strokeWidth: 3,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: isDark
                  ? [Colors.white, const Color(0xFFE8E0FF)]
                  : [const Color(0xFF1A1A2E), const Color(0xFF312E81)],
            ).createShader(bounds),
            child: Text(
              'Loading plans & promotions...',
              style: GoogleFonts.raleway(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String msg) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Center(
      child: Container(
        padding: EdgeInsets.all(48.r),
        margin: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF1E1B4B).withValues(alpha: 0.9),
                    const Color(0xFF312E81).withValues(alpha: 0.75),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.95),
                    const Color(0xFFF5F0FF).withValues(alpha: 0.9),
                  ],
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: AppColors.error.withValues(alpha: isDark ? 0.3 : 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  AppColors.error.withValues(alpha: isDark ? 0.12 : 0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.error.withValues(alpha: isDark ? 0.2 : 0.1),
                    AppColors.error
                        .withValues(alpha: isDark ? 0.08 : 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppColors.error,
                    AppColors.error.withValues(alpha: 0.7)
                  ],
                ).createShader(bounds),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 40.sp,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: isDark
                    ? [Colors.white, const Color(0xFFE8E0FF)]
                    : [
                        const Color(0xFF1A1A2E),
                        const Color(0xFF312E81)
                      ],
              ).createShader(bounds),
              child: Text(
                'Something Went Wrong',
                style: GoogleFonts.raleway(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              msg,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: isDark
                    ? AppColors.textTertiaryDark
                    : AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () =>
                    context.read<SubscriptionPlansCubit>().loadAll(),
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFD700),
                        Color(0xFFD4A574),
                        Color(0xFFFFD700)
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold
                            .withValues(alpha: isDark ? 0.4 : 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh_rounded,
                          color: Colors.white, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Try Again',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DIALOGS
  // ═══════════════════════════════════════════════════════════════════════════

  void _showPlanForm(BuildContext context, {SubscriptionPlan? plan}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          plan == null ? 'Create Plan Form (Coming)' : 'Edit ${plan.name}',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showPromotionForm(BuildContext context, {Promotion? promotion}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          promotion == null
              ? 'Create Promotion Form (Coming)'
              : 'Edit ${promotion.name}',
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, String id, String name,
      {required bool isPlan}) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 400.w,
          padding: EdgeInsets.all(28.r),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF1E1B4B).withValues(alpha: 0.98),
                      const Color(0xFF312E81).withValues(alpha: 0.95),
                    ]
                  : [
                      Colors.white,
                      const Color(0xFFF5F0FF),
                    ],
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color:
                  AppColors.error.withValues(alpha: isDark ? 0.3 : 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.error
                          .withValues(alpha: isDark ? 0.2 : 0.1),
                      AppColors.error
                          .withValues(alpha: isDark ? 0.08 : 0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      AppColors.error,
                      AppColors.error.withValues(alpha: 0.7)
                    ],
                  ).createShader(bounds),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 40.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: isDark
                      ? [Colors.white, const Color(0xFFE8E0FF)]
                      : [
                          const Color(0xFF1A1A2E),
                          const Color(0xFF312E81)
                        ],
                ).createShader(bounds),
                child: Text(
                  'Delete $name?',
                  style: GoogleFonts.raleway(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'This action cannot be undone.',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(ctx),
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.onSurfaceVariant
                                    .withValues(
                                        alpha: isDark ? 0.15 : 0.08),
                                colorScheme.onSurfaceVariant
                                    .withValues(
                                        alpha: isDark ? 0.08 : 0.04),
                              ],
                            ),
                            border: Border.all(
                              color: colorScheme.outline
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(ctx);
                          final cubit =
                              context.read<SubscriptionPlansCubit>();
                          if (isPlan) {
                            await cubit.deletePlan(id);
                          } else {
                            await cubit.deletePromotion(id);
                          }
                        },
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.error,
                                AppColors.error.withValues(alpha: 0.85)
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.error
                                    .withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Delete',
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}