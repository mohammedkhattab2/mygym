import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury Phone Input Field
///
/// Features:
/// - Glassmorphism container with gold accent border
/// - Elegant country code selector
/// - Premium typography
/// - Subtle glow effects
class BuildPhoneInput extends StatefulWidget {
  const BuildPhoneInput({
    super.key,
    required this.phoneController,
    required this.selectedCountryCode,
    required this.selectedCountryFlag,
    required this.onShowCountryPicker,
  });

  final TextEditingController phoneController;
  final String selectedCountryCode;
  final String selectedCountryFlag;
  final VoidCallback onShowCountryPicker;

  @override
  State<BuildPhoneInput> createState() => _BuildPhoneInputState();
}

class _BuildPhoneInputState extends State<BuildPhoneInput> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.surfaceElevated,
            colorScheme.surface.withValues(alpha: 0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _isFocused
              ? luxury.gold.withValues(alpha: 0.5)
              : luxury.gold.withValues(alpha: 0.15),
          width: _isFocused ? 1.5 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: luxury.gold.withValues(alpha: 0.08),
                  blurRadius: 25,
                  spreadRadius: 0,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          // Country code selector with luxury styling
          GestureDetector(
            onTap: widget.onShowCountryPicker,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: luxury.gold.withValues(alpha: 0.15),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.selectedCountryFlag,
                    style: TextStyle(fontSize: 22.sp),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    widget.selectedCountryCode,
                    style: GoogleFonts.spaceGrotesk(
                      color: colorScheme.onSurface,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          colorScheme.onSurface.withValues(alpha: 0.7),
                          luxury.gold.withValues(alpha: 0.7),
                        ],
                      ).createShader(bounds);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.onSurface,
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Phone input field
          Expanded(
            child: TextField(
              controller: widget.phoneController,
              focusNode: _focusNode,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.spaceGrotesk(
                color: colorScheme.onSurface,
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
              decoration: InputDecoration(
                hintText: 'Phone number',
                hintStyle: GoogleFonts.inter(
                  color: luxury.textTertiary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}