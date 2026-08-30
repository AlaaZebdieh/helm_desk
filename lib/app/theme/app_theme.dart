import 'package:flutter/material.dart';

import '../config/app_fonts.dart';
import 'app_custom_colors.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme(Locale locale) {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.offWhite,
      fontFamily: locale.languageCode == "ar"
          ? AppFonts.fontFamilyAr
          : AppFonts.fontFamilyEn,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.white,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textSecondary,
        onError: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
      ),
      extensions: [
        AppCustomColors(
          primarySoft: AppColors.primarySoft,
          primaryMuted: AppColors.primaryMuted,
          primaryStrong: AppColors.primaryStrong,
          secondarySoft: AppColors.secondarySoft,
          textPrimary: AppColors.textPrimary,
          textSecondary: AppColors.textSecondary,
          border: AppColors.border,
          shadow: AppColors.shadow,
          disabled: AppColors.disabled,
          surfaceLight: AppColors.surfaceLight,
          backgroundSelect: AppColors.backgroundSelect,
        ),
      ],
    );
  }

  static ThemeData darkTheme(Locale locale) {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.primaryStrong,
      fontFamily: locale.languageCode == "ar"
          ? AppFonts.fontFamilyAr
          : AppFonts.fontFamilyEn,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.white,
        onPrimary: AppColors.textPrimaryDark,
        onSecondary: AppColors.textSecondaryDark,
        onError: AppColors.textPrimaryDark,
        onSurface: AppColors.textPrimaryDark,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
      ),
      extensions: [
        AppCustomColors(
          primarySoft: AppColors.primarySoftDark,
          primaryMuted: AppColors.primaryMutedDark,
          primaryStrong: AppColors.primaryStrongDark,
          secondarySoft: AppColors.secondarySoftDark,
          textPrimary: AppColors.textPrimaryDark,
          textSecondary: AppColors.textSecondaryDark,
          border: AppColors.borderDark,
          shadow: AppColors.shadowDark,
          disabled: AppColors.disabledDark,
          surfaceLight: AppColors.surfaceLightDark,
          backgroundSelect: AppColors.backgroundSelectDark,
        ),
      ],
    );
  }
}
