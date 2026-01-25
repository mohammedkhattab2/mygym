import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/responsive/responsive_utils.dart';

/// ============================================
/// MAIN TEXT FIELD
/// ============================================

/// Custom text field with consistent styling and optional gradient border
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.fillColor,
    this.borderRadius,
    this.useGradientBorder = false,
    this.showCounter = false,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final Color? fillColor;
  final double? borderRadius;
  final bool useGradientBorder;
  final bool showCounter;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  late bool _obscureText;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderRadius = widget.borderRadius ?? ResponsiveSizes.radiusLg;
    final effectiveFillColor = widget.fillColor ??
        (isDark ? AppColors.surfaceElevatedDark : AppColors.grey100);

    Widget textField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null) ...[
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: AppTextStyles.inputLabel.copyWith(
              fontSize: ResponsiveFontSizes.labelMedium,
              color: _isFocused
                  ? AppColors.primary
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
              fontWeight: _isFocused ? FontWeight.w600 : FontWeight.w500,
            ),
            child: Text(widget.label!),
          ),
          RGap.h8,
        ],
        
        // Text Field
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          style: AppTextStyles.input.copyWith(
            fontSize: ResponsiveFontSizes.bodyLarge,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.inputHint.copyWith(
              fontSize: ResponsiveFontSizes.bodyLarge,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textDisabled,
            ),
            errorText: widget.errorText,
            helperText: widget.helperText,
            counterText: widget.showCounter ? null : '',
            filled: true,
            fillColor: effectiveFillColor,
            prefixIcon: widget.prefixIcon != null
                ? IconTheme(
                    data: IconThemeData(
                      color: _isFocused
                          ? AppColors.primary
                          : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                      size: 22.sp,
                    ),
                    child: widget.prefixIcon!,
                  )
                : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      size: 22.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
            contentPadding: ResponsivePadding.input,
            border: _buildBorder(effectiveBorderRadius, isDark, false, false),
            enabledBorder: _buildBorder(effectiveBorderRadius, isDark, false, false),
            focusedBorder: _buildBorder(effectiveBorderRadius, isDark, true, false),
            errorBorder: _buildBorder(effectiveBorderRadius, isDark, false, true),
            focusedErrorBorder: _buildBorder(effectiveBorderRadius, isDark, true, true),
            disabledBorder: _buildBorder(effectiveBorderRadius, isDark, false, false, disabled: true),
          ),
        ),
      ],
    );

    // Wrap with gradient border if needed and focused
    if (widget.useGradientBorder && _isFocused && widget.errorText == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.inputLabel.copyWith(
                fontSize: ResponsiveFontSizes.labelMedium,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              child: Text(widget.label!),
            ),
            RGap.h8,
          ],
          _GradientBorderWrapper(
            borderRadius: effectiveBorderRadius,
            borderWidth: 2.w,
            gradient: AppColors.primaryGradient,
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: _obscureText,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              maxLines: widget.obscureText ? 1 : widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              inputFormatters: widget.inputFormatters,
              textCapitalization: widget.textCapitalization,
              validator: widget.validator,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onSubmitted,
              onTap: widget.onTap,
              style: AppTextStyles.input.copyWith(
                fontSize: ResponsiveFontSizes.bodyLarge,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyles.inputHint.copyWith(
                  fontSize: ResponsiveFontSizes.bodyLarge,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textDisabled,
                ),
                counterText: widget.showCounter ? null : '',
                filled: true,
                fillColor: effectiveFillColor,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.primary,
                          size: 22.sp,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : widget.suffixIcon,
                contentPadding: ResponsivePadding.input,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(effectiveBorderRadius - 2.w),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(effectiveBorderRadius - 2.w),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(effectiveBorderRadius - 2.w),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return textField;
  }

  OutlineInputBorder _buildBorder(
    double radius,
    bool isDark,
    bool isFocused,
    bool isError, {
    bool disabled = false,
  }) {
    Color borderColor;
    double borderWidth = 1.w;

    if (isError) {
      borderColor = AppColors.error;
      borderWidth = isFocused ? 2.w : 1.w;
    } else if (isFocused) {
      borderColor = AppColors.primary;
      borderWidth = 2.w;
    } else if (disabled) {
      borderColor = isDark
          ? AppColors.borderDark.withValues(alpha: 0.5)
          : AppColors.border.withValues(alpha: 0.5);
    } else {
      borderColor = isDark ? AppColors.borderDark : Colors.transparent;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );
  }
}

/// ============================================
/// SEARCH TEXT FIELD
/// ============================================

