import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/admin/domain/entities/admin_gym.dart';
import 'package:mygym/src/features/admin/presentation/bloc/admin_dashboard_cubit.dart';

class AdminGymFormView extends StatefulWidget {
  final String? gymId;

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
  AdminGym? _existingGym;

  bool get isEditMode => widget.gymId != null;

  @override
  void initState() {
    super.initState();
    _initializeWorkingHours();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFormData();
    });
  }

  void _initializeWorkingHours() {
    _workingHours = List.generate(
      7,
      (index) => WorkingHoursEntry(
        dayOfWeek: index + 1,
        openTime: '06:00',
        closeTime: '22:00',
        isClosed: false,
      ),
    );
  }

  Future<void> _loadFormData() async {
    try {
      final cubit = context.read<AdminCubit>();
      await cubit.loadFormData();

      if (isEditMode) {
        _existingGym = await cubit.getGymDetails(widget.gymId!);
        if (_existingGym != null) {
          _populateForm(_existingGym!);
        }
      }
    } catch (e) {
      debugPrint('Error loading form data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingData = false);
      }
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
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    if (_isLoadingData) {
      return _buildLoadingState(context);
    }
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.all(24.r),
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
                          child: _buildBasicInfoSection(context),
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
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: luxury.gold, strokeWidth: 3),
            SizedBox(height: 16.h),
            Text(
              "Loading form data...",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? luxury.surfaceElevated : colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: luxury.borderLight.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => context.go(RoutePaths.adminGymsList),
                icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditMode ? "Edit Gym" : "Add New Gym",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (isEditMode && _existingGym != null)
                    Text(
                      _existingGym!.name,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () => context.go(RoutePaths.adminGymsList),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  side: BorderSide(color: colorScheme.outline),
                ),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                decoration: BoxDecoration(
                  gradient: luxury.goldGradient,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: luxury.gold.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isLoading ? null : _handleSave,
                    borderRadius: BorderRadius.circular(10.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20.r,
                              height: 20.r,
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
                                  size: 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  isEditMode ? "Save Changes" : "Add Gym",
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? luxury.surfaceElevated : colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: luxury.borderLight.withValues(alpha: 0.1)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: luxury.borderLight.withValues(alpha: 0.1),
                )
              )
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: luxury.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r)
                  ),
                  child: Icon(icon, color: luxury.gold, size: 20.sp,),
                ),
                SizedBox(width: 14.w,),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding:EdgeInsets.all(20.r),
            child: child, 
          )
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
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    int maxLine = 1,
    String? sufficText,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 8.h,),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLine,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: colorScheme.onSurface
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(prefixIcon, color: luxury.gold, size: 20.sp, ),
            suffixText: sufficText,
            suffixStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
            filled: true,
            fillColor: isDark
                 ? Colors.white.withValues(alpha: 0.05)
                 : Colors.black.withValues(alpha: 0.02),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: luxury.borderLight.withValues(alpha: 0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: luxury.borderLight.withValues(alpha: 0.2))
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: luxury.gold, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h)
          ),
          validator: validator,
        )
      ],
    );
  }
}
