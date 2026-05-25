import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle serif({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w500,
    double height = 1.3,
    double letterSpacing = 0,
    Color color = AppColors.onSurface,
  }) =>
      GoogleFonts.newsreader(
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );

  static TextStyle sans({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    double height = 1.5,
    double letterSpacing = 0,
    Color color = AppColors.onSurface,
  }) =>
      GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
      );

  static TextStyle get displayLg => serif(
        fontSize: 44,
        fontWeight: FontWeight.w500,
        height: 1.15,
      );

  static TextStyle get headlineLg => serif(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        height: 1.2,
      );

  static TextStyle get headlineMd => serif(
        fontSize: 26,
        fontWeight: FontWeight.w500,
        height: 1.25,
      );

  static TextStyle get titleSerif => serif(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.3,
      );

  static TextStyle get titleMd => sans(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get titleSm => sans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get bodyLg => sans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.65,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get bodyMd => sans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.onSurface,
      );

  static TextStyle get bodySm => sans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get label => sans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.onSurfaceVariant,
      );

  static TextStyle get caption => sans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.muted,
      );

  static TextStyle get caps => sans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: AppColors.muted,
      );

  static TextStyle get button => sans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );
}
