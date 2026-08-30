import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/assets.gen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/extensions/context_extensions.dart';

import 'dropdown_search_field.dart';

class AppDropdown<T> extends StatelessWidget {
  final String? hint;
  final String? title;
  final String? textRequired;

  final bool isRequired;
  final bool isSearchable;
  final bool isEnableChange;

  final double height;
  final double fontSize;
  final double borderWidth;
  final double borderRadius;

  final Color? iconColor;
  final Color? hintColor;
  final Color? titleColor;
  final Color? borderColor;
  final Color? backgroundColor;

  final SvgGenImage? icon;

  final List<T> items;

  final void Function(T?)? onChanged;
  final String Function(T)? itemLabel;
  final ValueNotifier<T?> selectedValue;
  final bool Function(T?)? showErrorCondition;

  final EdgeInsetsGeometry? padding;
  final TextEditingController? searchController;

  const AppDropdown({
    super.key,
    this.hint,
    this.title,
    this.textRequired,
    this.isRequired = false,
    this.isSearchable = false,
    this.isEnableChange = true,
    this.height = 48,
    this.fontSize = 14,
    this.borderWidth = 1,
    this.borderRadius = 10,
    this.iconColor,
    this.hintColor,
    this.titleColor,
    this.borderColor,
    this.backgroundColor,
    this.icon,
    required this.items,
    this.onChanged,
    this.itemLabel,
    required this.selectedValue,
    this.showErrorCondition,
    this.padding,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final customColors = context.customColors;
    final controller = searchController ?? TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: padding ?? EdgeInsets.only(bottom: 6.h),
            child: Text(
              title!,
              style: AppTextStyles.bodyMedium(
                context,
                color: titleColor ?? customColors.textPrimary,
              ),
            ),
          ),
        ValueListenableBuilder<T?>(
          valueListenable: selectedValue,
          builder: (context, value, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton2<T>(
                    isExpanded: true,
                    value: value,
                    hint: Row(
                      children: [
                        if (icon != null)
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: 12.w),
                            child: SvgPicture.asset(icon!.path, height: 24.h),
                          ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            hint ?? "",
                            style: AppTextStyles.bodyMedium(
                              context,
                              fontSize: 12,
                              color: hintColor ?? customColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    selectedItemBuilder: (context) => items.map((e) {
                      final label = itemLabel != null
                          ? itemLabel!(e)
                          : e.toString();
                      return Row(
                        children: [
                          if (icon != null)
                            Padding(
                              padding: EdgeInsetsDirectional.only(start: 12.w),
                              child: SvgPicture.asset(icon!.path, height: 24.h),
                            ),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              label,
                              style: AppTextStyles.subTitle(
                                context,
                                color: hintColor,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    items: items.map((item) {
                      final label = itemLabel != null
                          ? itemLabel!(item)
                          : item.toString();
                      return DropdownMenuItem<T>(
                        value: item,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            label,
                            style: AppTextStyles.bodyLarge(
                              context,
                              color: customColors.textPrimary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (isEnableChange) selectedValue.value = val;
                      if (onChanged != null) onChanged!(val);
                    },
                    buttonStyleData: ButtonStyleData(
                      height: height.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: backgroundColor ?? colors.surface,
                        borderRadius: BorderRadius.circular(borderRadius.r),
                        border: Border.all(
                          color: borderColor ?? customColors.border,
                          width: borderWidth.r,
                        ),
                      ),
                    ),
                    iconStyleData: IconStyleData(
                      icon: Container(
                        margin: EdgeInsetsDirectional.only(end: 16.w),
                        child: SvgPicture.asset(
                          Assets.vectors.dropdown.path,
                          colorFilter: iconColor != null
                              ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                              : ColorFilter.mode(
                                  colors.primary,
                                  BlendMode.srcIn,
                                ),
                          width: 12.w,
                        ),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: context.height * 0.4,
                      decoration: BoxDecoration(
                        color: backgroundColor ?? colors.surface,
                        borderRadius: BorderRadius.circular(borderRadius.r),
                        border: Border.all(
                          color: borderColor ?? customColors.border,
                          width: borderWidth.r,
                        ),
                      ),
                    ),
                    dropdownSearchData: isSearchable
                        ? DropdownSearchData(
                            searchController: controller,
                            searchInnerWidgetHeight: 50.h + 16.h,
                            searchInnerWidget: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: DropdownSearchField(
                                controller: controller,
                                hintText: context.translate("search"),
                              ),
                            ),
                            searchMatchFn:
                                (DropdownMenuItem<T> item, String searchValue) {
                                  final label = itemLabel != null
                                      ? itemLabel!(item.value as T)
                                      : item.value.toString();
                                  return label.toLowerCase().contains(
                                    searchValue.toLowerCase(),
                                  );
                                },
                          )
                        : null,
                    onMenuStateChange: isSearchable
                        ? (isOpen) {
                            if (!isOpen) {
                              controller.clear();
                            }
                          }
                        : null,
                  ),
                ),
                if (showErrorCondition != null && textRequired != null)
                  if (showErrorCondition!(value))
                    Padding(
                      padding: EdgeInsets.only(top: 3.h, left: 6.w),
                      child: Text(
                        textRequired!,
                        style: AppTextStyles.bodyMedium(
                          context,
                          fontSize: 10,
                          color: AppColors.error,
                        ),
                      ),
                    ),
              ],
            );
          },
        ),
      ],
    );
  }
}
