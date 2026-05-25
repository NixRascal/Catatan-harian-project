import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final base = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.primaryOn,
      primaryContainer: AppColors.surfaceLow,
      onPrimaryContainer: AppColors.primary,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.surfaceContainer,
      onSecondaryContainer: AppColors.onSurface,
      tertiary: AppColors.primary,
      onTertiary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      shadow: const Color(0x14000000),
      scrim: const Color(0x80000000),
      inverseSurface: AppColors.onSurface,
      onInverseSurface: AppColors.surface,
      inversePrimary: AppColors.primaryHover,
    );

    final textTheme = GoogleFonts.interTextTheme(
      const TextTheme().apply(
        bodyColor: AppColors.onSurface,
        displayColor: AppColors.onSurface,
      ),
    ).copyWith(
      displayLarge: AppTypography.displayLg,
      displayMedium: AppTypography.headlineLg,
      displaySmall: AppTypography.headlineMd,
      headlineLarge: AppTypography.headlineLg,
      headlineMedium: AppTypography.headlineMd,
      headlineSmall: AppTypography.titleSerif,
      titleLarge: AppTypography.titleMd,
      titleMedium: AppTypography.titleMd,
      titleSmall: AppTypography.titleSm,
      bodyLarge: AppTypography.bodyLg,
      bodyMedium: AppTypography.bodyMd,
      bodySmall: AppTypography.bodySm,
      labelLarge: AppTypography.button,
      labelMedium: AppTypography.label,
      labelSmall: AppTypography.caption,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      highlightColor: AppColors.hover,
      hoverColor: AppColors.hover,
      dividerColor: AppColors.outlineVariant,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.onSurface, size: 22),
        titleTextStyle: AppTypography.titleMd,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryOn,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.br8),
          textStyle: AppTypography.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.br8),
          textStyle: AppTypography.button.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.onSurface,
          side: const BorderSide(color: AppColors.outlineVariant),
          shape: RoundedRectangleBorder(borderRadius: AppSpacing.br8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: AppTypography.button,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.onSurfaceVariant,
          highlightColor: AppColors.hover,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryOn,
        elevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        extendedTextStyle: AppTypography.button,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.br16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
        hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.muted),
        labelStyle: AppTypography.label,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.br16),
        titleTextStyle: AppTypography.titleSerif,
        contentTextStyle: AppTypography.bodyMd,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.onSurface,
        contentTextStyle: AppTypography.bodyMd.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.br8),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceLow,
        labelStyle: AppTypography.label,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.br8),
        side: const BorderSide(color: Colors.transparent),
      ),
    );
  }
}
