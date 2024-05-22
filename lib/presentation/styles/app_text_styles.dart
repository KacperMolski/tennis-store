import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tennis_store/presentation/styles/app_color_styles.dart';

class AppTextStyles {
  static TextStyle headerText() {
    return TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontSize: 70.0,
      fontWeight: FontWeight.w900,
      height: 1,
      color: AppColorStyles.primary,
    );
  }

  static TextStyle subtitleText() {
    return TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontSize: 70.0,
      fontWeight: FontWeight.w900,
      height: 1,
      color: AppColorStyles.secondary,
    );
  }

  static TextStyle titleConfiguration() {
    return TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontSize: 70.0,
      fontWeight: FontWeight.normal,
      height: 1,
      color: AppColorStyles.primary,
    );
  }

  static TextStyle buttonText(bool isMain) {
    return TextStyle(
      fontFamily: GoogleFonts.archivo().fontFamily,
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
      color: isMain ? AppColorStyles.mainButton : AppColorStyles.primary,
    );
  }

  static TextStyle loginSmallEmail() {
    return TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontSize: 30.0,
      fontWeight: FontWeight.normal,
      color: AppColorStyles.primary,
    );
  }

  static TextStyle loginSmalltextButton() {
    return TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontSize: 30.0,
      fontWeight: FontWeight.normal,
      color: AppColorStyles.secondary,
      decoration: TextDecoration.underline,
      decorationColor: AppColorStyles.secondary,
    );
  }

  static TextStyle circuralProcess() {
    return TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontSize: 30.0,
      fontWeight: FontWeight.w600,
      color: AppColorStyles.blackText,
    );
  }

  static TextStyle miniCircuralProcess() {
    return TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: AppColorStyles.blackText,
    );
  }
}
