import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/admin_subscription.dart';
import '../../domain/entities/subscription_plan.dart';
import '../bloc/subscription_plans_cubit.dart';

class AdminAddPlanView extends StatefulWidget {
  final SubscriptionPlan? existingPlan;

  const AdminAddPlanView({super.key, this.existingPlan});

  @override
  State<AdminAddPlanView> createState() => _AdminAddPlanViewState();
}

class _AdminAddPlanViewState extends State<AdminAddPlanView> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Basic Info Controllers
  final _nameController = TextEditingController();
  final _nameArController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionArController = TextEditingController();

  // Pricing Controllers
  final _monthlyPriceController = TextEditingController();
  final _quarterlyPriceController = TextEditingController();
  final _yearlyPriceController = TextEditingController();

  // Visit Limit Controllers
  final _monthlyVisitLimitController = TextEditingController();
  final _quarterlyVisitLimitController = TextEditingController();
  final _yearlyVisitLimitController = TextEditingController();
  final _dailyVisitLimitController = TextEditingController(text: '1');
  final _weeklyVisitLimitController = TextEditingController(text: '7');

  // Settings
  final _sortOrderController = TextEditingController(text: '0');

  // Feature Controllers
  final _featureController = TextEditingController();
  final _featureArController = TextEditingController();

  // State
  SubscriptionTier _selectedTier = SubscriptionTier.basic;
  bool _unlimitedVisits = false;
  bool _isActive = true;
  bool _isPopular = false;
  bool _isLoading = false;
  List<String> _features = [];
  List<String> _featuresAr = [];

  bool get isEditMode => widget.existingPlan != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _populateForm(widget.existingPlan!);
    }
  }

  void _populateForm(SubscriptionPlan plan) {
    _nameController.text = plan.name;
    _nameArController.text = plan.nameAr;
    _descriptionController.text = plan.description;
    _descriptionArController.text = plan.descriptionAr;
    _monthlyPriceController.text = plan.monthlyPrice.toStringAsFixed(0);
    _quarterlyPriceController.text = plan.quarterlyPrice.toStringAsFixed(0);
    _yearlyPriceController.text = plan.yearlyPrice.toStringAsFixed(0);
    _monthlyVisitLimitController.text =
        plan.monthlyVisitLimit?.toString() ?? '';
    _quarterlyVisitLimitController.text =
        plan.quarterlyVisitLimit?.toString() ?? '';
    _yearlyVisitLimitController.text =
        plan.yearlyVisitLimit?.toString() ?? '';
    _dailyVisitLimitController.text = plan.dailyVisitLimit.toString();
    _weeklyVisitLimitController.text = plan.weeklyVisitLimit.toString();
    _sortOrderController.text = plan.sortOrder.toString();
    _selectedTier = plan.tier;
    _unlimitedVisits = plan.unlimitedVisits;
    _isActive = plan.isActive;
    _isPopular = plan.isPopular;
    _features = List.from(plan.features);
    _featuresAr = List.from(plan.featuresAr);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _nameArController.dispose();
    _descriptionController.dispose();
    _descriptionArController.dispose();
    _monthlyPriceController.dispose();
    _quarterlyPriceController.dispose();
    _yearlyPriceController.dispose();
    _monthlyVisitLimitController.dispose();
    _quarterlyVisitLimitController.dispose();
    _yearlyVisitLimitController.dispose();
    _dailyVisitLimitController.dispose();
    _weeklyVisitLimitController.dispose();
    _sortOrderController.dispose();
    _featureController.dispose();
    _featureArController.dispose();
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: EdgeInsets.all(20.r),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 900.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionCard(
                                context,
                                title: 'Basic Information',
                                icon: Icons.info_outline_rounded,
                                color: AppColors.primary,
                                child: _buildBasicInfoSection(context),
                              ),
                              SizedBox(height: 20.h),
                              _buildSectionCard(
                                context,
                                title: 'Pricing',
                                icon: Icons.payments_outlined,
                                color: AppColors.gold,
                                child: _buildPricingSection(context),
                              ),
                              SizedBox(height: 20.h),
                              _buildSectionCard(
                                context,
                                title: 'Visit Limits',
                                icon: Icons.confirmation_number_outlined,
                                color: AppColors.info,
                                child: _buildVisitLimitsSection(context),
                              ),
                              SizedBox(height: 20.h),
                              _buildSectionCard(
                                context,
                                title: 'Features',
                                icon: Icons.star_outline_rounded,
                                color: AppColors.success,
                                child: _buildFeaturesSection(context),
                              ),
                              SizedBox(height: 20.h),
                              _buildSectionCard(
                                context,
                                title: 'Settings',
                                icon: Icons.settings_outlined,
                                color: AppColors.secondary,
                                child: _buildSettingsSection(context),
                              ),
                              SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildHeader(BuildContext context) {
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
              // Back Button
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
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.all(10.r),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: colorScheme.onSurface,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),

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
                    color:
                        AppColors.gold.withValues(alpha: isDark ? 0.4 : 0.25),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                  ).createShader(bounds),
                  child: Icon(
                    isEditMode
                        ? Icons.edit_rounded
                        : Icons.add_circle_outline_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Title
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
                        isEditMode ? 'Edit Plan' : 'Create New Plan',
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
                      isEditMode
                          ? 'Update subscription plan details'
                          : 'Design a new subscription plan',
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

              // Save Button
              Container(
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
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isLoading ? null : _handleSave,
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 10.h),
                      child: _isLoading
                          ? SizedBox(
                              width: 18.r,
                              height: 18.r,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isEditMode
                                      ? Icons.save_rounded
                                      : Icons.add_rounded,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  isEditMode ? 'Save' : 'Create',
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SECTION CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    final isDark = context.isDarkMode;

    final secondaryColor = HSLColor.fromColor(color)
        .withLightness(
            (HSLColor.fromColor(color).lightness + 0.15).clamp(0.0, 1.0))
        .toColor();

    return Container(
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
          color: color.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: color.withValues(alpha: isDark ? 0.2 : 0.1),
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
                        color.withValues(alpha: isDark ? 0.25 : 0.15),
                        color.withValues(alpha: isDark ? 0.12 : 0.08),
                      ],
                    ),
                    border: Border.all(
                      color: color.withValues(alpha: isDark ? 0.4 : 0.25),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                        blurRadius: 8,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [color, secondaryColor],
                    ).createShader(bounds),
                    child: Icon(icon, color: Colors.white, size: 18.sp),
                  ),
                ),
                SizedBox(width: 14.w),
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
                    title,
                    style: GoogleFonts.raleway(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Section Content
          Padding(
            padding: EdgeInsets.all(18.r),
            child: child,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BASIC INFO SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBasicInfoSection(BuildContext context) {
    final isDark = context.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Plan Name (English)',
          hint: 'e.g. Premium, Basic, Plus',
          prefixIcon: Icons.workspace_premium_rounded,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter plan name';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _nameArController,
          label: 'Plan Name (Arabic)',
          hint: 'مثال: بريميوم، أساسي، بلس',
          prefixIcon: Icons.translate_rounded,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Arabic plan name';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _descriptionController,
          label: 'Description (English)',
          hint: 'Describe what this plan offers...',
          prefixIcon: Icons.description_outlined,
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter description';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _descriptionArController,
          label: 'Description (Arabic)',
          hint: 'صف ما تقدمه هذه الخطة...',
          prefixIcon: Icons.description_outlined,
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Arabic description';
            }
            return null;
          },
        ),
        SizedBox(height: 20.h),

        // Tier Selection
        Text(
          'Subscription Tier',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: SubscriptionTier.values.map((tier) {
            final isSelected = _selectedTier == tier;
            final tierColors = {
              SubscriptionTier.basic: AppColors.grey500,
              SubscriptionTier.plus: AppColors.info,
              SubscriptionTier.premium: AppColors.gold,
            };
            final tierColor = tierColors[tier]!;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: tier != SubscriptionTier.premium ? 10.w : 0),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTier = tier),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                tierColor.withValues(
                                    alpha: isDark ? 0.3 : 0.2),
                                tierColor.withValues(
                                    alpha: isDark ? 0.15 : 0.1),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                colorScheme.surfaceContainerHighest
                                    .withValues(alpha: isDark ? 0.3 : 0.5),
                                colorScheme.surfaceContainerHighest
                                    .withValues(alpha: isDark ? 0.15 : 0.3),
                              ],
                            ),
                      border: Border.all(
                        color: isSelected
                            ? tierColor.withValues(
                                alpha: isDark ? 0.6 : 0.5)
                            : colorScheme.outline.withValues(alpha: 0.15),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: tierColor.withValues(
                                    alpha: isDark ? 0.2 : 0.1),
                                blurRadius: 12,
                                spreadRadius: -4,
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: isSelected
                                ? [
                                    tierColor,
                                    tierColor.withValues(alpha: 0.7)
                                  ]
                                : [
                                    colorScheme.onSurfaceVariant,
                                    colorScheme.onSurfaceVariant
                                  ],
                          ).createShader(bounds),
                          child: Icon(
                            Icons.workspace_premium_rounded,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          tier.displayName,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? tierColor
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (isSelected) ...[
                          SizedBox(height: 4.h),
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: BoxDecoration(
                              color: tierColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: tierColor.withValues(alpha: 0.5),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRICING SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPricingSection(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          controller: _monthlyPriceController,
          label: 'Monthly Price (EGP)',
          hint: '299',
          prefixIcon: Icons.calendar_month_rounded,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: 'EGP',
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            if (double.tryParse(value) == null) return 'Invalid number';
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _quarterlyPriceController,
          label: 'Quarterly Price (EGP)',
          hint: '799',
          prefixIcon: Icons.date_range_rounded,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: 'EGP',
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            if (double.tryParse(value) == null) return 'Invalid number';
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _yearlyPriceController,
          label: 'Yearly Price (EGP)',
          hint: '2999',
          prefixIcon: Icons.calendar_today_rounded,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: 'EGP',
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            if (double.tryParse(value) == null) return 'Invalid number';
            return null;
          },
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VISIT LIMITS SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildVisitLimitsSection(BuildContext context) {
    return Column(
      children: [
        _buildToggleTile(
          context,
          title: 'Unlimited Visits',
          subtitle: 'Allow unlimited gym visits for this plan',
          value: _unlimitedVisits,
          color: AppColors.info,
          onChanged: (value) => setState(() => _unlimitedVisits = value),
        ),
        SizedBox(height: 16.h),
        if (!_unlimitedVisits) ...[
          _buildTextField(
            controller: _monthlyVisitLimitController,
            label: 'Monthly Visit Limit',
            hint: '12',
            prefixIcon: Icons.calendar_month_rounded,
            keyboardType: TextInputType.number,
            suffixText: 'visits',
          ),
          SizedBox(height: 16.h),
          _buildTextField(
            controller: _quarterlyVisitLimitController,
            label: 'Quarterly Visit Limit',
            hint: '36',
            prefixIcon: Icons.date_range_rounded,
            keyboardType: TextInputType.number,
            suffixText: 'visits',
          ),
          SizedBox(height: 16.h),
          _buildTextField(
            controller: _yearlyVisitLimitController,
            label: 'Yearly Visit Limit',
            hint: '144',
            prefixIcon: Icons.calendar_today_rounded,
            keyboardType: TextInputType.number,
            suffixText: 'visits',
          ),
          SizedBox(height: 16.h),
        ],
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _dailyVisitLimitController,
                label: 'Daily Limit',
                hint: '1',
                prefixIcon: Icons.today_rounded,
                keyboardType: TextInputType.number,
                suffixText: '/day',
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: _buildTextField(
                controller: _weeklyVisitLimitController,
                label: 'Weekly Limit',
                hint: '7',
                prefixIcon: Icons.view_week_rounded,
                keyboardType: TextInputType.number,
                suffixText: '/week',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FEATURES SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildFeaturesSection(BuildContext context) {
    final isDark = context.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Feature input row
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _buildTextField(
                controller: _featureController,
                label: 'Feature (English)',
                hint: 'e.g. Access to 50+ gyms',
                prefixIcon: Icons.check_circle_outline_rounded,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildTextField(
                controller: _featureArController,
                label: 'Feature (Arabic)',
                hint: 'مثال: الوصول إلى أكثر من 50 صالة',
                prefixIcon: Icons.translate_rounded,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Add Feature Button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _addFeature,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                gradient: LinearGradient(
                  colors: [
                    AppColors.success.withValues(alpha: isDark ? 0.2 : 0.12),
                    AppColors.success.withValues(alpha: isDark ? 0.1 : 0.06),
                  ],
                ),
                border: Border.all(
                  color:
                      AppColors.success.withValues(alpha: isDark ? 0.4 : 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF34D399)],
                    ).createShader(bounds),
                    child: Icon(Icons.add_rounded,
                        size: 16.sp, color: Colors.white),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Add Feature',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Features List
        if (_features.isNotEmpty) ...[
          Text(
            'ADDED FEATURES (${_features.length})',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color:
                  isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            ),
          ),
          SizedBox(height: 10.h),
          ...List.generate(_features.length, (index) {
            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                gradient: LinearGradient(
                  colors: [
                    AppColors.success.withValues(alpha: isDark ? 0.08 : 0.04),
                    AppColors.success.withValues(alpha: isDark ? 0.04 : 0.02),
                  ],
                ),
                border: Border.all(
                  color: AppColors.success
                      .withValues(alpha: isDark ? 0.2 : 0.12),
                ),
              ),
              child: Row(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF34D399)],
                    ).createShader(bounds),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _features[index],
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (index < _featuresAr.length &&
                            _featuresAr[index].isNotEmpty)
                          Text(
                            _featuresAr[index],
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
                  GestureDetector(
                    onTap: () => _removeFeature(index),
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.error
                                .withValues(alpha: isDark ? 0.2 : 0.1),
                            AppColors.error
                                .withValues(alpha: isDark ? 0.1 : 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.error
                              .withValues(alpha: isDark ? 0.3 : 0.2),
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
                          Icons.close_rounded,
                          size: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ] else
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                colors: [
                  colorScheme.surfaceContainerHighest
                      .withValues(alpha: isDark ? 0.2 : 0.4),
                  colorScheme.surfaceContainerHighest
                      .withValues(alpha: isDark ? 0.1 : 0.2),
                ],
              ),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.playlist_add_rounded,
                    size: 32.sp,
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiary,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'No features added yet',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: isDark
                          ? AppColors.textTertiaryDark
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SETTINGS SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      children: [
        _buildToggleTile(
          context,
          title: 'Active',
          subtitle: 'Make this plan visible and available for purchase',
          value: _isActive,
          color: AppColors.success,
          onChanged: (value) => setState(() => _isActive = value),
        ),
        SizedBox(height: 12.h),
        _buildToggleTile(
          context,
          title: 'Popular Badge',
          subtitle: 'Highlight this plan as the most popular choice',
          value: _isPopular,
          color: AppColors.gold,
          onChanged: (value) => setState(() => _isPopular = value),
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _sortOrderController,
          label: 'Sort Order',
          hint: '0',
          prefixIcon: Icons.sort_rounded,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHARED WIDGETS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? suffixText,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 13.sp,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            prefixIcon: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
              ).createShader(bounds),
              child: Icon(prefixIcon, color: Colors.white, size: 18.sp),
            ),
            suffixText: suffixText,
            suffixStyle: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
            filled: true,
            fillColor: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.02),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColors.gold.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColors.gold.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.gold, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildToggleTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required Color color,
    required Function(bool) onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          colors: value
              ? [
                  color.withValues(alpha: isDark ? 0.15 : 0.08),
                  color.withValues(alpha: isDark ? 0.08 : 0.04),
                ]
              : [
                  colorScheme.surfaceContainerHighest
                      .withValues(alpha: isDark ? 0.3 : 0.5),
                  colorScheme.surfaceContainerHighest
                      .withValues(alpha: isDark ? 0.15 : 0.3),
                ],
        ),
        border: Border.all(
          color: value
              ? color.withValues(alpha: isDark ? 0.4 : 0.3)
              : colorScheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: value ? color : colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
            activeTrackColor: color.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  void _addFeature() {
    final featureEn = _featureController.text.trim();
    final featureAr = _featureArController.text.trim();

    if (featureEn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter the feature in English',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _features.add(featureEn);
      _featuresAr.add(featureAr.isNotEmpty ? featureAr : featureEn);
      _featureController.clear();
      _featureArController.clear();
    });
  }

  void _removeFeature(int index) {
    setState(() {
      _features.removeAt(index);
      if (index < _featuresAr.length) {
        _featuresAr.removeAt(index);
      }
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all required fields',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_features.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please add at least one feature',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final formData = SubscriptionPlanFormData(
      id: widget.existingPlan?.id,
      name: _nameController.text.trim(),
      nameAr: _nameArController.text.trim(),
      description: _descriptionController.text.trim(),
      descriptionAr: _descriptionArController.text.trim(),
      tier: _selectedTier,
      monthlyPrice: double.parse(_monthlyPriceController.text.trim()),
      quarterlyPrice: double.parse(_quarterlyPriceController.text.trim()),
      yearlyPrice: double.parse(_yearlyPriceController.text.trim()),
      monthlyVisitLimit: _unlimitedVisits
          ? null
          : int.tryParse(_monthlyVisitLimitController.text.trim()),
      quarterlyVisitLimit: _unlimitedVisits
          ? null
          : int.tryParse(_quarterlyVisitLimitController.text.trim()),
      yearlyVisitLimit: _unlimitedVisits
          ? null
          : int.tryParse(_yearlyVisitLimitController.text.trim()),
      unlimitedVisits: _unlimitedVisits,
      dailyVisitLimit:
          int.tryParse(_dailyVisitLimitController.text.trim()) ?? 1,
      weeklyVisitLimit:
          int.tryParse(_weeklyVisitLimitController.text.trim()) ?? 7,
      features: _features,
      featuresAr: _featuresAr,
      isActive: _isActive,
      isPopular: _isPopular,
      sortOrder: int.tryParse(_sortOrderController.text.trim()) ?? 0,
    );

    final cubit = context.read<SubscriptionPlansCubit>();
    bool success;

    if (isEditMode) {
      success = await cubit.updatePlan(widget.existingPlan!.id, formData);
    } else {
      success = await cubit.createPlan(formData);
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditMode
                ? 'Plan updated successfully'
                : 'Plan created successfully',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop(true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to ${isEditMode ? 'update' : 'create'} plan',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}