import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';
import 'package:mygym/src/features/gyms/domain/entities/gym.dart';

/// Luxury Contact Info Section
///
/// Displays gym contact information in premium styled cards
/// with gold accents and elegant icons.
class BuildContactInfo extends StatelessWidget {
  final Gym gym;
  const BuildContactInfo({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    final contact = gym.contactInfo;
    if (contact == null) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;
    
    final items = <_ContactItem>[];
    if (contact.phone != null && contact.phone!.isNotEmpty) {
      items.add(_ContactItem(
        icon: Icons.phone_rounded,
        label: 'Phone',
        value: contact.phone!,
        gradientColors: [luxury.success, luxury.success.withValues(alpha: 0.7)],
      ));
    }
    if (contact.email != null && contact.email!.isNotEmpty) {
      items.add(_ContactItem(
        icon: Icons.email_rounded,
        label: 'Email',
        value: contact.email!,
        gradientColors: [colorScheme.primary, colorScheme.secondary],
      ));
    }
    if (contact.website != null && contact.website!.isNotEmpty) {
      items.add(_ContactItem(
        icon: Icons.public_rounded,
        label: 'Website',
        value: contact.website!,
        gradientColors: [luxury.gold, luxury.goldLight],
      ));
    }
    if (contact.whatsapp != null && contact.whatsapp!.isNotEmpty) {
      items.add(_ContactItem(
        icon: Icons.chat_rounded,
        label: 'WhatsApp',
        value: contact.whatsapp!,
        gradientColors: [const Color(0xFF25D366), const Color(0xFF128C7E)],
      ));
    }
    
    if (items.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with gold accent
        Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [
                    luxury.gold,
                    luxury.goldLight,
                  ],
                ).createShader(bounds);
              },
              child: Icon(
                Icons.contact_phone_rounded,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "Contact",
              style: GoogleFonts.montserrat(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        
        // Contact items grid
        ...items.map((item) => Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _LuxuryContactRow(item: item),
        )),
      ],
    );
  }
}

/// Contact item data
class _ContactItem {
  final IconData icon;
  final String label;
  final String value;
  final List<Color> gradientColors;

  _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradientColors,
  });
}

/// Premium contact row with gradient icon
class _LuxuryContactRow extends StatefulWidget {
  final _ContactItem item;

  const _LuxuryContactRow({required this.item});

  @override
  State<_LuxuryContactRow> createState() => _LuxuryContactRowState();
}

class _LuxuryContactRowState extends State<_LuxuryContactRow> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                luxury.surfaceElevated,
                colorScheme.surface,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: widget.item.gradientColors[0].withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon container with gradient
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.item.gradientColors[0].withValues(alpha: 0.2),
                      widget.item.gradientColors[1].withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: widget.item.gradientColors[0].withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: widget.item.gradientColors,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    widget.item.icon,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              
              // Label and value
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.label,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: luxury.textTertiary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.item.value,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Arrow indicator
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      luxury.textTertiary,
                      luxury.gold.withValues(alpha: 0.5),
                    ],
                  ).createShader(bounds);
                },
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
