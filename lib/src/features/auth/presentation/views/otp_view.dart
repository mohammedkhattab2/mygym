import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/router/route_paths.dart';
import 'package:mygym/src/core/storage/secure_storage.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Premium Luxury OTP Verification View
///
/// Features:
/// - Elegant verification code input
/// - Premium styling with gold accents
/// - Full Light/Dark mode compliance
/// - NO animations (static luxury design)
class OtpView extends StatefulWidget {
  final String phoneNumber;
  const OtpView({super.key, required this.phoneNumber});

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isloading = false;

  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: luxury.backgroundGradient,
        ),
        child: Stack(
          children: [
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    _buildBackButton(colorScheme, luxury, isDark),
                    SizedBox(height: 40.h),
                    _buildHeader(colorScheme, luxury, isDark),
                    SizedBox(height: 48.h),
                    _buildOtpFields(colorScheme, luxury, isDark),
                    SizedBox(height: 32.h),
                    _buildResendSection(colorScheme, luxury, isDark),
                    SizedBox(height: 48.h),
                    _buildVerifyButton(colorScheme, luxury, isDark),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onResendCode() {
    final colorScheme = Theme.of(context).colorScheme;

    if (_secondsRemaining > 0) return;
    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Code sent to ${widget.phoneNumber}',
          style: GoogleFonts.inter(
            color: colorScheme.onPrimary,
          ),
        ),
        backgroundColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  String get _otpCode {
    return _controllers.map((c) => c.text).join();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _autoVerify();
      }
    }
  }

  void _autoVerify() {
    final code = _otpCode;
    if (code.length == 6) {
      onVerify();
    }
  }

  void _onKeyPressed(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  void onVerify() async {
    final code = _otpCode;
    if (code.length < 6) {
      _showError("Please enter a valid code");
      return;
    }
    setState(() => _isloading = true);

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      final secureStorage = GetIt.instance<SecureStorageService>();
      await secureStorage.saveAccessToken('dummy_token_for_dev');

      setState(() => _isloading = false);
      context.go('/member/home');
    }
  }

  void _showError(String message) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(color: colorScheme.onError),
        ),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  void _onBack() {
    context.go(RoutePaths.login);
  }

  Widget _buildBackButton(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: _onBack,
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isDark ? luxury.surfaceElevated : colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark
                  ? luxury.borderLight.withValues(alpha: 0.3)
                  : colorScheme.outline.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: luxury.cardShadow.withValues(alpha: isDark ? 0.2 : 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
            size: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.15),
                colorScheme.secondary.withValues(alpha: isDark ? 0.15 : 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isDark
                  ? luxury.gold.withValues(alpha: 0.2)
                  : colorScheme.primary.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.1),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(
            Icons.lock_outline_rounded,
            size: 40.sp,
            color: colorScheme.primary,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          "Verification Code",
          style: GoogleFonts.playfairDisplay(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "We send a verification code to",
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          widget.phoneNumber,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16.sp,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpFields(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (index) {
          return Container(
            width: 48.w,
            height: 56.h,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: (event) => _onKeyPressed(index, event),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 24.sp,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor:
                      isDark ? luxury.surfaceElevated : colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: isDark
                          ? luxury.borderLight.withValues(alpha: 0.3)
                          : colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: isDark
                          ? luxury.borderLight.withValues(alpha: 0.3)
                          : colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => _onOtpChanged(index, value),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildResendSection(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    final canResend = _secondsRemaining == 0;
    return Column(
      children: [
        Text(
          canResend ? "Didn't receive the code?" : "Resend code in",
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: canResend ? _onResendCode : null,
          child: Text(
            canResend ? "Resend Code" : _formattedTime,
            style: GoogleFonts.montserrat(
              fontSize: 16.sp,
              color: canResend
                  ? (isDark ? luxury.gold : colorScheme.primary)
                  : colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton(
    ColorScheme colorScheme,
    LuxuryThemeExtension luxury,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: _isloading ? null : onVerify,
      child: Container(
        width: double.infinity,
        height: 58.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.primary.withValues(alpha: 0.85),
              isDark
                  ? luxury.gold.withValues(alpha: 0.6)
                  : colorScheme.secondary,
            ],
            stops: const [0.0, 0.6, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? luxury.gold.withValues(alpha: 0.25)
                : colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: isDark ? 0.4 : 0.3),
              blurRadius: 25,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: (isDark ? luxury.gold : colorScheme.secondary)
                  .withValues(alpha: isDark ? 0.15 : 0.1),
              blurRadius: 30,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: _isloading
              ? SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.onPrimary.withValues(alpha: 0.9),
                    ),
                  ),
                )
              : Text(
                  'Verify',
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}
