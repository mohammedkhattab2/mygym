import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          "Support Tickets",
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
      ),
      body: BlocBuilder<SupportCubit, SupportState>(
        builder: (context, state) {
          if (state.isLoading && state.tickets.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }
          final tickets = state.tickets;
          if (tickets.isEmpty) {
            return Center(
              child: Text(
                "No tickets yet.\nCreate your first support ticket.",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<SupportCubit>().refreshTickets(),
            color: colorScheme.primary,
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final t = tickets[index];
                return _TicketItemWidget(ticket: t);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTicketSheet(context),
        icon: const Icon(Icons.add),
        label: const Text("New Ticket"),
        backgroundColor: colorScheme.primary,
      ),
    );
  }

  void _showCreateTicketSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String? subject;
    String? description;
    SupportCategory category = SupportCategory.account;

    final supportCubit = context.read<SupportCubit>();
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return BlocProvider.value(
          value: supportCubit,
          child: _CreateTicketForm(
            formKey: formKey,
            onSubjectChanged: (v) => subject = v,
            onDescriptionChanged: (v) => description = v,
            onCategoryChanged: (v) => category = v,
            initialCategory: category,
            onSubmit: () async {
              if (!formKey.currentState!.validate()) {
                return;
              }
              await ctx.read<SupportCubit>().createTicket(
                subject: subject!.trim(),
                description: description!.trim(),
                category: category,
              );
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
              }
            },
          ),
        );
      },
    );
  }
}

class _TicketItemWidget extends StatelessWidget {
  final SupportTicket ticket;

  const _TicketItemWidget({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: luxury.surfaceElevated,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ticket.subject,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            ticket.category.displayName,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            ticket.status.displayName,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateTicketForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<String> onSubjectChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<SupportCategory> onCategoryChanged;
  final SupportCategory initialCategory;
  final VoidCallback onSubmit;

  const _CreateTicketForm({
    required this.formKey,
    required this.onSubjectChanged,
    required this.onDescriptionChanged,
    required this.onCategoryChanged,
    required this.initialCategory,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final textTheme = Theme.of(context).textTheme;
    
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
      ),
      child: BlocBuilder<SupportCubit, SupportState>(
        builder: (context, state) {
          final isCreating = state.isCreatingTicket;
          return Form(
            key: formKey,
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
                      color: colorScheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                Text(
                  "New Support Ticket",
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Subject",
                    filled: true,
                    fillColor: luxury.surfaceElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Please enter a subject";
                    }
                    return null;
                  },
                  onChanged: onSubjectChanged,
                ),
                SizedBox(height: 12.h),
                DropdownButtonFormField<SupportCategory>(
                  value: initialCategory,
                  decoration: InputDecoration(
                    labelText: "Category",
                    filled: true,
                    fillColor: luxury.surfaceElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                  dropdownColor: luxury.surfaceElevated,
                  items: SupportCategory.values
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(
                            c.displayName,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) onCategoryChanged(v);
                  },
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Description",
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: luxury.surfaceElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Please describe your issue";
                    }
                    return null;
                  },
                  onChanged: onDescriptionChanged,
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isCreating ? null : onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: isCreating
                        ? SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : Text(
                            "Submit",
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
