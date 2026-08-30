import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/utils/extensions/context_extensions.dart';

class LoadingHelper {
  /// 🔹 Simple Circular Indicator (no center)
  static Widget circular(
    BuildContext context, {
    Color? color,
    double strokeWidth = 4.0,
    EdgeInsetsGeometry? padding,
  }) {
    final colors = context.colors;
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth.r,
        color: color ?? colors.secondary,
      ),
    );
  }

  /// 🔹 Circular Indicator centered
  static Widget circularCentered(
    BuildContext context, {
    Color? color,
    double strokeWidth = 4.0,
    EdgeInsetsGeometry? padding,
  }) {
    final colors = context.colors;
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth.r,
          color: color ?? colors.secondary,
        ),
      ),
    );
  }

  /// 🔹 SpinKit loading without background
  static Widget spinKit(
    BuildContext context, {
    Color? color,
    double size = 75.0,
    EdgeInsetsGeometry? padding,
  }) {
    final colors = context.colors;
    return Container(
      padding: padding ?? EdgeInsets.only(top: 170.h),
      child: SpinKitDoubleBounce(
        color: color ?? colors.secondary,
        size: size.r,
      ),
    );
  }

  /// 🔹 SpinKit loading with semi-transparent overlay background
  static Widget overlay(
    BuildContext context, {
    Color? color,
    double size = 75.0,
    BoxDecoration? decoration,
    EdgeInsetsGeometry? padding,
  }) {
    final colors = context.colors;
    return Container(
      width: context.width,
      height: context.height,
      decoration: decoration ??
          BoxDecoration(color: colors.surface.withValues(alpha: 0.1)),
      padding: padding ?? EdgeInsets.only(top: 170.h),
      child: Center(
        child: SpinKitDoubleBounce(
          color: color ?? colors.secondary,
          size: size.r,
        ),
      ),
    );
  }

  /// 🔹 Pagination loading indicator (e.g., for ListView load more)
  static Widget pagination(
    BuildContext context, {
    Color? color,
    double size = 30.0,
  }) {
    final colors = context.colors;
    return Center(
      child: SpinKitThreeBounce(color: color ?? colors.secondary, size: size.r),
    );
  }
}
