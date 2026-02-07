import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mygym/src/features/admin/presentation/bloc/admin_dashboard_cubit.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/admin_gym.dart';

class AdminGymFormView extends StatefulWidget {
  final String? gymId; // null = Add, has value = Edit

  const AdminGymFormView({super.key, this.gymId});

  @override
  State<AdminGymFormView> createState() => _AdminGymFormViewState();
}

class _AdminGymFormViewState extends State<AdminGymFormView> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  // Form Controllers
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _partnerEmailController = TextEditingController();
  final _partnerPhoneController = TextEditingController();
  final _notesController = TextEditingController();
  final _dailyLimitController = TextEditingController(text: '1');
  final _weeklyLimitController = TextEditingController(text: '7');
  final _revenueShareController = TextEditingController(text: '70');
  final _maxVisitorsController = TextEditingController(text: '100');
  final _geofenceRadiusController = TextEditingController(text: '100');

  // Form State
  String? _selectedCity;
  List<String> _selectedFacilityIds = [];
  List<String> _imageUrls = [];
  List<WorkingHoursEntry> _workingHours = [];
  List<AdminBundle> _customBundles = [];
  bool _allowGuestCheckIn = false;
  bool _requiresGeofence = false;
  
  // Loading State
  bool _isLoading = false;
  bool _isLoadingData = true;
  bool _isLoadingLocation = false;
  AdminGym? _existingGym;

  bool get isEditMode => widget.gymId != null;

  @override
  void initState() {
    super.initState();
    _initializeWorkingHours();
    _loadFormData();
  }

  void _initializeWorkingHours() {
    _workingHours = List.generate(7, (index) => WorkingHoursEntry(
      dayOfWeek: index + 1,
      openTime: '06:00',
      closeTime: '22:00',
      isClosed: false,
    ));
  }

  Future<void> _loadFormData() async {
    final cubit = context.read<AdminCubit>();
    await cubit.loadFormData();
    
    if (isEditMode) {
      _existingGym = await cubit.getGymDetails(widget.gymId!);
      if (_existingGym != null) {
        _populateForm(_existingGym!);
      }
    }
    
    if (mounted) {
      setState(() => _isLoadingData = false);
    }
  }

  void _populateForm(AdminGym gym) {
    _nameController.text = gym.name;
    _addressController.text = gym.address;
    _latitudeController.text = gym.latitude.toString();
    _longitudeController.text = gym.longitude.toString();
    _partnerEmailController.text = gym.partnerEmail ?? '';
    _partnerPhoneController.text = gym.partnerPhone ?? '';
    _notesController.text = gym.notes ?? '';
    _dailyLimitController.text = gym.settings.dailyVisitLimit.toString();
    _weeklyLimitController.text = gym.settings.weeklyVisitLimit.toString();
    _revenueShareController.text = gym.settings.revenueSharePercent.toString();
    _maxVisitorsController.text = gym.settings.maxConcurrentVisitors.toString();
    
    _selectedCity = gym.city;
    _selectedFacilityIds = gym.facilities.map((f) => f.id).toList();
    _imageUrls = List.from(gym.imageUrls);
    _workingHours = gym.settings.workingHours.isNotEmpty 
        ? List.from(gym.settings.workingHours)
        : _workingHours;
    _customBundles = List.from(gym.customBundles);
    _allowGuestCheckIn = gym.settings.allowGuestCheckIn;
    _requiresGeofence = gym.settings.requiresGeofence;
    
    if (gym.settings.geofenceRadius != null) {
      _geofenceRadiusController.text = gym.settings.geofenceRadius.toString();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _partnerEmailController.dispose();
    _partnerPhoneController.dispose();
    _notesController.dispose();
    _dailyLimitController.dispose();
    _weeklyLimitController.dispose();
    _revenueShareController.dispose();
    _maxVisitorsController.dispose();
    _geofenceRadiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    if (_isLoadingData) {
      return _buildLoadingState(context);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0A0A0F),
                    const Color(0xFF0F0F18),
                    const Color(0xFF0A0A0F),
                  ]
                : [
                    const Color(0xFFFFFBF8),
                    const Color(0xFFF8F5FF),
                    const Color(0xFFFFFBF8),
                  ],
          ),
        ),
        child: Stack(
          children: [
            // Background magical orbs
            ..._buildBackgroundOrbs(isDark),
            // Main content
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
                                title: 'Location',
                                icon: Icons.location_on_outlined,
                                color: AppColors.info,
                                child: _buildLocationSection(context),
                              ),
                              SizedBox(height: 20.h),
                              _buildSectionCard(
                                context,
                                title: 'Images',
                                icon: Icons.image_outlined,
                                color: AppColors.gold,
                                child: _buildImagesSection(context),
                              ),
                              SizedBox(height: 20.h),
                              _buildSectionCard(
                                context,
                                title: 'Facilities',
                                icon: Icons.fitness_center_outlined,
                                color: AppColors.success,
                                child: _buildFacilitiesSection(context),
                              ),
                              SizedBox(height: 20.h),
                              _buildSectionCard(
                                context,
                                title: 'Working Hours',
                                icon: Icons.schedule_outlined,
                                color: AppColors.warning,
                                child: _buildWorkingHoursSection(context),
                              ),
                              SizedBox(height: 20.h),
                              _buildSectionCard(
                                context,
                                title: 'Settings',
                                icon: Icons.settings_outlined,
                                color: AppColors.secondary,
                                child: _buildSettingsSection(context),
                              ),
                              SizedBox(height: 20.h),
                              _buildSectionCard(
                                context,
                                title: 'Partner Information',
                                icon: Icons.person_outline_rounded,
                                color: const Color(0xFF8B5CF6),
                                child: _buildPartnerInfoSection(context),
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
                      colorScheme.onSurfaceVariant.withValues(alpha: isDark ? 0.15 : 0.08),
                      colorScheme.onSurfaceVariant.withValues(alpha: isDark ? 0.08 : 0.04),
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
                    onTap: () => context.go(RoutePaths.adminGymsList),
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
              
              // Title Section - Icon only
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
                    color: AppColors.gold.withValues(alpha: isDark ? 0.4 : 0.25),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                  ).createShader(bounds),
                  child: Icon(
                    isEditMode ? Icons.edit_rounded : Icons.add_business_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ),
              
              const Spacer(),
              
              SizedBox(width: 8.w),
              
              // Actions - wrapped in Flexible to allow shrinking
              Flexible(
                flex: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Cancel Button - icon only on small screens
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.onSurfaceVariant.withValues(alpha: isDark ? 0.15 : 0.08),
                            colorScheme.onSurfaceVariant.withValues(alpha: isDark ? 0.08 : 0.04),
                          ],
                        ),
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => context.go(RoutePaths.adminGymsList),
                          borderRadius: BorderRadius.circular(12.r),
                          child: Padding(
                            padding: EdgeInsets.all(10.r),
                            child: Icon(
                              Icons.close_rounded,
                              color: colorScheme.onSurfaceVariant,
                              size: 18.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    
                    // Save Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFFD700), Color(0xFFD4A574), Color(0xFFFFD700)],
                          stops: [0.0, 0.5, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: isDark ? 0.4 : 0.25),
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
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
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
                                        isEditMode ? Icons.save_rounded : Icons.add_rounded,
                                        color: Colors.white,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        isEditMode ? 'Save' : 'Add',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    final secondaryColor = HSLColor.fromColor(color)
        .withLightness((HSLColor.fromColor(color).lightness + 0.15).clamp(0.0, 1.0))
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
                        : [const Color(0xFF1A1A2E), const Color(0xFF312E81)],
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

  Widget _buildBasicInfoSection(BuildContext context) {
    final cubit = context.read<AdminCubit>();
    final cities = cubit.cities;

    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'Gym Name',
          hint: 'Enter gym name',
          prefixIcon: Icons.fitness_center_rounded,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter gym name';
            }
            return null;
          },
        ),
        SizedBox(height: 18.h),
        _buildDropdownField<String>(
          value: _selectedCity,
          label: 'City',
          hint: 'Select city',
          prefixIcon: Icons.location_city_rounded,
          items: cities.map((city) => DropdownMenuItem(
            value: city.name,
            child: Text(city.name),
          )).toList(),
          onChanged: (value) => setState(() => _selectedCity = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a city';
            }
            return null;
          },
        ),
        SizedBox(height: 18.h),
        _buildTextField(
          controller: _addressController,
          label: 'Address',
          hint: 'Enter full address',
          prefixIcon: Icons.location_on_rounded,
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    
    final hasCoordinates = _latitudeController.text.isNotEmpty &&
                           _longitudeController.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Interactive Map Container
        GestureDetector(
          onTap: _isLoadingLocation ? null : _openMapPicker,
          child: Container(
            height: 180.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.info.withValues(alpha: isDark ? 0.15 : 0.08),
                  AppColors.info.withValues(alpha: isDark ? 0.08 : 0.04),
                ],
              ),
              border: Border.all(
                color: AppColors.info.withValues(alpha: isDark ? 0.3 : 0.2),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Map preview or placeholder
                Center(
                  child: _isLoadingLocation
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 32.r,
                              height: 32.r,
                              child: CircularProgressIndicator(
                                color: AppColors.info,
                                strokeWidth: 2.5,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Getting your location...',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.info,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [AppColors.info, AppColors.info.withValues(alpha: 0.6)],
                              ).createShader(bounds),
                              child: Icon(
                                hasCoordinates ? Icons.location_on_rounded : Icons.map_rounded,
                                size: 42.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              hasCoordinates
                                  ? 'Location Selected'
                                  : 'Tap to Select Location',
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.info,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              hasCoordinates
                                  ? '${_latitudeController.text}, ${_longitudeController.text}'
                                  : 'Choose from map or get current location',
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                ),
                // Tap hint overlay
                Positioned(
                  right: 12.r,
                  top: 12.r,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: isDark ? 0.3 : 0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.touch_app_rounded,
                          size: 12.sp,
                          color: AppColors.info,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Tap',
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // Quick action buttons
        Row(
          children: [
            Expanded(
              child: _buildLocationActionButton(
                context,
                icon: Icons.my_location_rounded,
                label: 'Current Location',
                onTap: _getCurrentLocation,
                isLoading: _isLoadingLocation,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildLocationActionButton(
                context,
                icon: Icons.map_outlined,
                label: 'Pick on Map',
                onTap: _openMapPicker,
                isLoading: false,
              ),
            ),
          ],
        ),
        SizedBox(height: 18.h),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _latitudeController,
                label: 'Latitude',
                hint: '30.0444',
                prefixIcon: Icons.my_location_rounded,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  final lat = double.tryParse(value);
                  if (lat == null || lat < -90 || lat > 90) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: _buildTextField(
                controller: _longitudeController,
                label: 'Longitude',
                hint: '31.2357',
                prefixIcon: Icons.my_location_rounded,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  final lng = double.tryParse(value);
                  if (lng == null || lng < -180 || lng > 180) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagesSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_imageUrls.isNotEmpty) ...[
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: _imageUrls.asMap().entries.map((entry) {
              final index = entry.key;
              final url = entry.value;
              return _buildImageTile(context, url, index);
            }).toList(),
          ),
          SizedBox(height: 14.h),
        ],
        InkWell(
          onTap: _pickImages,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            height: 110.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withValues(alpha: isDark ? 0.12 : 0.06),
                  AppColors.gold.withValues(alpha: isDark ? 0.06 : 0.03),
                ],
              ),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: isDark ? 0.35 : 0.25),
                width: 1,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gold.withValues(alpha: isDark ? 0.25 : 0.15),
                          AppColors.gold.withValues(alpha: isDark ? 0.12 : 0.08),
                        ],
                      ),
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                      ).createShader(bounds),
                      child: Icon(
                        Icons.add_photo_alternate_rounded,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Add Images',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gold,
                    ),
                  ),
                  Text(
                    'PNG, JPG up to 5MB',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageTile(BuildContext context, String url, int index) {
    final isDark = context.isDarkMode;
    final isLocalFile = url.startsWith('file://');
    final imagePath = isLocalFile ? url.substring(7) : url;

    return Stack(
      children: [
        Container(
          width: 90.r,
          height: 90.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: isLocalFile
                  ? FileImage(File(imagePath)) as ImageProvider
                  : NetworkImage(url),
              fit: BoxFit.cover,
            ),
            border: index == 0
                ? Border.all(
                    color: AppColors.gold,
                    width: 2,
                  )
                : Border.all(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    width: 1,
                  ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: index == 0 ? 0.3 : 0.1),
                blurRadius: 8,
                spreadRadius: -2,
              ),
            ],
          ),
        ),
        // Remove Button
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _imageUrls.removeAt(index);
              });
            },
            child: Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.error, AppColors.error.withValues(alpha: 0.8)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.error.withValues(alpha: 0.4),
                    blurRadius: 6,
                    spreadRadius: -1,
                  ),
                ],
              ),
              child: Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 12.sp,
              ),
            ),
          ),
        ),
        // Primary Badge
        if (index == 0)
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                ),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'Primary',
                style: GoogleFonts.inter(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFacilitiesSection(BuildContext context) {
    final cubit = context.read<AdminCubit>();
    final facilities = cubit.facilities;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    final groupedFacilities = <String, List<AvailableFacility>>{};
    for (final facility in facilities) {
      groupedFacilities.putIfAbsent(facility.category, () => []).add(facility);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedFacilities.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: isDark
                    ? [AppColors.success, AppColors.success.withValues(alpha: 0.7)]
                    : [const Color(0xFF1A1A2E), const Color(0xFF312E81)],
              ).createShader(bounds),
              child: Text(
                entry.key,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: entry.value.map((facility) {
                final isSelected = _selectedFacilityIds.contains(facility.id);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedFacilityIds.remove(facility.id);
                      } else {
                        _selectedFacilityIds.add(facility.id);
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                AppColors.success.withValues(alpha: isDark ? 0.25 : 0.15),
                                AppColors.success.withValues(alpha: isDark ? 0.12 : 0.08),
                              ],
                            )
                          : null,
                      color: isSelected ? null : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.success.withValues(alpha: isDark ? 0.5 : 0.4)
                            : colorScheme.outline.withValues(alpha: 0.25),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (facility.icon != null) ...[
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: isSelected
                                  ? [AppColors.success, const Color(0xFF34D399)]
                                  : [colorScheme.onSurfaceVariant, colorScheme.onSurfaceVariant],
                            ).createShader(bounds),
                            child: Icon(
                              _getFacilityIcon(facility.icon!),
                              size: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6.w),
                        ],
                        Text(
                          facility.name,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected
                                ? AppColors.success
                                : colorScheme.onSurface,
                          ),
                        ),
                        if (isSelected) ...[
                          SizedBox(width: 6.w),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF34D399)],
                            ).createShader(bounds),
                            child: Icon(
                              Icons.check_rounded,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildWorkingHoursSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Column(
      children: List.generate(_workingHours.length, (index) {
        final hours = _workingHours[index];
        
        return Container(
          key: ValueKey('working_hours_$index'),
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            gradient: LinearGradient(
              colors: hours.isClosed
                  ? [
                      AppColors.error.withValues(alpha: isDark ? 0.12 : 0.06),
                      AppColors.error.withValues(alpha: isDark ? 0.06 : 0.03),
                    ]
                  : [
                      AppColors.warning.withValues(alpha: isDark ? 0.1 : 0.05),
                      AppColors.warning.withValues(alpha: isDark ? 0.05 : 0.025),
                    ],
            ),
            border: Border.all(
              color: hours.isClosed
                  ? AppColors.error.withValues(alpha: isDark ? 0.3 : 0.2)
                  : AppColors.warning.withValues(alpha: isDark ? 0.25 : 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 90.w,
                child: Text(
                  hours.dayName,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: hours.isClosed
                        ? AppColors.error
                        : colorScheme.onSurface,
                  ),
                ),
              ),
              Switch(
                value: !hours.isClosed,
                onChanged: (value) {
                  setState(() {
                    _workingHours[index] = WorkingHoursEntry(
                      dayOfWeek: hours.dayOfWeek,
                      openTime: hours.openTime,
                      closeTime: hours.closeTime,
                      isClosed: !value,
                    );
                  });
                },
                activeColor: AppColors.warning,
                activeTrackColor: AppColors.warning.withValues(alpha: 0.3),
              ),
              SizedBox(width: 12.w),
              if (!hours.isClosed) ...[
                Expanded(
                  child: _WorkingHoursTimePicker(
                    key: ValueKey('open_$index'),
                    value: hours.openTime,
                    isDark: isDark,
                    colorScheme: colorScheme,
                    onTimeSelected: (time) {
                      setState(() {
                        _workingHours[index] = WorkingHoursEntry(
                          dayOfWeek: _workingHours[index].dayOfWeek,
                          openTime: time,
                          closeTime: _workingHours[index].closeTime,
                          isClosed: _workingHours[index].isClosed,
                        );
                      });
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _WorkingHoursTimePicker(
                    key: ValueKey('close_$index'),
                    value: hours.closeTime,
                    isDark: isDark,
                    colorScheme: colorScheme,
                    onTimeSelected: (time) {
                      setState(() {
                        _workingHours[index] = WorkingHoursEntry(
                          dayOfWeek: _workingHours[index].dayOfWeek,
                          openTime: _workingHours[index].openTime,
                          closeTime: time,
                          isClosed: _workingHours[index].isClosed,
                        );
                      });
                    },
                  ),
                ),
              ] else
                Expanded(
                  child: Text(
                    'Closed',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _dailyLimitController,
                label: 'Daily Visit Limit',
                hint: '1',
                prefixIcon: Icons.today_rounded,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: _buildTextField(
                controller: _weeklyLimitController,
                label: 'Weekly Visit Limit',
                hint: '7',
                prefixIcon: Icons.date_range_rounded,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _revenueShareController,
                label: 'Gym Revenue Share (%)',
                hint: '70',
                prefixIcon: Icons.percent_rounded,
                keyboardType: TextInputType.number,
                suffixText: '%',
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: _buildTextField(
                controller: _maxVisitorsController,
                label: 'Max Concurrent Visitors',
                hint: '100',
                prefixIcon: Icons.groups_rounded,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        _buildToggleTile(
          context,
          title: 'Allow Guest Check-In',
          subtitle: 'Let non-subscribed users check in with day passes',
          value: _allowGuestCheckIn,
          color: AppColors.secondary,
          onChanged: (value) => setState(() => _allowGuestCheckIn = value),
        ),
        SizedBox(height: 10.h),
        _buildToggleTile(
          context,
          title: 'Require Geofence',
          subtitle: 'Users must be at the gym location to check in',
          value: _requiresGeofence,
          color: AppColors.info,
          onChanged: (value) => setState(() => _requiresGeofence = value),
        ),
        if (_requiresGeofence) ...[
          SizedBox(height: 14.h),
          _buildTextField(
            controller: _geofenceRadiusController,
            label: 'Geofence Radius (meters)',
            hint: '100',
            prefixIcon: Icons.radar_rounded,
            keyboardType: TextInputType.number,
            suffixText: 'm',
          ),
        ],
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
                  colorScheme.surfaceContainerHighest.withValues(alpha: isDark ? 0.3 : 0.5),
                  colorScheme.surfaceContainerHighest.withValues(alpha: isDark ? 0.15 : 0.3),
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
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
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

  Widget _buildPartnerInfoSection(BuildContext context) {
    return Column(
      children: [
        _buildTextField(
          controller: _partnerEmailController,
          label: 'Partner Email',
          hint: 'partner@gym.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _partnerPhoneController,
          label: 'Partner Phone',
          hint: '+20 XXX XXX XXXX',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _notesController,
          label: 'Notes',
          hint: 'Any additional notes...',
          prefixIcon: Icons.notes_rounded,
          maxLines: 3,
        ),
      ],
    );
  }

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
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required String label,
    required String hint,
    required IconData prefixIcon,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
    String? Function(T?)? validator,
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
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
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
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          ),
          dropdownColor: isDark ? const Color(0xFF1E1B4B) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          icon: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
            ).createShader(bounds),
            child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0A0A0F),
                    const Color(0xFF0F0F18),
                    const Color(0xFF0A0A0F),
                  ]
                : [
                    const Color(0xFFFFFBF8),
                    const Color(0xFFF8F5FF),
                    const Color(0xFFFFFBF8),
                  ],
          ),
        ),
        child: Center(
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
                  'Loading form data...',
                  style: GoogleFonts.raleway(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    
    try {
      // Check permission
      final permission = await Permission.location.request();
      
      if (!permission.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Location permission is required to get your current location',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              backgroundColor: AppColors.warning,
              action: SnackBarAction(
                label: 'Settings',
                textColor: Colors.white,
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
        setState(() => _isLoadingLocation = false);
        return;
      }
      
      // Check if location service is enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please enable location services',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              backgroundColor: AppColors.warning,
            ),
          );
        }
        setState(() => _isLoadingLocation = false);
        return;
      }
      
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _latitudeController.text = position.latitude.toStringAsFixed(6);
        _longitudeController.text = position.longitude.toStringAsFixed(6);
        _isLoadingLocation = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Location updated successfully',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to get location: ${e.toString()}',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
  
  Future<void> _openMapPicker() async {
    final isDark = context.isDarkMode;
    
    // Default to Cairo, Egypt if no coordinates set
    double initialLat = 30.0444;
    double initialLng = 31.2357;
    
    if (_latitudeController.text.isNotEmpty && _longitudeController.text.isNotEmpty) {
      initialLat = double.tryParse(_latitudeController.text) ?? initialLat;
      initialLng = double.tryParse(_longitudeController.text) ?? initialLng;
    }
    
    final result = await showDialog<LatLng>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _MapPickerDialog(
        initialPosition: LatLng(initialLat, initialLng),
        isDark: isDark,
      ),
    );
    
    if (result != null) {
      setState(() {
        _latitudeController.text = result.latitude.toStringAsFixed(6);
        _longitudeController.text = result.longitude.toStringAsFixed(6);
      });
    }
  }
  
  Widget _buildLocationActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isLoading,
  }) {
    final isDark = context.isDarkMode;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: LinearGradient(
              colors: [
                AppColors.info.withValues(alpha: isDark ? 0.12 : 0.06),
                AppColors.info.withValues(alpha: isDark ? 0.06 : 0.03),
              ],
            ),
            border: Border.all(
              color: AppColors.info.withValues(alpha: isDark ? 0.3 : 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 14.r,
                  height: 14.r,
                  child: CircularProgressIndicator(
                    color: AppColors.info,
                    strokeWidth: 2,
                  ),
                )
              else
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [AppColors.info, AppColors.info.withValues(alpha: 0.7)],
                  ).createShader(bounds),
                  child: Icon(icon, size: 16.sp, color: Colors.white),
                ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final isDark = context.isDarkMode;
    
    // Show bottom sheet to choose between camera and gallery
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1B4B) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Select Image Source',
              style: GoogleFonts.raleway(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: _buildImageSourceOption(
                    context,
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildImageSourceOption(
                    context,
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
    
    if (source == null) return;
    
    try {
      final picker = ImagePicker();
      
      if (source == ImageSource.gallery) {
        // Pick multiple images from gallery
        final images = await picker.pickMultiImage(
          imageQuality: 85,
          maxWidth: 1920,
          maxHeight: 1080,
        );
        
        if (images.isNotEmpty) {
          setState(() {
            for (final image in images) {
              // Add file path with a prefix to distinguish from URLs
              _imageUrls.add('file://${image.path}');
            }
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${images.length} image(s) added',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                backgroundColor: AppColors.success,
              ),
            );
          }
        }
      } else {
        // Take photo with camera
        final image = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
          maxWidth: 1920,
          maxHeight: 1080,
        );
        
        if (image != null) {
          setState(() {
            _imageUrls.add('file://${image.path}');
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Photo captured',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                backgroundColor: AppColors.success,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to pick image: ${e.toString()}',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
  
  Widget _buildImageSourceOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDarkMode;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              colors: [
                AppColors.gold.withValues(alpha: isDark ? 0.15 : 0.08),
                AppColors.gold.withValues(alpha: isDark ? 0.08 : 0.04),
              ],
            ),
            border: Border.all(
              color: AppColors.gold.withValues(alpha: isDark ? 0.3 : 0.2),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gold.withValues(alpha: isDark ? 0.25 : 0.15),
                      AppColors.gold.withValues(alpha: isDark ? 0.12 : 0.08),
                    ],
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFD4A574)],
                  ).createShader(bounds),
                  child: Icon(icon, color: Colors.white, size: 28.sp),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final formData = GymFormData(
      id: widget.gymId,
      name: _nameController.text.trim(),
      city: _selectedCity!,
      address: _addressController.text.trim(),
      latitude: double.parse(_latitudeController.text),
      longitude: double.parse(_longitudeController.text),
      imageUrls: _imageUrls,
      facilityIds: _selectedFacilityIds,
      customBundles: _customBundles,
      settings: AdminGymSettings(
        dailyVisitLimit: int.tryParse(_dailyLimitController.text) ?? 1,
        weeklyVisitLimit: int.tryParse(_weeklyLimitController.text) ?? 7,
        revenueSharePercent: double.tryParse(_revenueShareController.text) ?? 70,
        workingHours: _workingHours,
        allowGuestCheckIn: _allowGuestCheckIn,
        maxConcurrentVisitors: int.tryParse(_maxVisitorsController.text) ?? 100,
        requiresGeofence: _requiresGeofence,
        geofenceRadius: _requiresGeofence
            ? double.tryParse(_geofenceRadiusController.text)
            : null,
      ),
      partnerEmail: _partnerEmailController.text.trim().isNotEmpty
          ? _partnerEmailController.text.trim()
          : null,
      partnerPhone: _partnerPhoneController.text.trim().isNotEmpty
          ? _partnerPhoneController.text.trim()
          : null,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
    );

    final cubit = context.read<AdminCubit>();
    final success = isEditMode
        ? await cubit.updateGym(widget.gymId!, formData)
        : await cubit.addGym(formData);

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditMode ? 'Gym updated successfully' : 'Gym added successfully',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.success,
        ),
      );
      context.go(RoutePaths.adminGymsList);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to ${isEditMode ? 'update' : 'add'} gym',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  IconData _getFacilityIcon(String iconName) {
    final iconMap = {
      'fitness': Icons.fitness_center_rounded,
      'pool': Icons.pool_rounded,
      'spa': Icons.spa_rounded,
      'parking': Icons.local_parking_rounded,
      'wifi': Icons.wifi_rounded,
      'locker': Icons.lock_rounded,
      'shower': Icons.shower_rounded,
      'towel': Icons.dry_cleaning_rounded,
      'trainer': Icons.sports_rounded,
      'cafe': Icons.local_cafe_rounded,
      'sauna': Icons.hot_tub_rounded,
      'yoga': Icons.self_improvement_rounded,
      'cardio': Icons.directions_run_rounded,
      'weights': Icons.fitness_center_rounded,
    };
    return iconMap[iconName.toLowerCase()] ?? Icons.check_circle_rounded;
  }
}

