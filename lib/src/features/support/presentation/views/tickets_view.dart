import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/app_colors.dart';
import 'package:mygym/src/core/theme/app_text_styles.dart';
import 'package:mygym/src/features/settings/domain/entities/app_settings.dart';
import 'package:mygym/src/features/support/presentation/cubit/support_cubit.dart';

class TicketsView extends StatefulWidget {
  const TicketsView({super.key});

  @override
  State<TicketsView> createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: Text(
          "Support Tickets",
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: BlocBuilder<SupportCubit, SupportState>(
        builder: (context, state) {
          if (state.isLoading && state.tickets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final tickets = state.tickets;
          if (tickets.isEmpty) {
            return Center(
              child: Text(
                "No tickets yet.\nCreate your first support ticket.",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<SupportCubit>().refreshTickets(),
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final t = tickets[index];
                return _buildTicketItem(t);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTicketSheet(context),
        icon: const Icon(Icons.add),
        label: const Text("New Ticket"),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildTicketItem(SupportTicket t) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.subject,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            t.category.displayName,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            t.status.displayName,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateTicketSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? subject;
    String? description;
    SupportCategory category = SupportCategory.account;

    // Capture the cubit from the current context before opening the bottom sheet
    final supportCubit = context.read<SupportCubit>();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return BlocProvider.value(
          value: supportCubit,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 16.w,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16.h,
            ),
            child: BlocBuilder<SupportCubit, SupportState>(
              builder: (context, state) {
                final isCreating = state.isCreatingTicket;
                return Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40.w,
                          height: 4.h,
                          margin: EdgeInsets.only(bottom: 12.h),
                          decoration: BoxDecoration(
                            color: AppColors.borderDark,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                      Text(
                        "New Support Ticket",
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Subject",
                          filled: true,
                          fillColor: AppColors.surfaceElevatedDark,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(color: AppColors.borderDark),
                          ),
                        ),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return " Please enter a subject";
                          }
                          return null;
                        },
                        onChanged: (v) => subject = v,
                      ),
                      SizedBox(height: 12.h),
                      DropdownButtonFormField<SupportCategory>(
                        initialValue: category,
                        decoration: InputDecoration(
                          labelText: "Category",
                          filled: true,
                          fillColor: AppColors.surfaceElevatedDark,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: AppColors.borderDark),
                          ),
                        ),
                        dropdownColor: AppColors.surfaceElevatedDark,
                        items: SupportCategory.values
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(
                                  c.displayName,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimaryDark,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) category = v;
                        },
                      ),
                      SizedBox(height: 12.h),
                      TextFormField(
                        maxLength: 4,
                        decoration: InputDecoration(
                          labelText: "description",
                          alignLabelWithHint: true,
                          filled: true,
                          fillColor: AppColors.surfaceElevatedDark,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: AppColors.borderDark),
                          ),
                        ),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return " Please describe your issue";
                          }
                          return null;
                        },
                        onChanged: (v) => description = v,
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isCreating
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  }
                                  await context
                                      .read<SupportCubit>()
                                      .createTicket(
                                        subject: subject!.trim(),
                                        description: description!.trim(),
                                        category: category,
                                      );
                                      if (context.mounted){
                                        Navigator.of(ctx).pop();
                                      }
                                },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    )
                                  ),
                          child: isCreating
                              ? SizedBox(
                                width: 18.w,
                                height: 1.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              :Text(
                                "Submit",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
