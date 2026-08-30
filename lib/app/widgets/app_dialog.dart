import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/utils/extensions/context_extensions.dart';

class AppDialog extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Animation<double> a1;
  final Animation<double> a2;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final Color? backgroundColor;
  final double blurSigma;

  const AppDialog({
    super.key,
    required this.child,
    required this.borderRadius,
    required this.a1,
    required this.a2,
    this.margin,
    this.alignment,
    this.backgroundColor,
    this.blurSigma = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? context.colors.surface;
    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1).animate(a1),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.5, end: 1).animate(a1),
        child: Material(
          type: MaterialType.transparency,
          child: Align(
            alignment: alignment ?? Alignment.bottomCenter,
            child: StatefulBuilder(
              builder: (context, setState) {
                return BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurSigma.w,
                    sigmaY: blurSigma.h,
                  ),
                  child: Container(
                    margin:
                        margin ??
                        EdgeInsets.only(
                          left: 25.w,
                          right: 25.w,
                          top: context.topPadding + 16.h,
                          bottom: context.bottomPadding + 16.h,
                        ),
                    padding: EdgeInsets.symmetric(
                      vertical: 24.h,
                      horizontal: 32.w,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(borderRadius.r),
                    ),
                    child: ScrollConfiguration(
                      behavior: const ScrollBehavior(),
                      child: SingleChildScrollView(child: child),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
