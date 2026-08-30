import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/extensions/string_extensions.dart';
import '../utils/extensions/context_extensions.dart';

class AppTextField extends StatelessWidget {
  final int maxLines;
  final int? maxLength;

  final double height;
  final double borderRadius;

  final String? hintText;
  final String? titleText;
  final String? textRequired;

  final bool isEnable;
  final bool readOnly;
  final bool autofocus;
  final bool autocorrect;
  final bool? isRequired;
  final bool isArabicOnly;
  final bool isEnglishOnly;
  final bool isObsecureText;
  final bool enableSuggestions;

  final Color? textColor;
  final Color? hintColor;
  final Color? titleColor;
  final Color? borderColor;
  final Color? backgroundColor;

  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? titleWidget;

  final TextAlign textAlign;
  final FocusNode? focusNode;
  final TextInputType textInputType;

  final TextDirection? textDirection;
  final TextDirection? inputDirection;
  final TextDirection? hintTextDirection;

  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final CrossAxisAlignment? crossAxisAlignment;

  final EdgeInsetsGeometry? contentPadding;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;

  final bool Function(String)? condition;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  final List<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    this.maxLines = 1,
    this.maxLength,
    this.height = 48,
    this.borderRadius = 10,
    this.hintText,
    this.titleText,
    this.textRequired,
    this.isEnable = true,
    this.readOnly = false,
    this.autofocus = false,
    this.autocorrect = false,
    this.isRequired,
    this.isArabicOnly = false,
    this.isEnglishOnly = false,
    this.isObsecureText = false,
    this.enableSuggestions = false,
    this.textColor,
    this.hintColor,
    this.titleColor,
    this.borderColor,
    this.backgroundColor,
    this.suffixIcon,
    this.prefixIcon,
    this.titleWidget,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.textInputType = TextInputType.name,
    this.textDirection,
    this.inputDirection,
    this.hintTextDirection,
    required this.controller,
    this.textInputAction,
    this.crossAxisAlignment,
    this.contentPadding,
    this.suffixIconConstraints,
    this.prefixIconConstraints,
    this.condition,
    this.onChanged,
    this.onSubmitted,
    this.autofillHints,
    this.inputFormatters,
  });

  Widget _buildTitle(BuildContext context) {
    if (titleWidget != null) return titleWidget!;
    if (titleText != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(
          titleText!,
          style: AppTextStyles.bodyMedium(
            context,
            color: titleColor ?? context.customColors.textPrimary,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String _filterText(String text, bool arabic, bool english) {
    String newText = text;
    if (arabic && !newText.isArabicOnly) newText = newText.toArabicOnly;
    if (english && !newText.isEnglishOnly) newText = newText.toEnglishOnly;
    return newText;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final customColors = context.customColors;
    final hasIcon = suffixIcon != null || prefixIcon != null;
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        Directionality(
          textDirection:
              inputDirection ??
              (textInputType == TextInputType.phone || context.isEnglish
                  ? TextDirection.ltr
                  : TextDirection.rtl),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.r,
                color: borderColor ?? customColors.border,
              ),
              color: backgroundColor ?? colors.surface,
              borderRadius: BorderRadius.circular(borderRadius.r),
            ),
            child: TextField(
              focusNode: focusNode,
              keyboardType: textInputType,
              controller: controller,
              enableSuggestions: enableSuggestions,
              autocorrect: autocorrect,
              autofocus: autofocus,
              autofillHints: autofillHints,
              textCapitalization: TextCapitalization.words,
              textInputAction: textInputAction ?? TextInputAction.next,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              maxLines: maxLines,
              enabled: isEnable,
              readOnly: readOnly,
              obscureText: isObsecureText,
              obscuringCharacter: '\u25cf',
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              cursorColor: colors.primary,
              textAlign: textAlign,
              cursorHeight: 20.h,
              textDirection: textDirection,
              style: AppTextStyles.subTitle(context),
              decoration: InputDecoration(
                isDense: hasIcon,
                contentPadding:
                    contentPadding ??
                    EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: hasIcon ? 8.h : 10.h,
                    ),
                constraints: BoxConstraints(
                  minHeight: maxLines > 1 ? 0 : height.h,
                  maxHeight: maxLines > 1 || hasIcon
                      ? double.infinity
                      : height.h,
                  maxWidth: double.infinity,
                  minWidth: double.infinity,
                ),
                hintText: hintText,
                hintTextDirection: hintTextDirection,
                hintStyle: AppTextStyles.bodyMedium(
                  context,
                  fontSize: 12,
                  color: hintColor ?? customColors.textSecondary,
                ),
                suffixIconConstraints: suffixIconConstraints ??
                    (suffixIcon != null
                        ? BoxConstraints(minWidth: 40.w, minHeight: 40.h)
                        : null),
                suffixIcon: suffixIcon,
                prefixIconConstraints: prefixIconConstraints ??
                    (prefixIcon != null
                        ? BoxConstraints(minWidth: 40.w, minHeight: 40.h)
                        : null),
                prefixIcon: prefixIcon,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(borderRadius.r),
                  ),
                  borderSide: BorderSide.none,
                  gapPadding: 0,
                ),
              ),
            ),
          ),
        ),
        if ((condition != null && textRequired != null) ||
            isArabicOnly ||
            isEnglishOnly)
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              String errorLang = "";
              String filteredText = _filterText(
                value.text,
                isArabicOnly,
                isEnglishOnly,
              );

              if (filteredText != value.text) {
                if (isArabicOnly && !value.text.isArabicOnly) {
                  errorLang = context.translate("only_arabic_text_is_allowed");
                } else if (isEnglishOnly && !value.text.isEnglishOnly) {
                  errorLang = context.translate("only_english_text_is_allowed");
                }

                final selectionIndex =
                    controller.selection.baseOffset -
                    (value.text.length - filteredText.length);

                controller.value = TextEditingValue(
                  text: filteredText,
                  selection: TextSelection.collapsed(
                    offset: selectionIndex.clamp(0, filteredText.length),
                  ),
                );
              }

              if ((condition != null && condition!(filteredText)) ||
                  errorLang.isNotEmpty) {
                return Padding(
                  padding: EdgeInsetsDirectional.only(start: 6.w, top: 3.h),
                  child: Text(
                    errorLang.isNotEmpty ? errorLang : textRequired!,
                    style: AppTextStyles.bodyMedium(
                      context,
                      fontSize: 10,
                      color: AppColors.error,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }
}
