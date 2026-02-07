import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/luxury_theme_extension.dart';
import '../../domain/entities/admin_user.dart';

class UserDetailsDialog extends StatelessWidget {
  final AdminUser user;

  const UserDetailsDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        width: 500.w,
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 64.r,
                  height: 64.r,
                  decoration: BoxDecoration(
                    gradient: luxury.goldGradient,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: GoogleFonts.inter(fontSize: 28.sp, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: GoogleFonts.playfairDisplay(fontSize: 22.sp, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
                      SizedBox(height: 4.h),
                      Text(user.email, style: GoogleFonts.inter(fontSize: 14.sp, color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Details
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: luxury.gold.withValues(alpha:  0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: luxury.gold.withValues(alpha:  0.1)),
              ),
              child: Column(
                children: [
                  _DetailRow(label: 'Role', value: user.role.displayName),
                  _DetailRow(label: 'Status', value: user.status.displayName),
                  _DetailRow(label: 'Phone', value: user.phone ?? 'Not provided'),
                  _DetailRow(label: 'Subscription', value: user.subscriptionTier ?? 'None'),
                  _DetailRow(label: 'Total Visits', value: '${user.totalVisits}'),
                  _DetailRow(label: 'Total Spent', value: 'EGP ${user.totalSpent.toStringAsFixed(0)}'),
                  _DetailRow(label: 'Joined', value: DateFormat('MMM d, yyyy').format(user.createdAt)),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('Send Email'),
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14.h)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit User'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: luxury.gold,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 13.sp, color: colorScheme.onSurfaceVariant)),
          Text(value, style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
        ],
      ),
    );
  }
}