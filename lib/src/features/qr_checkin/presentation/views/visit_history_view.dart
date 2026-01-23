import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/qr_checkin/domain/entities/qr_token.dart';
import 'package:mygym/src/features/qr_checkin/presentation/bloc/qr_checkin_cubit.dart';

class VisitHistoryView extends StatefulWidget {
  const VisitHistoryView({super.key});

  @override
  State<VisitHistoryView> createState() => _VisitHistoryViewState();
}

class _VisitHistoryViewState extends State<VisitHistoryView> {
  late Future<List<VisitEntry>> _futureVisits;

  @override
  void initState() {
    super.initState();
    _futureVisits = context.read<QrCheckinCubit>().getVisitHistory(limit: 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text(
          "Visit History",
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: FutureBuilder<List<VisitEntry>>(
        future: _futureVisits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load visit history",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            );
          }
          final visits = snapshot.data ?? [];
          if (visits.isEmpty) {
            return Center(
              child: Text(
                "No visit history found",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            itemCount: visits.length,
            itemBuilder: (context, index) {
              final visit = visits[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _buildVisitItem(visit),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildVisitItem(VisitEntry visit) {
    final checkIn = visit.checkInTime;
    final checkOut = visit.checkOutTime;
    final isActive = checkOut == null;
    final dataStr =
        '${checkIn.day.toString().padLeft(2, '0')}/${checkIn.month.toString().padLeft(2, '0')}/${checkIn.year}';
    final timeStr =
        '${checkIn.hour.toString().padLeft(2, '0')}:${checkIn.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color:  AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r)
            ),
            child: Center(
              child: Text(
                visit.gymName.isNotEmpty
                    ? visit.gymName[0].toUpperCase()
                    : "G",
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visit.gymName,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h,),
                Text(
                  '$dataStr • $timeStr',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                SizedBox(height: 4.h,),
                Text(
                  'Duration: ${visit.formattedDuration}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                if (visit.visitsAfter != null)
                    Text(
                      'Remaining visits after this: ${visit.visitsAfter}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    )
              ],
            )
            ),
            SizedBox(width: 8.w,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 4.h),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.success.withValues(alpha: 0.12)
                    :AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12.r)
              ),
              child: Text(
                isActive ? 'In progress' : 'Completed',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isActive
                      ? AppColors.success
                      : AppColors.textSecondaryDark,
                ),
              ),
            )
        ],
      ),
    );
  }
}
