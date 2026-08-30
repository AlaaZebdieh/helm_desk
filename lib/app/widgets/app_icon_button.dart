import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/assets.gen.dart';

class AppIconButton extends StatelessWidget {
  final SvgGenImage? icon;
  final bool flipX;
  final bool flipY;

  final double? width;
  final double? height;
  final double? radius;
  final double? iconWidth;
  final double? iconHeight;
  final double splashRadius;

  final Color? iconColor;
  final Color? backgroundColor;

  final Widget? widget;

  final BoxShape shape;
  final BoxBorder? border;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  final VoidCallback onClickEvent;

  final List<BoxShadow>? boxShadow;

  const AppIconButton({
    super.key,
    this.icon,
    this.flipX = false,
    this.flipY = false,
    this.width,
    this.height,
    this.radius,
    this.iconWidth,
    this.iconHeight,
    this.splashRadius = 18,
    this.iconColor,
    this.backgroundColor = Colors.transparent,
    this.widget,
    this.shape = BoxShape.rectangle,
    this.border,
    this.margin,
    this.padding,
    this.borderRadius,
    required this.onClickEvent,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIcon =
        widget ??
        Transform.flip(
          flipX: flipX,
          flipY: flipY,
          child: SvgPicture.asset(
            (icon ?? Assets.vectors.back).path,
            height: iconHeight,
            width: iconWidth,
            colorFilter: iconColor != null
                ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                : null,
          ),
        );

    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        shape: shape,
        borderRadius:
            borderRadius ??
            (radius != null ? BorderRadius.circular(radius!) : null),
        boxShadow: boxShadow,
      ),
      child: IconButton(
        onPressed: onClickEvent,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          maxHeight: height ?? double.infinity,
          minHeight: height ?? 0,
          maxWidth: width ?? double.infinity,
          minWidth: width ?? 0,
        ),
        splashRadius: splashRadius.r,
        icon: effectiveIcon,
      ),
    );
  }
}
