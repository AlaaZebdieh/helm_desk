import 'package:flutter/material.dart';

class AppCustomColors extends ThemeExtension<AppCustomColors> {
  final Color primarySoft;
  final Color primaryMuted;
  final Color primaryStrong;

  final Color secondarySoft;

  final Color textPrimary;
  final Color textSecondary;

  final Color border;
  final Color shadow;
  final Color disabled;
  final Color surfaceLight;
  final Color backgroundSelect;

  const AppCustomColors({
    required this.primarySoft,
    required this.primaryMuted,
    required this.primaryStrong,
    //
    required this.secondarySoft,
    //
    required this.textPrimary,
    required this.textSecondary,
    //
    required this.border,
    required this.shadow,
    required this.disabled,
    required this.surfaceLight,
    required this.backgroundSelect,
  });

  @override
  AppCustomColors copyWith({
    Color? primarySoft,
    Color? primaryMuted,
    Color? primaryStrong,
    //
    Color? secondarySoft,
    //
    Color? textPrimary,
    Color? textSecondary,
    //
    Color? border,
    Color? shadow,
    Color? disabled,
    Color? surfaceLight,
    Color? backgroundSelect,
  }) {
    return AppCustomColors(
      primarySoft: primarySoft ?? this.primarySoft,
      primaryMuted: primaryMuted ?? this.primaryMuted,
      primaryStrong: primaryStrong ?? this.primaryStrong,
      //
      secondarySoft: secondarySoft ?? this.secondarySoft,
      //
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      //
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      disabled: disabled ?? this.disabled,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      backgroundSelect: backgroundSelect ?? this.backgroundSelect,
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) return this;
    return AppCustomColors(
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
      primaryStrong: Color.lerp(primaryStrong, other.primaryStrong, t)!,
      //
      secondarySoft: Color.lerp(secondarySoft, other.secondarySoft, t)!,
      //
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      //
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      backgroundSelect: Color.lerp(
        backgroundSelect,
        other.backgroundSelect,
        t,
      )!,
    );
  }
}
