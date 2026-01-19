import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/admin_gym.dart';

/// Dialog for adding/editing gym in admin dashboard
class GymFormDialog extends StatefulWidget {
  final AdminGym? gym; // null for adding new gym
  final List<AvailableCity> cities;
  final List<AvailableFacility> facilities;
  final void Function(GymFormData formData) onSave;
  final VoidCallback onCancel;

  const GymFormDialog({
    super.key,
    this.gym,
    required this.cities,
    required this.facilities,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<GymFormDialog> createState() => _GymFormDialogState();
}

class _GymFormDialogState extends State<GymFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _partnerEmailController;
  late final TextEditingController _partnerPhoneController;
  late final TextEditingController _notesController;

  String? _selectedCity;
  final List<String> _selectedFacilities = [];
  final List<String> _imageUrls = [];
  
  // Settings
  int _dailyVisitLimit = 1;
  int _weeklyVisitLimit = 7;
  double _revenueSharePercent = 70.0;
  bool _allowGuestCheckIn = false;
  int _maxConcurrentVisitors = 100;
  bool _requiresGeofence = false;
  double _geofenceRadius = 100.0;

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    final gym = widget.gym;
    
    _nameController = TextEditingController(text: gym?.name ?? '');
    _addressController = TextEditingController(text: gym?.address ?? '');
    _latitudeController = TextEditingController(text: gym?.latitude.toString() ?? '');
    _longitudeController = TextEditingController(text: gym?.longitude.toString() ?? '');
    _partnerEmailController = TextEditingController(text: gym?.partnerEmail ?? '');
    _partnerPhoneController = TextEditingController(text: gym?.partnerPhone ?? '');
    _notesController = TextEditingController(text: gym?.notes ?? '');

    if (gym != null) {
      _selectedCity = gym.city;
      _selectedFacilities.addAll(gym.facilities.map((f) => f.id));
      _imageUrls.addAll(gym.imageUrls);
      _dailyVisitLimit = gym.settings.dailyVisitLimit;
      _weeklyVisitLimit = gym.settings.weeklyVisitLimit;
      _revenueSharePercent = gym.settings.revenueSharePercent;
      _allowGuestCheckIn = gym.settings.allowGuestCheckIn;
      _maxConcurrentVisitors = gym.settings.maxConcurrentVisitors;
      _requiresGeofence = gym.settings.requiresGeofence;
      _geofenceRadius = gym.settings.geofenceRadius ?? 100.0;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _partnerEmailController.dispose();
    _partnerPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.gym != null;
    
    return Dialog(
      child: Container(
        width: 800.w,
        constraints: BoxConstraints(maxHeight: 700.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.add_business,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    isEditing ? 'Edit Gym' : 'Add New Gym',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: widget.onCancel,
                  ),
                ],
              ),
            ),

            // Stepper content
            Expanded(
              child: Form(
                key: _formKey,
                child: Stepper(
                  currentStep: _currentStep,
                  onStepContinue: _onStepContinue,
                  onStepCancel: _onStepCancel,
                  onStepTapped: (step) => setState(() => _currentStep = step),
                  controlsBuilder: (context, details) => const SizedBox.shrink(),
                  steps: [
                    Step(
                      title: const Text('Basic Info'),
                      content: _buildBasicInfoStep(),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Location'),
                      content: _buildLocationStep(),
                      isActive: _currentStep >= 1,
                      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Facilities & Images'),
                      content: _buildFacilitiesStep(),
                      isActive: _currentStep >= 2,
                      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                    ),
                    Step(
                      title: const Text('Settings'),
                      content: _buildSettingsStep(),
                      isActive: _currentStep >= 3,
                      state: _currentStep > 3 ? StepState.complete : StepState.indexed,
                    ),
                  ],
                ),
              ),
            ),

            // Footer buttons
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    OutlinedButton(
                      onPressed: _onStepCancel,
                      child: const Text('Previous'),
                    )
                  else
                    const SizedBox.shrink(),
                  Row(
                    children: [
                      TextButton(
                        onPressed: widget.onCancel,
                        child: const Text('Cancel'),
                      ),
                      SizedBox(width: 12.w),
                      if (_currentStep < 3)
                        AppButton(
                          text: 'Next',
                          onPressed: _onStepContinue,
                        )
                      else
                        AppButton(
                          text: isEditing ? 'Update Gym' : 'Add Gym',
                          onPressed: _submitForm,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: _nameController,
          label: 'Gym Name',
          hint: 'Enter gym name',
          prefixIcon: const Icon(Icons.store),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter gym name';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: _selectedCity,
          decoration: InputDecoration(
            labelText: 'City',
            prefixIcon: const Icon(Icons.location_city),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          items: widget.cities.map((city) => DropdownMenuItem(
            value: city.id,
            child: Text('${city.name}, ${city.country}'),
          )).toList(),
          onChanged: (value) => setState(() => _selectedCity = value),
          validator: (value) {
            if (value == null) {
              return 'Please select a city';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: _partnerEmailController,
          label: 'Partner Email',
          hint: 'partner@example.com',
          prefixIcon: const Icon(Icons.email),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: _partnerPhoneController,
          label: 'Partner Phone',
          hint: '+1234567890',
          prefixIcon: const Icon(Icons.phone),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: _addressController,
          label: 'Full Address',
          hint: 'Enter street address',
          prefixIcon: const Icon(Icons.location_on),
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter address';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _latitudeController,
                label: 'Latitude',
                hint: '30.0444',
                prefixIcon: const Icon(Icons.my_location),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AppTextField(
                controller: _longitudeController,
                label: 'Longitude',
                hint: '31.2357',
                prefixIcon: const Icon(Icons.my_location),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // Map placeholder
        Container(
          height: 200.h,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 48.sp, color: AppColors.textSecondary),
                SizedBox(height: 8.h),
                Text(
                  'Map Preview',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                SizedBox(height: 8.h),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Open map picker
                  },
                  icon: const Icon(Icons.pin_drop),
                  label: const Text('Pick on Map'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFacilitiesStep() {
    // Group facilities by category
    final groupedFacilities = <String, List<AvailableFacility>>{};
    for (final facility in widget.facilities) {
      groupedFacilities.putIfAbsent(facility.category, () => []).add(facility);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Facilities',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        ...groupedFacilities.entries.map((entry) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: entry.value.map((facility) => FilterChip(
                label: Text(facility.name),
                selected: _selectedFacilities.contains(facility.id),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFacilities.add(facility.id);
                    } else {
                      _selectedFacilities.remove(facility.id);
                    }
                  });
                },
                avatar: facility.icon != null
                    ? Icon(Icons.fitness_center, size: 16.sp)
                    : null,
              )).toList(),
            ),
            SizedBox(height: 16.h),
          ],
        )),

        const Divider(),
        SizedBox(height: 16.h),

        Text(
          'Images',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            ..._imageUrls.map((url) => Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    url,
                    width: 100.w,
                    height: 100.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, e, st) => Container(
                      width: 100.w,
                      height: 100.w,
                      color: AppColors.border,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: InkWell(
                    onTap: () => setState(() => _imageUrls.remove(url)),
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 12.sp, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
            InkWell(
              onTap: _addImage,
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, size: 32.sp, color: AppColors.textSecondary),
                    SizedBox(height: 4.h),
                    Text('Add Image', style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Visit limits
        Text(
          'Visit Limits',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildNumberSetting(
                label: 'Daily Limit',
                value: _dailyVisitLimit,
                onChanged: (v) => setState(() => _dailyVisitLimit = v),
                min: 1,
                max: 10,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildNumberSetting(
                label: 'Weekly Limit',
                value: _weeklyVisitLimit,
                onChanged: (v) => setState(() => _weeklyVisitLimit = v),
                min: 1,
                max: 30,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),

        // Revenue share
        Text(
          'Revenue Share: ${_revenueSharePercent.toStringAsFixed(0)}%',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        Slider(
          value: _revenueSharePercent,
          min: 50,
          max: 90,
          divisions: 8,
          label: '${_revenueSharePercent.toStringAsFixed(0)}%',
          onChanged: (value) => setState(() => _revenueSharePercent = value),
        ),
        SizedBox(height: 16.h),

        // Max concurrent visitors
        _buildNumberSetting(
          label: 'Max Concurrent Visitors',
          value: _maxConcurrentVisitors,
          onChanged: (v) => setState(() => _maxConcurrentVisitors = v),
          min: 10,
          max: 500,
        ),
        SizedBox(height: 24.h),

        // Toggles
        SwitchListTile(
          title: const Text('Allow Guest Check-in'),
          subtitle: const Text('Allow non-members to check in'),
          value: _allowGuestCheckIn,
          onChanged: (value) => setState(() => _allowGuestCheckIn = value),
        ),
        SwitchListTile(
          title: const Text('Require Geofence'),
          subtitle: const Text('User must be physically present to check in'),
          value: _requiresGeofence,
          onChanged: (value) => setState(() => _requiresGeofence = value),
        ),
        if (_requiresGeofence) ...[
          SizedBox(height: 8.h),
          Text('Geofence Radius: ${_geofenceRadius.toStringAsFixed(0)} meters'),
          Slider(
            value: _geofenceRadius,
            min: 50,
            max: 500,
            divisions: 9,
            label: '${_geofenceRadius.toStringAsFixed(0)}m',
            onChanged: (value) => setState(() => _geofenceRadius = value),
          ),
        ],
        SizedBox(height: 24.h),

        // Notes
        AppTextField(
          controller: _notesController,
          label: 'Admin Notes',
          hint: 'Internal notes (not visible to users)',
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildNumberSetting({
    required String label,
    required int value,
    required void Function(int) onChanged,
    required int min,
    required int max,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp)),
        SizedBox(height: 8.h),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: value > min ? () => onChanged(value - 1) : null,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: value < max ? () => onChanged(value + 1) : null,
            ),
          ],
        ),
      ],
    );
  }

  void _onStepContinue() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _submitForm();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _addImage() {
    // TODO: Implement image picker
    // For now, just add a placeholder URL for demonstration
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Image URL'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'https://example.com/image.jpg',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() => _imageUrls.add(controller.text));
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cityName = widget.cities.firstWhere(
      (c) => c.id == _selectedCity,
      orElse: () => const AvailableCity(id: '', name: '', country: ''),
    ).name;

    final formData = GymFormData(
      id: widget.gym?.id,
      name: _nameController.text,
      city: cityName,
      address: _addressController.text,
      latitude: double.tryParse(_latitudeController.text) ?? 0.0,
      longitude: double.tryParse(_longitudeController.text) ?? 0.0,
      imageUrls: _imageUrls,
      facilityIds: _selectedFacilities,
      customBundles: widget.gym?.customBundles ?? [],
      settings: AdminGymSettings(
        dailyVisitLimit: _dailyVisitLimit,
        weeklyVisitLimit: _weeklyVisitLimit,
        revenueSharePercent: _revenueSharePercent,
        allowGuestCheckIn: _allowGuestCheckIn,
        maxConcurrentVisitors: _maxConcurrentVisitors,
        requiresGeofence: _requiresGeofence,
        geofenceRadius: _requiresGeofence ? _geofenceRadius : null,
      ),
      partnerEmail: _partnerEmailController.text.isEmpty ? null : _partnerEmailController.text,
      partnerPhone: _partnerPhoneController.text.isEmpty ? null : _partnerPhoneController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    widget.onSave(formData);
    Navigator.pop(context);
  }
}