import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../theme/app_colors.dart';
import '../../core/utils/url_validators.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;

  final double? height;
  final double? width;

  final Widget? child; // child فوق الصورة
  final Widget? placeholder; // لو بدك مكان shimmer

  final Color? color;
  final Gradient? gradient;

  final BoxFit fit;
  final BoxShape shape;
  final BoxBorder? border;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final BorderRadiusGeometry? borderRadius;

  final List<BoxShadow>? boxShadow;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.child,
    this.placeholder,
    this.color,
    this.gradient,
    this.fit = BoxFit.cover,
    this.shape = BoxShape.rectangle,
    this.border,
    this.margin,
    this.padding,
    this.alignment,
    this.borderRadius,
    this.boxShadow,
  });

  /// 🔹 شيمر واحد فقط، يعاد استخدامه
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.defaultBaseShimmer,
      highlightColor: AppColors.defaultHighlightShimmer,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: shape,
          border: border,
          color: AppColors.white,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 لو الرابط فاضي → شيمر
    if (!UrlValidators.isImageUrl(imageUrl)) {
      return placeholder ?? _buildShimmer();
    }

    return ClipRRect(
      borderRadius: shape == BoxShape.circle
          ? BorderRadius.circular(1000)
          : (borderRadius ?? BorderRadius.zero),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        imageBuilder: (context, imageProvider) {
          return Stack(
            children: [
              Container(
                padding: padding,
                alignment: alignment,
                margin: margin,
                decoration: BoxDecoration(
                  color: color,
                  shape: shape,
                  border: border,
                  boxShadow: boxShadow,
                  borderRadius: borderRadius,
                  image: DecorationImage(image: imageProvider, fit: fit),
                ),
                child: child,
              ),
              Container(decoration: BoxDecoration(gradient: gradient)),
            ],
          );
        },
        progressIndicatorBuilder: (_, __, ___) =>
            placeholder ?? _buildShimmer(),
        errorWidget: (_, __, ___) => placeholder ?? _buildShimmer(),
      ),
    );
  }
}
