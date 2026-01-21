import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_theme.dart';
import 'package:mygym/src/core/widgets/app_button.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_divider.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_guest_option.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_header.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_phone_input.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_social_buttons.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_terms.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+20';
  String _selectedCountryFlag = '🇪🇬';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(AppTheme.darkSystemUiOverlayStyle);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void onGoogleSignIn() {
    // TODO: google sign in
    _showComingSoon("Google Sign In");
  }

  void onAppleSignIn() {
    // TODO: apple sign in
    _showComingSoon("Apple Sign In");
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          _selectedCountryCode = '+${country.phoneCode}';
          _selectedCountryFlag = country.flagEmoji;
        });
      },
      countryListTheme: CountryListThemeData(
        backgroundColor: AppColors.surfaceDark,
        textStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
        searchTextStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
        inputDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: TextStyle(color: Colors.white38),
          prefixIcon: Icon(Icons.search, color: Colors.white38),
          filled: true,
          fillColor: AppColors.surfaceElevatedDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
    );
  }

  void onSendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showError("Please enter a phone number");
      return;
    }
    if (phone.length < 6) {
      _showError("Please enter a valid phone number");
      return;
    }
    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        final fullPhoneNumber = '$_selectedCountryCode$phone';
        context.push('/auth/otp', extra: fullPhoneNumber);
      }
    });
  }

  void _onGustLogin() {
    context.go("/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A14),
              Color(0xFF0F0F1A),
            ]
            )
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 48.h),
                BuildHeader(),
                SizedBox(height: 32.h),
                BuildSocialButtons(
                  onGoogleSignIn: onGoogleSignIn,
                  onAppleSignIn: onAppleSignIn,
                ),
                SizedBox(height: 32.h),
                BuildDivider(),
                SizedBox(height: 32.h),
                BuildPhoneInput(
                  phoneController: _phoneController,
                  selectedCountryCode: _selectedCountryCode,
                  selectedCountryFlag: _selectedCountryFlag,
                  onShowCountryPicker: _showCountryPicker,
                ),
                SizedBox(height: 32.h),
                AppButton(
                  text: 'Send Verification Code', 
                  onPressed: onSendOtp,
                  isLoading: _isLoading,
                  gradient: AppColors.primaryGradient,
                  ),
                  SizedBox(height: 24.h),
                  BuildGuestOption(
                    onGuestLogin: _onGustLogin,
                  ),
                  SizedBox(height: 32.h),
                  BuildTerms(),
                  SizedBox(height: 24.h),
                
              ],
            ),
          ),
        ),

      ),
    );
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

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$feature is coming soon"),
        backgroundColor: AppColors.surfaceElevatedDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}
