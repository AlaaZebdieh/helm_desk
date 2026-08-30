import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../localization/app_localizations.dart';
import '../../theme/app_custom_colors.dart';
import '../../widgets/app_dialog.dart';

extension BuildContextX on BuildContext {
  // أبعاد الشاشة
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;

  double get topPadding => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
  double get topInsets => MediaQuery.of(this).viewInsets.top;
  double get bottomInsets => MediaQuery.of(this).viewInsets.bottom;

  bool get isCurrentScreen => ModalRoute.of(this)?.isCurrent == true;

  // Theme Access
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  AppCustomColors get customColors => theme.extension<AppCustomColors>()!;

  // الترجمة
  bool get isArabic => AppLocalizations.of(this)!.isArLocale;
  bool get isEnglish => AppLocalizations.of(this)!.isEnLocale;
  Locale get locale => AppLocalizations.of(this)!.locale;

  double heightImage({
    double subFromWidth = 0,
    int colsInRow = 1,
    int heightImage = 900,
    int widthImage = 1600,
  }) {
    return (heightImage * ((width - subFromWidth)) / colsInRow) / widthImage;
  }

  String translate(String key, {Map<String, String>? arguments}) {
    String translate = AppLocalizations.of(this)!.translate(key);
    if (arguments != null) {
      arguments.forEach((k, v) {
        translate = translate.replaceAll("{{$k}}", v);
      });
    }
    return translate;
  }

  void appDialog(
    Widget child, {
    double borderRadius = 18,
    bool barrierDismissible = true,
    Function(Object?)? onValue,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    Duration transitionDuration = const Duration(milliseconds: 200),
  }) {
    showGeneralDialog(
      context: this,
      barrierLabel: "",
      barrierDismissible: barrierDismissible,
      barrierColor: colors.shadow.withValues(alpha: 0.1),
      transitionDuration: transitionDuration,
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, a1, a2, widget) {
        return AppDialog(
          a1: a1,
          a2: a2,
          borderRadius: borderRadius,
          margin: margin,
          alignment: alignment,
          child: child,
        );
      },
    ).then(onValue ?? (_) {});
  }

  void appBottomSheet(
    Widget child, {
    Function(Object?)? onValue,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    showModalBottomSheet(
      context: this,
      elevation: 10.r,
      useSafeArea: true,
      enableDrag: enableDrag,
      isScrollControlled: true,
      isDismissible: isDismissible,
      backgroundColor: backgroundColor ?? colors.surface,
      barrierColor: colors.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      ),
      builder: (_) => child,
    ).then(onValue ?? (_) {});
  }
}