/// Search text field with clear button
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.showFilterButton = false,
    this.onFilterPressed,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool showFilterButton;
  final VoidCallback? onFilterPressed;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleTextChange);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey100,
        borderRadius: BorderRadius.circular(ResponsiveSizes.radiusRound),
        border: isDark
            ? Border.all(color: AppColors.borderDark, width: 1.w)
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: widget.autofocus,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              style: AppTextStyles.input.copyWith(
                fontSize: ResponsiveFontSizes.bodyLarge,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTextStyles.inputHint.copyWith(
                  fontSize: ResponsiveFontSizes.bodyLarge,
                  color: isDark ? AppColors.textTertiaryDark : AppColors.textDisabled,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  size: 24.sp,
                ),
                suffixIcon: _hasText
                    ? IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          size: 20.sp,
                        ),
                        onPressed: () {
                          _controller.clear();
                          widget.onClear?.call();
                          widget.onChanged?.call('');
                        },
                      )
                    : null,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          if (widget.showFilterButton) ...[
            Container(
              width: 1.w,
              height: 24.h,
              color: isDark ? AppColors.borderDark : AppColors.border,
            ),
            IconButton(
              icon: Icon(
                Icons.tune_rounded,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                size: 24.sp,
              ),
              onPressed: widget.onFilterPressed,
            ),
          ],
        ],
      ),
    );
  }
}

/// ============================================
/// OTP TEXT FIELD
/// ============================================

/// Single OTP digit input field
class OtpTextField extends StatelessWidget {
  const OtpTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.autoFocus = false,
    this.hasError = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFocused = focusNode.hasFocus;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 52.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey100,
        borderRadius: BorderRadius.circular(ResponsiveSizes.radiusMd),
        border: Border.all(
          color: hasError
              ? AppColors.error
              : isFocused
                  ? AppColors.primary
                  : (isDark ? AppColors.borderDark : Colors.transparent),
          width: isFocused || hasError ? 2.w : 1.w,
        ),
        boxShadow: isFocused && !hasError
            ? [
                BoxShadow(
                  color: AppColors.primaryGlowLight,
                  blurRadius: 8.r,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTextStyles.headlineSmall.copyWith(
          fontSize: ResponsiveFontSizes.headlineSmall,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        cursorColor: AppColors.primary,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

/// ============================================
/// OTP INPUT ROW
/// ============================================

/// Complete OTP input with multiple fields and auto-focus
class OtpInputRow extends StatefulWidget {
  const OtpInputRow({
    super.key,
    required this.length,
    required this.onCompleted,
    this.onChanged,
    this.hasError = false,
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final bool hasError;

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _handleChange(int index, String value) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    widget.onChanged?.call(_otp);

    if (_otp.length == widget.length) {
      widget.onCompleted(_otp);
    }
  }

  void _handleKeyPress(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 0 : 8.w,
            right: index == widget.length - 1 ? 0 : 8.w,
          ),
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) => _handleKeyPress(index, event),
            child: OtpTextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              autoFocus: index == 0,
              hasError: widget.hasError,
              onChanged: (value) => _handleChange(index, value),
            ),
          ),
        );
      }),
    );
  }
}

/// ============================================
/// PHONE INPUT FIELD
/// ============================================

/// Phone number input with country code selector
class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
    required this.controller,
    this.label,
    this.hint = 'Phone number',
    this.errorText,
    this.countryCode = '+20',
    this.countryFlag = '🇪🇬',
    this.onCountryCodeTap,
    this.onChanged,
    this.focusNode,
  });

  final TextEditingController controller;
  final String? label;
  final String hint;
  final String? errorText;
  final String countryCode;
  final String countryFlag;
  final VoidCallback? onCountryCodeTap;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.inputLabel.copyWith(
              fontSize: ResponsiveFontSizes.labelMedium,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          RGap.h8,
        ],
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceElevatedDark : AppColors.grey100,
            borderRadius: BorderRadius.circular(ResponsiveSizes.radiusLg),
            border: errorText != null
                ? Border.all(color: AppColors.error, width: 1.w)
                : (isDark
                    ? Border.all(color: AppColors.borderDark, width: 1.w)
                    : null),
          ),
          child: Row(
            children: [
              // Country code button
              InkWell(
                onTap: onCountryCodeTap,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(ResponsiveSizes.radiusLg),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        countryFlag,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      RGap.w8,
                      Text(
                        countryCode,
                        style: AppTextStyles.input.copyWith(
                          fontSize: ResponsiveFontSizes.bodyLarge,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RGap.w4,
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        size: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Divider
              Container(
                width: 1.w,
                height: 30.h,
                color: isDark ? AppColors.borderDark : AppColors.border,
              ),
              
              // Phone number input
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.phone,
                  onChanged: onChanged,
                  style: AppTextStyles.input.copyWith(
                    fontSize: ResponsiveFontSizes.bodyLarge,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                  cursorColor: AppColors.primary,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: AppTextStyles.inputHint.copyWith(
                      fontSize: ResponsiveFontSizes.bodyLarge,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textDisabled,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 18.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          RGap.h8,
          Text(
            errorText!,
            style: AppTextStyles.inputError.copyWith(
              fontSize: ResponsiveFontSizes.bodySmall,
            ),
          ),
        ],
      ],
    );
  }
}

/// ============================================
/// HELPER WIDGETS
/// ============================================

class _GradientBorderWrapper extends StatelessWidget {
  const _GradientBorderWrapper({
    required this.child,
    required this.borderRadius,
    required this.borderWidth,
    required this.gradient,
  });

  final Widget child;
  final double borderRadius;
  final double borderWidth;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient,
      ),
      padding: EdgeInsets.all(borderWidth),
      child: child,
    );
  }
}