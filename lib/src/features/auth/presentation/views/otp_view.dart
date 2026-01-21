import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/storage/secure_storage.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/core/theme/app_theme.dart';
import 'package:mygym/src/core/widgets/app_button.dart';

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
    SystemChrome.setSystemUIOverlayStyle(AppTheme.darkSystemUiOverlayStyle);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0A14), Color(0xFF0F0F1A)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 16.h),
                _buildBackButton(),
                SizedBox(height: 40.h),
                _buildHeader(),
                SizedBox(height: 48.h),
                _buildOtpFields(),
                SizedBox(height: 32.h),
                _buildResendSection(),
                SizedBox(height: 48.h),
                // AppButton(
                //   text: "Verify",
                //   onPressed: _onVerify,
                //   isLoading: _isloading,
                //   gradient: AppColors.premiumGradient,
                //   ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
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
    if (_secondsRemaining > 60) return;
    _startTimer();

    // TODO: resend code from Api
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code sent to ${widget.phoneNumber}'),
        backgroundColor: AppColors.success,
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
        // Auto-verify when all 6 digits are entered
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

  void _onKeyPresseed(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0)
        _focusNodes[index - 1].requestFocus();
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
      // TODO: Replace with actual API verification
      // For now, save a dummy token to pass auth guard
      final secureStorage = GetIt.instance<SecureStorageService>();
      await secureStorage.saveAccessToken('dummy_token_for_dev');
      
      setState(() => _isloading = false);
      context.go('/member/home');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  void _onBack() {
    context.go("/login");
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: _onBack,
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimaryDark,
            size: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Icon(
            Icons.lock_outline_rounded,
            size: 40.sp,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          "Verification Code",
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "We send a verification code to",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          widget.phoneNumber,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpFields() {
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
              onKeyEvent: (event) => _onKeyPresseed(index, event),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: AppColors.surfaceElevatedDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.borderDark),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.borderDark),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
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

  Widget _buildResendSection() {
    final canResend = _secondsRemaining == 0;
    return Column(
      children: [
        Text(
          canResend ? "Didn't receive the code?" : "Resend code in",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        SizedBox(height: 8.h,),
        GestureDetector(
          onTap: canResend? _onResendCode : null,
          child: Text(
            canResend ? "Resend Code" : _formattedTime,
            style: AppTextStyles.titleMedium.copyWith(
              color: canResend? AppColors.primary : AppColors.textPrimaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }
}
