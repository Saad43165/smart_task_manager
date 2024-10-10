import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppStyles {
  static final headingStyle = GoogleFonts.poppins(
    color: AppColors.textColor,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static final bodyTextStyle = GoogleFonts.poppins(
    color: AppColors.textColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static final buttonTextStyle = GoogleFonts.poppins(
    color: AppColors.lightTextColor,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
}