// Map Picker Dialog Widget
class _MapPickerDialog extends StatefulWidget {
  final LatLng initialPosition;
  final bool isDark;

  const _MapPickerDialog({
    required this.initialPosition,
    required this.isDark,
  });

  @override
  State<_MapPickerDialog> createState() => _MapPickerDialogState();
}

class _MapPickerDialogState extends State<_MapPickerDialog> {
  GoogleMapController? _mapController;
  late LatLng _selectedPosition;
  bool _isLoadingCurrentLocation = false;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialPosition;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16.r),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 600.w,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.isDark
                ? [
                    const Color(0xFF1E1B4B).withValues(alpha: 0.98),
                    const Color(0xFF312E81).withValues(alpha: 0.95),
                  ]
                : [
                    Colors.white,
                    const Color(0xFFF5F0FF),
                  ],
          ),
          border: Border.all(
            color: AppColors.info.withValues(alpha: widget.isDark ? 0.3 : 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 30,
              spreadRadius: -5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.info.withValues(alpha: widget.isDark ? 0.2 : 0.1),
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
                          AppColors.info.withValues(alpha: widget.isDark ? 0.25 : 0.15),
                          AppColors.info.withValues(alpha: widget.isDark ? 0.12 : 0.08),
                        ],
                      ),
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [AppColors.info, AppColors.info.withValues(alpha: 0.7)],
                      ).createShader(bounds),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Location',
                          style: GoogleFonts.raleway(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Tap on the map to pick a location',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            color: widget.isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Map
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  margin: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11.r),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _selectedPosition,
                        zoom: 15,
                      ),
                      onMapCreated: (controller) {
                        _mapController = controller;
                        if (widget.isDark) {
                          _mapController?.setMapStyle(_darkMapStyle);
                        }
                      },
                      onTap: (position) {
                        setState(() {
                          _selectedPosition = position;
                        });
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId('selected'),
                          position: _selectedPosition,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueAzure,
                          ),
                        ),
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                    ),
                  ),
                ),
              ),
            ),
            // Coordinates display
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.r),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.info.withValues(alpha: widget.isDark ? 0.1 : 0.05),
                border: Border.all(
                  color: AppColors.info.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.pin_drop_rounded,
                    size: 16.sp,
                    color: AppColors.info,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      '${_selectedPosition.latitude.toStringAsFixed(6)}, ${_selectedPosition.longitude.toStringAsFixed(6)}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            // Action buttons
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 0, 16.r, 16.r),
              child: Row(
                children: [
                  // Get current location button
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isLoadingCurrentLocation ? null : _goToCurrentLocation,
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                              ],
                            ),
                            border: Border.all(
                              color: colorScheme.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isLoadingCurrentLocation)
                                SizedBox(
                                  width: 16.r,
                                  height: 16.r,
                                  child: CircularProgressIndicator(
                                    color: AppColors.info,
                                    strokeWidth: 2,
                                  ),
                                )
                              else
                                Icon(
                                  Icons.my_location_rounded,
                                  size: 16.sp,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              SizedBox(width: 6.w),
                              Text(
                                'My Location',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Confirm button
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(_selectedPosition),
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.info.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_rounded,
                                size: 16.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'Confirm',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
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
          ],
        ),
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    setState(() => _isLoadingCurrentLocation = true);
    
    try {
      final permission = await Permission.location.request();
      
      if (!permission.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Location permission required',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              backgroundColor: AppColors.warning,
            ),
          );
        }
        setState(() => _isLoadingCurrentLocation = false);
        return;
      }
      
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      final newPosition = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _selectedPosition = newPosition;
        _isLoadingCurrentLocation = false;
      });
      
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(newPosition, 17),
      );
    } catch (e) {
      setState(() => _isLoadingCurrentLocation = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to get location',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  static const String _darkMapStyle = '''
  [
    {"elementType": "geometry", "stylers": [{"color": "#1d2c4d"}]},
    {"elementType": "labels.text.fill", "stylers": [{"color": "#8ec3b9"}]},
    {"elementType": "labels.text.stroke", "stylers": [{"color": "#1a3646"}]},
    {"featureType": "administrative.country", "elementType": "geometry.stroke", "stylers": [{"color": "#4b6878"}]},
    {"featureType": "administrative.land_parcel", "elementType": "labels.text.fill", "stylers": [{"color": "#64779e"}]},
    {"featureType": "administrative.province", "elementType": "geometry.stroke", "stylers": [{"color": "#4b6878"}]},
    {"featureType": "landscape.man_made", "elementType": "geometry.stroke", "stylers": [{"color": "#334e87"}]},
    {"featureType": "landscape.natural", "elementType": "geometry", "stylers": [{"color": "#023e58"}]},
    {"featureType": "poi", "elementType": "geometry", "stylers": [{"color": "#283d6a"}]},
    {"featureType": "poi", "elementType": "labels.text.fill", "stylers": [{"color": "#6f9ba5"}]},
    {"featureType": "poi", "elementType": "labels.text.stroke", "stylers": [{"color": "#1d2c4d"}]},
    {"featureType": "poi.park", "elementType": "geometry.fill", "stylers": [{"color": "#023e58"}]},
    {"featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [{"color": "#3C7680"}]},
    {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#304a7d"}]},
    {"featureType": "road", "elementType": "labels.text.fill", "stylers": [{"color": "#98a5be"}]},
    {"featureType": "road", "elementType": "labels.text.stroke", "stylers": [{"color": "#1d2c4d"}]},
    {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#2c6675"}]},
    {"featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [{"color": "#255763"}]},
    {"featureType": "road.highway", "elementType": "labels.text.fill", "stylers": [{"color": "#b0d5ce"}]},
    {"featureType": "road.highway", "elementType": "labels.text.stroke", "stylers": [{"color": "#023e58"}]},
    {"featureType": "transit", "elementType": "labels.text.fill", "stylers": [{"color": "#98a5be"}]},
    {"featureType": "transit", "elementType": "labels.text.stroke", "stylers": [{"color": "#1d2c4d"}]},
    {"featureType": "transit.line", "elementType": "geometry.fill", "stylers": [{"color": "#283d6a"}]},
    {"featureType": "transit.station", "elementType": "geometry", "stylers": [{"color": "#3a4762"}]},
    {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#0e1626"}]},
    {"featureType": "water", "elementType": "labels.text.fill", "stylers": [{"color": "#4e6d70"}]}
  ]
  ''';
}

// Working Hours Time Picker Widget
class _WorkingHoursTimePicker extends StatefulWidget {
  final String value;
  final bool isDark;
  final ColorScheme colorScheme;
  final Function(String) onTimeSelected;

  const _WorkingHoursTimePicker({
    super.key,
    required this.value,
    required this.isDark,
    required this.colorScheme,
    required this.onTimeSelected,
  });

  @override
  State<_WorkingHoursTimePicker> createState() => _WorkingHoursTimePickerState();
}

class _WorkingHoursTimePickerState extends State<_WorkingHoursTimePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showTimePicker,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          gradient: LinearGradient(
            colors: [
              AppColors.warning.withValues(alpha: widget.isDark ? 0.15 : 0.08),
              AppColors.warning.withValues(alpha: widget.isDark ? 0.08 : 0.04),
            ],
          ),
          border: Border.all(
            color: AppColors.warning.withValues(alpha: widget.isDark ? 0.3 : 0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            widget.value,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: widget.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker() async {
    // Unfocus any focused widget first
    FocusScope.of(context).unfocus();
    
    final parts = widget.value.split(':');
    final initialHour = int.tryParse(parts[0]) ?? 6;
    final initialMinute = int.tryParse(parts[1]) ?? 0;
    
    // Store callback reference before async gap
    final onTimeSelected = widget.onTimeSelected;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: widget.isDark ? const Color(0xFF1E1B4B) : Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              dialHandColor: AppColors.warning,
              dialBackgroundColor: AppColors.warning.withValues(alpha: widget.isDark ? 0.15 : 0.1),
              hourMinuteColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.warning.withValues(alpha: widget.isDark ? 0.25 : 0.15);
                }
                return widget.isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05);
              }),
              hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.warning;
                }
                return widget.isDark ? Colors.white70 : Colors.black87;
              }),
              entryModeIconColor: AppColors.warning,
            ),
            colorScheme: widget.isDark
                ? ColorScheme.dark(
                    primary: AppColors.warning,
                    secondary: AppColors.warning,
                    surface: const Color(0xFF1E1B4B),
                  )
                : ColorScheme.light(
                    primary: AppColors.warning,
                    secondary: AppColors.warning,
                    surface: Colors.white,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      // Unfocus again after dialog closes
      FocusScope.of(context).unfocus();
      
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      
      // Use a microtask to ensure the callback runs after the current frame
      Future.microtask(() {
        if (mounted) {
          onTimeSelected(formattedTime);
        }
      });
    }
  }
}