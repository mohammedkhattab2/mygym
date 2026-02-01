// lib/src/features/partner/presentation/widget/setting/edit_capacity_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

class EditCapacityBottomSheet extends StatefulWidget {
  final int currentCapacity;
  final Function(int) onSave;

  const EditCapacityBottomSheet({
    super.key,
    required this.currentCapacity,
    required this.onSave,
  });

  @override
  State<EditCapacityBottomSheet> createState() => _EditCapacityBottomSheetState();
}

class _EditCapacityBottomSheetState extends State<EditCapacityBottomSheet> {
  late TextEditingController _controller;
  late double _sliderValue;
  
  static const int _minCapacity = 10;
  static const int _maxCapacity = 500;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentCapacity.toString());
    _sliderValue = widget.currentCapacity.toDouble().clamp(_minCapacity.toDouble(), _maxCapacity.toDouble());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
      _controller.text = value.round().toString();
    });
  }

  void _onTextChanged(String value) {
    final parsed = int.tryParse(value);
    if (parsed != null) {
      setState(() {
        _sliderValue = parsed.toDouble().clamp(_minCapacity.toDouble(), _maxCapacity.toDouble());
      });
    }
  }

  void _save() {
    final capacity = int.tryParse(_controller.text) ?? widget.currentCapacity;
    final validCapacity = capacity.clamp(_minCapacity, _maxCapacity);
    widget.onSave(validCapacity);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? luxury.surfaceElevated : colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha:  0.3),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Title
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          luxury.gold.withValues(alpha:  0.2),
                          luxury.gold.withValues(alpha:  0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.people_alt_rounded,
                      color: luxury.gold,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Max Capacity',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Set the maximum number of people',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // Current value display
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: luxury.gold.withValues(alpha:  0.1),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: luxury.gold.withValues(alpha:  0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.group_rounded,
                        color: luxury.gold,
                        size: 28.sp,
                      ),
                      SizedBox(width: 12.w),
                      SizedBox(
                        width: 80.w,
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w700,
                            color: luxury.gold,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          onChanged: _onTextChanged,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'people',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Slider
              Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: luxury.gold,
                      inactiveTrackColor: luxury.gold.withValues(alpha:  0.2),
                      thumbColor: luxury.gold,
                      overlayColor: luxury.gold.withValues(alpha:  0.2),
                      trackHeight: 6.h,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
                    ),
                    child: Slider(
                      value: _sliderValue,
                      min: _minCapacity.toDouble(),
                      max: _maxCapacity.toDouble(),
                      divisions: (_maxCapacity - _minCapacity) ~/ 5,
                      onChanged: _onSliderChanged,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$_minCapacity',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '$_maxCapacity',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Quick select buttons
              Text(
                'Quick Select',
                style: GoogleFonts.montserrat(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [50, 100, 150, 200, 250, 300].map((capacity) {
                  final isSelected = _sliderValue.round() == capacity;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _sliderValue = capacity.toDouble();
                        _controller.text = capacity.toString();
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [luxury.gold, luxury.gold.withValues(alpha:  0.8)],
                              )
                            : null,
                        color: isSelected ? null : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected ? luxury.gold : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        '$capacity',
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 32.h),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        side: BorderSide(color: colorScheme.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.montserrat(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [luxury.gold, luxury.gold.withValues(alpha:  0.8)],
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: luxury.gold.withValues(alpha:  0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Save Changes',
                              style: GoogleFonts.montserrat(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Show the edit capacity bottom sheet
void showEditCapacityBottomSheet({
  required BuildContext context,
  required int currentCapacity,
  required Function(int) onSave,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => EditCapacityBottomSheet(
      currentCapacity: currentCapacity,
      onSave: onSave,
    ),
  );
}