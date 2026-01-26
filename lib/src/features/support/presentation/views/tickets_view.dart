import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/settings/domain/entities/app_settings.dart';
import 'package:mygym/src/features/support/presentation/cubit/support_cubit.dart';

/// Premium Luxury Tickets View
///
/// Features:
/// - Static glowing orbs (no motion/parallax)
/// - Premium glassmorphism ticket cards
/// - Gold gradient accents and elegant typography
/// - Full Light/Dark mode compliance
/// - NO animations (static luxury design)
class TicketsView extends StatefulWidget {
  const TicketsView({super.key});

  @override
  State<TicketsView> createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {
  void _setSystemUI(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _setSystemUI(context);
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withValues(alpha: 0.95),
              luxury.surfaceElevated,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Custom luxury app bar
                  _buildLuxuryAppBar(colorScheme, luxury),

                  // Tickets content
                  Expanded(
                    child: BlocBuilder<SupportCubit, SupportState>(
                      builder: (context, state) {
                        if (state.isLoading && state.tickets.isEmpty) {
                          return _buildLoadingState(colorScheme, luxury);
                        }
                        final tickets = state.tickets;
                        if (tickets.isEmpty) {
                          return _buildEmptyState(colorScheme, luxury);
                        }
                        return RefreshIndicator(
                          onRefresh: () => context.read<SupportCubit>().refreshTickets(),
                          color: luxury.gold,
                          backgroundColor: luxury.surfaceElevated,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                            itemCount: tickets.length,
                            itemBuilder: (context, index) {
                              final t = tickets[index];
                              return _LuxuryTicketItem(ticket: t, index: index);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _LuxuryFAB(
        onPressed: () => _showCreateTicketSheet(context),
      ),
    );
  }

  Widget _buildLuxuryAppBar(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Back button
          _LuxuryIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 16.w),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CONTACT US',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: luxury.gold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Support Tickets',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50.w,
            height: 50.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(luxury.gold),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading tickets...',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, LuxuryThemeExtension luxury) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [luxury.textTertiary, luxury.gold.withValues(alpha: 0.5)],
              ).createShader(bounds);
            },
            child: Icon(
              Icons.confirmation_number_outlined,
              color: colorScheme.onPrimary,
              size: 48.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No tickets yet',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Create your first support ticket',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: luxury.textTertiary,
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

    final supportCubit = context.read<SupportCubit>();
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return BlocProvider.value(
          value: supportCubit,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  luxury.surfaceElevated,
                  colorScheme.surface,
                ],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              border: Border.all(
                color: luxury.gold.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: _LuxuryCreateTicketForm(
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
          ),
        );
      },
    );
  }
}

// ============================================================================
// LUXURY ICON BUTTON
// ============================================================================

class _LuxuryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _LuxuryIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              luxury.surfaceElevated,
              colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: luxury.gold.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                colorScheme.onSurface,
                luxury.gold.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Icon(
            icon,
            color: colorScheme.onPrimary,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LUXURY FAB
// ============================================================================

class _LuxuryFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const _LuxuryFAB({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: luxury.gold.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              color: colorScheme.onPrimary,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'New Ticket',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// LUXURY TICKET ITEM
// ============================================================================

class _LuxuryTicketItem extends StatelessWidget {
  final SupportTicket ticket;
  final int index;

  const _LuxuryTicketItem({required this.ticket, required this.index});

  Color _getStatusColor(BuildContext context, TicketStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    switch (status) {
      case TicketStatus.open:
        return colorScheme.primary;
      case TicketStatus.inProgress:
        return luxury.gold;
      case TicketStatus.waitingOnCustomer:
        return colorScheme.secondary;
      case TicketStatus.resolved:
        return luxury.success;
      case TicketStatus.closed:
        return colorScheme.outline;
    }
  }

  IconData _getStatusIcon(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return Icons.fiber_new_rounded;
      case TicketStatus.inProgress:
        return Icons.sync_rounded;
      case TicketStatus.waitingOnCustomer:
        return Icons.hourglass_bottom_rounded;
      case TicketStatus.resolved:
        return Icons.check_circle_rounded;
      case TicketStatus.closed:
        return Icons.cancel_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    final statusColor = _getStatusColor(context, ticket.status);

    // Alternate colors for visual interest
    final accentColors = [
      [colorScheme.primary, colorScheme.secondary],
      [luxury.gold, luxury.goldLight],
      [colorScheme.secondary, colorScheme.primary],
    ];
    final colors = accentColors[index % accentColors.length];

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            luxury.surfaceElevated,
            colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: luxury.gold.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              // Icon container
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors[0].withValues(alpha: 0.2),
                      colors[1].withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors[0].withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(colors: colors).createShader(bounds);
                  },
                  child: Icon(
                    Icons.confirmation_number_rounded,
                    color: colorScheme.onPrimary,
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Title
              Expanded(
                child: Text(
                  ticket.subject,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Info row
          Row(
            children: [
              // Category chip
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.surface,
                      luxury.surfaceElevated,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  ticket.category.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: luxury.textTertiary,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // Status chip
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      statusColor.withValues(alpha: 0.15),
                      statusColor.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(ticket.status),
                      size: 12.sp,
                      color: statusColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      ticket.status.displayName,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LUXURY CREATE TICKET FORM
// ============================================================================

class _LuxuryCreateTicketForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<String> onSubjectChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<SupportCategory> onCategoryChanged;
  final SupportCategory initialCategory;
  final VoidCallback onSubmit;

  const _LuxuryCreateTicketForm({
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

    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 12.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
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
                // Handle bar
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),

                // Title
                Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: [luxury.gold, luxury.goldLight],
                        ).createShader(bounds);
                      },
                      child: Icon(
                        Icons.add_circle_rounded,
                        color: colorScheme.onPrimary,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'New Support Ticket',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Subject field
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    labelStyle: GoogleFonts.inter(
                      color: luxury.textTertiary,
                    ),
                    filled: true,
                    fillColor: luxury.surfaceElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: luxury.gold.withValues(alpha: 0.15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                  ),
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter a subject';
                    }
                    return null;
                  },
                  onChanged: onSubjectChanged,
                ),
                SizedBox(height: 14.h),

                // Category dropdown
                DropdownButtonFormField<SupportCategory>(
                  value: initialCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: GoogleFonts.inter(
                      color: luxury.textTertiary,
                    ),
                    filled: true,
                    fillColor: luxury.surfaceElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: luxury.gold.withValues(alpha: 0.15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                  ),
                  dropdownColor: luxury.surfaceElevated,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  items: SupportCategory.values
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.displayName),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) onCategoryChanged(v);
                  },
                ),
                SizedBox(height: 14.h),

                // Description field
                TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: GoogleFonts.inter(
                      color: luxury.textTertiary,
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: luxury.surfaceElevated,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: luxury.gold.withValues(alpha: 0.15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                  ),
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please describe your issue';
                    }
                    return null;
                  },
                  onChanged: onDescriptionChanged,
                ),
                SizedBox(height: 20.h),

                // Submit button
                GestureDetector(
                  onTap: isCreating ? null : onSubmit,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.secondary,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: luxury.gold.withValues(alpha: 0.25),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isCreating
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : Text(
                              'Submit Ticket',
                              style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimary,
                              ),
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
