import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/extensions/context_extensions.dart';

class AppTextStyles {
  /// Display Large (was H1)
  static TextStyle titleLarge(
    BuildContext context, {
    double? height,
    double fontSize = 14,
    double? decorationThickness,
    String? fontFamily,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    List<Shadow>? shadows,
  }) =>
      TextStyle(
        height: height,
        fontSize: fontSize.sp,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        color: color ?? context.customColors.textPrimary,
        decorationColor: decorationColor,
        decoration: decoration,
        shadows: shadows,
        fontWeight: FontWeight.w900,
      );

  /// Display Medium (was H2)
  static TextStyle titleMedium(
    BuildContext context, {
    double? height,
    double fontSize = 14,
    double? decorationThickness,
    String? fontFamily,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    List<Shadow>? shadows,
  }) =>
      TextStyle(
        height: height,
        fontSize: fontSize.sp,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        color: color ?? context.customColors.textPrimary,
        decorationColor: decorationColor,
        decoration: decoration,
        shadows: shadows,
        fontWeight: FontWeight.w700,
      );

  /// Title Large (was subtitle1)
  static TextStyle subTitle(
    BuildContext context, {
    double? height,
    double fontSize = 14,
    double? decorationThickness,
    String? fontFamily,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    List<Shadow>? shadows,
  }) =>
      TextStyle(
        height: height,
        fontSize: fontSize.sp,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        color: color ?? context.customColors.textPrimary,
        decorationColor: decorationColor,
        decoration: decoration,
        shadows: shadows,
        fontWeight: FontWeight.w500,
      );

  /// Body Large (was body1)
  static TextStyle bodyLarge(
    BuildContext context, {
    double? height,
    double fontSize = 14,
    double? decorationThickness,
    String? fontFamily,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    List<Shadow>? shadows,
  }) =>
      TextStyle(
        height: height,
        fontSize: fontSize.sp,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        color: color ?? context.customColors.textPrimary,
        decorationColor: decorationColor,
        decoration: decoration,
        shadows: shadows,
        fontWeight: FontWeight.w400,
      );

  /// Body Medium (was body2)
  static TextStyle bodyMedium(
    BuildContext context, {
    double? height,
    double fontSize = 14,
    double? decorationThickness,
    String? fontFamily,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    List<Shadow>? shadows,
  }) =>
      TextStyle(
        height: height,
        fontSize: fontSize.sp,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        color: color ?? context.customColors.textPrimary,
        decorationColor: decorationColor,
        decoration: decoration,
        shadows: shadows,
        fontWeight: FontWeight.w300,
      );

  /// Button
  static TextStyle button(
    BuildContext context, {
    double? height,
    double fontSize = 14,
    double? decorationThickness,
    String? fontFamily,
    Color? color,
    Color? decorationColor,
    TextDecoration? decoration,
    List<Shadow>? shadows,
  }) =>
      TextStyle(
        height: height,
        fontSize: fontSize.sp,
        decorationThickness: decorationThickness,
        fontFamily: fontFamily,
        color: color ?? context.customColors.textPrimary,
        decorationColor: decorationColor,
        decoration: decoration,
        shadows: shadows,
        fontWeight: FontWeight.w600,
      );
}
