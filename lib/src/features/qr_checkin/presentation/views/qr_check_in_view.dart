import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/qr_checkin/domain/entities/qr_token.dart';
import 'package:mygym/src/features/qr_checkin/presentation/bloc/qr_checkin_cubit.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCheckInView extends StatelessWidget {
  final String? gymId;
  const QrCheckInView({super.key, this.gymId});

  @override
  Widget build(BuildContext context) {
    context.read<QrCheckinCubit>().generateToken(gymId: gymId);
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text(
          "QR Check-in",
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: BlocBuilder<QrCheckinCubit, QrCheckinState>(
          builder: (context, state) {
            final token = state.currentToken;

            if (state.isLoading && token == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null && token == null) {
              return _buildError(context, state.error!);
            }
            if (token == null) {
              return _buildError(context, 'No QR token available');
            }
            final isExpired = !token.isValid || state.secondsRemaining <= 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Show this QR code at the gym entrance to check in.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                _buildQrImage(token),
                SizedBox(height: 16.w),
                _buildTimerAndStatus(state, isExpired),
                SizedBox(height: 24.h),
                _buildInfoCard(token),
                const Spacer(),
                _buildActions(context, state, isExpired),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 40.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<QrCheckinCubit>().generateToken();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Text(
              "Try Again",
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrImage(QrToken token) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: QrImageView(
        data: token.toQrData(),
        version: QrVersions.auto,
        size: 220.w,
        gapless: true,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Colors.black,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildTimerAndStatus(QrCheckinState state, bool isExpired) {
    final second = state.secondsRemaining;
    return Column(
      children: [
        Text(
          isExpired
              ? "QR code expired"
              : 'Valid for ${second.toString().padLeft(2, '0')}s',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isExpired ? AppColors.error : AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),
        if (!isExpired)
          Text(
            state.isExpiringSoon
                ? 'QR is about to expire, a new one will be generated.'
                : 'A new QR will be generated automatically before it expires.',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
            ),
            textAlign: TextAlign.center,
          )
        else
          Text(
            "Tap Refresh to generate a new QR code.",
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget _buildInfoCard(QrToken token) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Subscriber info",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          if (token.subscriptionId != null)
            Text(
              'Subscription ID: ${token.subscriptionId}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
          if (token.remainingVisits != null)
            Text(
              'Remaining visits: ${token.remainingVisits}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            )
          else
            Text(
              "Network-wide access",
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    QrCheckinState state,
    bool isExpired,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: state.isRefreshing
            ? null
            :()=>  context.read<QrCheckinCubit>().refreshToken(),
        icon: state.isRefreshing
             ? SizedBox(
              width: 16.w,
              height: 16.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
             ) 
             : Icon(
              Icons.refresh_rounded,
              size: 20.sp,
              color: Colors.white,
             ) ,
        label: Text(
          isExpired ? 'Generate new QR' : 'Refresh QR',
          style:AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ) ,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          )
        ),
        ),
    );
  }
}
