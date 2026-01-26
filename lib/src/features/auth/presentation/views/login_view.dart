import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mygym/src/features/auth/presentation/bloc/auth_state.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_divider.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_guest_option.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_header.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_phone_input.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_social_buttons.dart';
import 'package:mygym/src/features/auth/presentation/widget/build_terms.dart';

/// Premium Luxury Login View
///
/// Features:
/// - Static floating decorative orbs with gold accents
/// - Premium glassmorphism card for form
/// - Elegant typography with Google Fonts
/// - Gold gradient accents
/// - Full Light/Dark mode compliance
/// - NO animations (static luxury design)
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+20';
  String _selectedCountryFlag = '🇪🇬';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // ============================================
  // SOCIAL SIGN-IN
  // ============================================

  void _onGoogleSignIn() {
    context.read<AuthCubit>().signInWithGoogle();
  }

  void _onAppleSignIn() {
    context.read<AuthCubit>().signInWithApple();
  }

  // ============================================
  // PHONE OTP
  // ============================================

  void _showCountryPicker() {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

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
        backgroundColor: colorScheme.surface,
        textStyle: TextStyle(color: colorScheme.onSurface, fontSize: 16.sp),
        searchTextStyle:
            TextStyle(color: colorScheme.onSurface, fontSize: 16.sp),
        inputDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle:
              TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.4)),
          prefixIcon: Icon(Icons.search,
              color: colorScheme.onSurface.withValues(alpha: 0.4)),
          filled: true,
          fillColor: isDark ? luxury.surfaceElevated : colorScheme.surfaceContainerHighest,
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

  void _onSendOtp() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showError("Please enter a phone number");
      return;
    }
    if (phone.length < 6) {
      _showError("Please enter a valid phone number");
      return;
    }

    final fullPhoneNumber = '$_selectedCountryCode$phone';
    context.read<AuthCubit>().sendOtp(phone: fullPhoneNumber);
  }

  // ============================================
  // GUEST LOGIN
  // ============================================

  void _onGuestLogin() {
    context.read<AuthCubit>().continueAsGuest();
  }

  // ============================================
  // BUILD
  // ============================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Handle OTP sent → navigate to OTP screen
        if (state.isOtpSent) {
          final fullPhoneNumber =
              '$_selectedCountryCode${_phoneController.text.trim()}';
          context.push('/auth/otp', extra: fullPhoneNumber);
        }

        // Handle authenticated → navigate to home
        if (state.isAuthenticated) {
          context.go('/member/home');
        }

        // Handle errors
        if (state.hasError && state.errorMessage != null) {
          _showError(state.errorMessage!);
        }
      },
      child: Scaffold(
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
                      SizedBox(height: 40.h),
                      const BuildHeader(),
                      SizedBox(height: 36.h),

                      // Social Buttons with loading state
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return BuildSocialButtons(
                            onGoogleSignIn:
                                state.isLoading ? null : _onGoogleSignIn,
                            onAppleSignIn:
                                state.isLoading ? null : _onAppleSignIn,
                          );
                        },
                      ),

                      SizedBox(height: 28.h),
                      const BuildDivider(),
                      SizedBox(height: 28.h),

                      BuildPhoneInput(
                        phoneController: _phoneController,
                        selectedCountryCode: _selectedCountryCode,
                        selectedCountryFlag: _selectedCountryFlag,
                        onShowCountryPicker: _showCountryPicker,
                      ),

                      SizedBox(height: 28.h),

                      // Send OTP Button with loading state
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return _buildLuxuryButton(
                            text: 'Send Verification Code',
                            onPressed: state.isLoading ? null : _onSendOtp,
                            isLoading: state.isLoading,
                          );
                        },
                      ),

                      SizedBox(height: 24.h),

                      BuildGuestOption(
                        onGuestLogin: _onGuestLogin,
                      ),

                      SizedBox(height: 32.h),
                      const BuildTerms(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLuxuryButton({
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return GestureDetector(
      onTap: isLoading ? null : onPressed,
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
          child: isLoading
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
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: GoogleFonts.montserrat(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 20.sp,
                      color: colorScheme.onPrimary,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _showError(String message) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: colorScheme.onError,
          ),
        ),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}