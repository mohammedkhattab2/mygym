import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/subscription_plan.dart';
import '../bloc/subscription_plans_cubit.dart';

class AdminAddPromotionView extends StatefulWidget {
  final Promotion? existingPromotion;

  const AdminAddPromotionView({super.key, this.existingPromotion});

  @override
  State<AdminAddPromotionView> createState() => _AdminAddPromotionViewState();
}

class _AdminAddPromotionViewState extends State<AdminAddPromotionView> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Basic Info Controllers
  final _nameController = TextEditingController();
  final _nameArController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionArController = TextEditingController();
  final _promoCodeController = TextEditingController();

  // Discount Controllers
  final _discountValueController = TextEditingController();
  final _minPurchaseController = TextEditingController();
  final _usageLimitController = TextEditingController();

  // State
  PromotionType _selectedType = PromotionType.discount;
  bool _isPercentage = true;
  bool _isActive = true;
  bool _isFirstTimeOnly = false;
  bool _hasUsageLimit = false;
  bool _hasMinPurchase = false;
  bool _isLoading = false;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  List<String> _selectedDurations = [];

  bool get isEditMode => widget.existingPromotion != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _populateForm(widget.existingPromotion!);
    }
  }

  void _populateForm(Promotion promo) {
    _nameController.text = promo.name;
    _nameArController.text = promo.nameAr;
    _descriptionController.text = promo.description ?? '';
    _descriptionArController.text = promo.descriptionAr ?? '';
    _promoCodeController.text = promo.promoCode ?? '';
    _discountValueController.text = promo.discountValue.toStringAsFixed(0);
    _selectedType = promo.type;
    _isPercentage = promo.isPercentage;
    _isActive = promo.isActive;
    _isFirstTimeOnly = promo.isFirstTimeOnly;
    _startDate = promo.startDate;
    _endDate = promo.endDate;
    _selectedDurations = List.from(promo.applicableDurations);

    if (promo.usageLimit != null) {
      _hasUsageLimit = true;
      _usageLimitController.text = promo.usageLimit.toString();
    }
    if (promo.minPurchaseAmount != null) {
      _hasMinPurchase = true;
      _minPurchaseController.text =
          promo.minPurchaseAmount!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _nameArController.dispose();
    _descriptionController.dispose();
    _descriptionArController.dispose();
    _promoCodeController.dispose();
    _discountValueController.dispose();
    _minPurchaseController.dispose();
    _usageLimitController.dispose();
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
                                title: 'Promotion Type',
                                icon: Icons.category_outlined,
                                color: AppColors.warning,
                                child: _buildTypeSection(context),
                              ),
                              SizedBox(height: 20.h),
                              _buildSectionCard(
                                context,
                                title: 'Discount',
                                icon: Icons.discount_outlined,
                                color: AppColors.success,
                                child: _buildDiscountSection(context),
                              ),
                              SizedBox(height: 20.h),
                              _buildSectionCard(
                                context,
                                title: 'Validity Period',
                                icon: Icons.date_range_outlined,
                                color: AppColors.info,
                                child: _buildValiditySection(context),
                              ),
                              SizedBox(height: 20.h),
                              _buildSectionCard(
                                context,
                                title: 'Applicable Durations',
                                icon: Icons.timer_outlined,
                                color: const Color(0xFF8B5CF6),
                                child:
                                    _buildApplicableDurationsSection(context),
                              ),
                              SizedBox(height: 20.h),
                              _buildSectionCard(
                                context,
                                title: 'Limits & Settings',
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
                        : Icons.local_offer_rounded,
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
                        isEditMode ? 'Edit Promotion' : 'Create Promotion',
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
                          ? 'Update promotion details'
                          : 'Design a new promotional offer',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Promotion Name (English)',
          hint: 'e.g. Summer Sale, Flash Deal',
          prefixIcon: Icons.local_offer_rounded,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter promotion name';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _nameArController,
          label: 'Promotion Name (Arabic)',
          hint: 'مثال: تخفيضات الصيف',
          prefixIcon: Icons.translate_rounded,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Arabic promotion name';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _descriptionController,
          label: 'Description (English)',
          hint: 'Describe this promotional offer...',
          prefixIcon: Icons.description_outlined,
          maxLines: 2,
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _descriptionArController,
          label: 'Description (Arabic)',
          hint: 'صف هذا العرض الترويجي...',
          prefixIcon: Icons.description_outlined,
          maxLines: 2,
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _promoCodeController,
          label: 'Promo Code (Optional)',
          hint: 'e.g. SUMMER30',
          prefixIcon: Icons.confirmation_number_outlined,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPE SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTypeSection(BuildContext context) {
    final isDark = context.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    final typeData = <PromotionType, _TypeInfo>{
      PromotionType.discount: _TypeInfo(
        Icons.discount_outlined,
        'Discount',
        AppColors.success,
      ),
      PromotionType.flashSale: _TypeInfo(
        Icons.flash_on_rounded,
        'Flash Sale',
        AppColors.error,
      ),
      PromotionType.seasonal: _TypeInfo(
        Icons.wb_sunny_rounded,
        'Seasonal',
        AppColors.warning,
      ),
      PromotionType.referral: _TypeInfo(
        Icons.people_outline_rounded,
        'Referral',
        AppColors.info,
      ),
      PromotionType.firstTime: _TypeInfo(
        Icons.star_outline_rounded,
        'First Time',
        AppColors.gold,
      ),
      PromotionType.renewal: _TypeInfo(
        Icons.autorenew_rounded,
        'Renewal',
        AppColors.primary,
      ),
      PromotionType.bundle: _TypeInfo(
        Icons.inventory_2_outlined,
        'Bundle',
        AppColors.secondary,
      ),
    };

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: PromotionType.values.map((type) {
        final isSelected = _selectedType == type;
        final info = typeData[type]!;

        return GestureDetector(
          onTap: () => setState(() => _selectedType = type),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        info.color.withValues(alpha: isDark ? 0.3 : 0.2),
                        info.color.withValues(alpha: isDark ? 0.15 : 0.1),
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
                    ? info.color.withValues(alpha: isDark ? 0.6 : 0.5)
                    : colorScheme.outline.withValues(alpha: 0.15),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: info.color.withValues(
                            alpha: isDark ? 0.2 : 0.1),
                        blurRadius: 12,
                        spreadRadius: -4,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: isSelected
                        ? [info.color, info.color.withValues(alpha: 0.7)]
                        : [
                            colorScheme.onSurfaceVariant,
                            colorScheme.onSurfaceVariant
                          ],
                  ).createShader(bounds),
                  child: Icon(
                    info.icon,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  info.label,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? info.color
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                if (isSelected) ...[
                  SizedBox(width: 6.w),
                  Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: BoxDecoration(
                      color: info.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: info.color.withValues(alpha: 0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DISCOUNT SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildDiscountSection(BuildContext context) {
    final isDark = context.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Discount Type Toggle
        Text(
          'Discount Type',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isPercentage = true),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: _isPercentage
                        ? LinearGradient(
                            colors: [
                              AppColors.success
                                  .withValues(alpha: isDark ? 0.3 : 0.2),
                              AppColors.success
                                  .withValues(alpha: isDark ? 0.15 : 0.1),
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
                      color: _isPercentage
                          ? AppColors.success
                              .withValues(alpha: isDark ? 0.6 : 0.5)
                          : colorScheme.outline.withValues(alpha: 0.15),
                      width: _isPercentage ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: _isPercentage
                              ? [
                                  AppColors.success,
                                  AppColors.success
                                      .withValues(alpha: 0.7)
                                ]
                              : [
                                  colorScheme.onSurfaceVariant,
                                  colorScheme.onSurfaceVariant
                                ],
                        ).createShader(bounds),
                        child: Icon(Icons.percent_rounded,
                            color: Colors.white, size: 22.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Percentage',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: _isPercentage
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: _isPercentage
                              ? AppColors.success
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isPercentage = false),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: !_isPercentage
                        ? LinearGradient(
                            colors: [
                              AppColors.gold
                                  .withValues(alpha: isDark ? 0.3 : 0.2),
                              AppColors.gold
                                  .withValues(alpha: isDark ? 0.15 : 0.1),
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
                      color: !_isPercentage
                          ? AppColors.gold
                              .withValues(alpha: isDark ? 0.6 : 0.5)
                          : colorScheme.outline.withValues(alpha: 0.15),
                      width: !_isPercentage ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: !_isPercentage
                              ? [
                                  AppColors.gold,
                                  AppColors.gold
                                      .withValues(alpha: 0.7)
                                ]
                              : [
                                  colorScheme.onSurfaceVariant,
                                  colorScheme.onSurfaceVariant
                                ],
                        ).createShader(bounds),
                        child: Icon(Icons.attach_money_rounded,
                            color: Colors.white, size: 22.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Fixed Amount',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: !_isPercentage
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: !_isPercentage
                              ? AppColors.gold
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _discountValueController,
          label: _isPercentage ? 'Discount Percentage' : 'Discount Amount',
          hint: _isPercentage ? '30' : '50',
          prefixIcon: _isPercentage
              ? Icons.percent_rounded
              : Icons.attach_money_rounded,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          suffixText: _isPercentage ? '%' : 'EGP',
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            final v = double.tryParse(value);
            if (v == null) return 'Invalid number';
            if (_isPercentage && (v <= 0 || v > 100)) {
              return 'Must be 1-100';
            }
            if (!_isPercentage && v <= 0) return 'Must be > 0';
            return null;
          },
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VALIDITY SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildValiditySection(BuildContext context) {
    final isDark = context.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDatePicker(
                context,
                label: 'Start Date',
                date: _startDate,
                icon: Icons.event_rounded,
                color: AppColors.info,
                onTap: () => _selectDate(isStart: true),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: _buildDatePicker(
                context,
                label: 'End Date',
                date: _endDate,
                icon: Icons.event_available_rounded,
                color: AppColors.warning,
                onTap: () => _selectDate(isStart: false),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        // Duration preview
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: LinearGradient(
              colors: [
                AppColors.info.withValues(alpha: isDark ? 0.1 : 0.05),
                AppColors.info.withValues(alpha: isDark ? 0.05 : 0.025),
              ],
            ),
            border: Border.all(
              color: AppColors.info.withValues(alpha: isDark ? 0.2 : 0.12),
            ),
          ),
          child: Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    AppColors.info,
                    AppColors.info.withValues(alpha: 0.7)
                  ],
                ).createShader(bounds),
                child: Icon(Icons.timelapse_rounded,
                    size: 16.sp, color: Colors.white),
              ),
              SizedBox(width: 8.w),
              Text(
                'Duration: ${_endDate.difference(_startDate).inDays} days',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
              const Spacer(),
              if (_endDate.isBefore(DateTime.now()))
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.error.withValues(alpha: 0.2),
                        AppColors.error.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Expired',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.error,
                    ),
                  ),
                )
              else if (_startDate.isAfter(DateTime.now()))
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.info.withValues(alpha: 0.2),
                        AppColors.info.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Scheduled',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.info,
                    ),
                  ),
                )
              else
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.success.withValues(alpha: 0.2),
                        AppColors.success.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Active',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    BuildContext context, {
    required String label,
    required DateTime date,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

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
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.02),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                  ).createShader(bounds),
                  child: Icon(icon, color: Colors.white, size: 18.sp),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    DateFormat('MMM d, yyyy').format(date),
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // APPLICABLE DURATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildApplicableDurationsSection(BuildContext context) {
    final isDark = context.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    final durations = [
      ('monthly', 'Monthly', Icons.calendar_month_rounded),
      ('quarterly', 'Quarterly', Icons.date_range_rounded),
      ('yearly', 'Yearly', Icons.calendar_today_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select which subscription durations this promotion applies to. Leave empty for all durations.',
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
          ),
        ),
        SizedBox(height: 14.h),
        Row(
          children: durations.map((d) {
            final isSelected = _selectedDurations.contains(d.$1);
            final color = const Color(0xFF8B5CF6);

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: d.$1 != 'yearly' ? 10.w : 0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedDurations.remove(d.$1);
                      } else {
                        _selectedDurations.add(d.$1);
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                color.withValues(
                                    alpha: isDark ? 0.3 : 0.2),
                                color.withValues(
                                    alpha: isDark ? 0.15 : 0.1),
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                colorScheme.surfaceContainerHighest
                                    .withValues(
                                        alpha: isDark ? 0.3 : 0.5),
                                colorScheme.surfaceContainerHighest
                                    .withValues(
                                        alpha: isDark ? 0.15 : 0.3),
                              ],
                            ),
                      border: Border.all(
                        color: isSelected
                            ? color.withValues(
                                alpha: isDark ? 0.6 : 0.5)
                            : colorScheme.outline
                                .withValues(alpha: 0.15),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: isSelected
                                ? [color, color.withValues(alpha: 0.7)]
                                : [
                                    colorScheme.onSurfaceVariant,
                                    colorScheme.onSurfaceVariant
                                  ],
                          ).createShader(bounds),
                          child: Icon(d.$3,
                              color: Colors.white, size: 22.sp),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          d.$2,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? color
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (isSelected) ...[
                          SizedBox(height: 4.h),
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                const LinearGradient(
                              colors: [
                                Color(0xFF10B981),
                                Color(0xFF34D399)
                              ],
                            ).createShader(bounds),
                            child: Icon(Icons.check_circle_rounded,
                                size: 14.sp, color: Colors.white),
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
  // SETTINGS SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      children: [
        _buildToggleTile(
          context,
          title: 'Active',
          subtitle: 'Make this promotion available immediately',
          value: _isActive,
          color: AppColors.success,
          onChanged: (value) => setState(() => _isActive = value),
        ),
        SizedBox(height: 12.h),
        _buildToggleTile(
          context,
          title: 'First Time Only',
          subtitle: 'Only available for first-time subscribers',
          value: _isFirstTimeOnly,
          color: AppColors.gold,
          onChanged: (value) => setState(() => _isFirstTimeOnly = value),
        ),
        SizedBox(height: 12.h),
        _buildToggleTile(
          context,
          title: 'Usage Limit',
          subtitle: 'Limit how many times this promotion can be used',
          value: _hasUsageLimit,
          color: AppColors.warning,
          onChanged: (value) => setState(() => _hasUsageLimit = value),
        ),
        if (_hasUsageLimit) ...[
          SizedBox(height: 14.h),
          _buildTextField(
            controller: _usageLimitController,
            label: 'Maximum Uses',
            hint: '100',
            prefixIcon: Icons.confirmation_number_outlined,
            keyboardType: TextInputType.number,
            suffixText: 'uses',
            validator: (value) {
              if (_hasUsageLimit && (value == null || value.isEmpty)) {
                return 'Required';
              }
              return null;
            },
          ),
        ],
        SizedBox(height: 12.h),
        _buildToggleTile(
          context,
          title: 'Minimum Purchase',
          subtitle: 'Require a minimum purchase amount to apply',
          value: _hasMinPurchase,
          color: AppColors.info,
          onChanged: (value) => setState(() => _hasMinPurchase = value),
        ),
        if (_hasMinPurchase) ...[
          SizedBox(height: 14.h),
          _buildTextField(
            controller: _minPurchaseController,
            label: 'Minimum Purchase Amount',
            hint: '200',
            prefixIcon: Icons.payments_outlined,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            suffixText: 'EGP',
            validator: (value) {
              if (_hasMinPurchase && (value == null || value.isEmpty)) {
                return 'Required';
              }
              return null;
            },
          ),
        ],
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

  Future<void> _selectDate({required bool isStart}) async {
    final isDark = context.isDarkMode;
    final initialDate = isStart ? _startDate : _endDate;
    final firstDate = isStart
        ? DateTime.now().subtract(const Duration(days: 365))
        : _startDate;
    final lastDate = DateTime.now().add(const Duration(days: 730));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: AppColors.gold,
                    onPrimary: Colors.white,
                    surface: const Color(0xFF1E1B4B),
                    onSurface: Colors.white,
                  )
                : ColorScheme.light(
                    primary: AppColors.gold,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: const Color(0xFF1A1A2E),
                  ),
            dialogBackgroundColor:
                isDark ? const Color(0xFF1E1B4B) : Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
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

    if (_endDate.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'End date must be after start date',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final formData = PromotionFormData(
      id: widget.existingPromotion?.id,
      name: _nameController.text.trim(),
      nameAr: _nameArController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      descriptionAr: _descriptionArController.text.trim().isNotEmpty
          ? _descriptionArController.text.trim()
          : null,
      type: _selectedType,
      discountValue: double.parse(_discountValueController.text.trim()),
      isPercentage: _isPercentage,
      promoCode: _promoCodeController.text.trim().isNotEmpty
          ? _promoCodeController.text.trim().toUpperCase()
          : null,
      startDate: _startDate,
      endDate: _endDate,
      usageLimit: _hasUsageLimit
          ? int.tryParse(_usageLimitController.text.trim())
          : null,
      applicableDurations: _selectedDurations,
      minPurchaseAmount: _hasMinPurchase
          ? double.tryParse(_minPurchaseController.text.trim())
          : null,
      isActive: _isActive,
      isFirstTimeOnly: _isFirstTimeOnly,
    );

    final cubit = context.read<SubscriptionPlansCubit>();
    bool success;

    if (isEditMode) {
      success = await cubit.updatePromotion(
          widget.existingPromotion!.id, formData);
    } else {
      success = await cubit.createPromotion(formData);
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditMode
                ? 'Promotion updated successfully'
                : 'Promotion created successfully',
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
            'Failed to ${isEditMode ? 'update' : 'create'} promotion',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

// Helper class for type info
class _TypeInfo {
  final IconData icon;
  final String label;
  final Color color;

  const _TypeInfo(this.icon, this.label, this.color);
}