import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose Your Plan",
          style: GoogleFonts.playfairDisplay(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h,),
        Text(
          "Unlock access to premium gyms across the city",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600]
          ),
        )
      ],
    );
  }
}