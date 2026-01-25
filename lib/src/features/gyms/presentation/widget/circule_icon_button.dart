import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mygym/src/core/theme/luxury_theme_extension.dart';

/// Luxury Circular Icon Button
///
/// Premium styled button with glassmorphism effect,
/// gold border accent, and press animation.
class CirculeIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  
  const CirculeIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
  });

  @override
  State<CirculeIconButton> createState() => _CirculeIconButtonState();
}

class _CirculeIconButtonState extends State<CirculeIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final luxury = context.luxury;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                luxury.surfaceElevated.withValues(alpha: 0.85),
                colorScheme.surface.withValues(alpha: 0.75),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: luxury.gold.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              widget.icon,
              color: widget.iconColor,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}