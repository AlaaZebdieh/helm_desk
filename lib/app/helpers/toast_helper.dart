import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../widgets/app_icon_button.dart';
import '../utils/extensions/context_extensions.dart';

class ToastHelper {
  static final ToastHelper _instance = ToastHelper._internal();
  factory ToastHelper() => _instance;
  ToastHelper._internal();

  OverlayEntry? _currentToast;

  /// الدالة الداخلية لإظهار toast
  void _showToast(
    BuildContext context,
    String Function(BuildContext) msg, {
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 4),
  }) {
    // إزالة أي toast قديم
    _currentToast?.remove();

    _currentToast = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 10.h,
        left: 14.w,
        right: 14.w,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            left: false,
            right: false,
            top: false,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta != null && details.primaryDelta! > 5) {
                  _currentToast?.remove();
                  _currentToast = null;
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: AppColors.white, size: 22.h),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        msg(context),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    AppIconButton(
                      onClickEvent: () {
                        _currentToast?.remove();
                        _currentToast = null;
                      },
                      height: 26.h,
                      width: 26.h,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(width: 1.r, color: AppColors.white),
                      widget: SvgPicture.asset(
                        Assets.vectors.exit.path,
                        height: 22.h,
                        width: 22.h,
                        colorFilter: ColorFilter.mode(
                          AppColors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_currentToast!);

    Future.delayed(duration, () {
      _currentToast?.remove();
      _currentToast = null;
    });
  }

  /// رسالة نجاح
  void success(BuildContext context, {String Function(BuildContext)? msg}) {
    _showToast(
      context,
      msg ?? (ctx) => context.translate("operation_completed_successfully"),
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline,
    );
  }

  /// رسالة خطأ
  void error(BuildContext context, {String Function(BuildContext)? msg}) {
    _showToast(
      context,
      msg ?? (ctx) => context.translate("unexpected_error"),
      backgroundColor: AppColors.error,
      icon: Icons.error_outline,
    );
  }

  /// رسالة تحذير
  void warning(
    BuildContext context, {
    required String Function(BuildContext) msg,
  }) {
    _showToast(
      context,
      msg,
      backgroundColor: AppColors.warning,
      icon: Icons.info_outline,
    );
  }

  /// رسالة انترنت متصل
  void networkConnected(
    BuildContext context, {
    String Function(BuildContext)? msg,
  }) {
    _showToast(
      context,
      msg ?? (ctx) => ctx.translate("network_connected"),
      backgroundColor: AppColors.success,
      icon: Icons.wifi_rounded,
    );
  }

  /// رسالة انترنت غير متصل
  void networkDisconnected(
    BuildContext context, {
    String Function(BuildContext)? msg,
  }) {
    _showToast(
      context,
      msg ?? (ctx) => ctx.translate("network_disconnected"),
      backgroundColor: AppColors.error,
      icon: Icons.wifi_off_outlined,
    );
  }
}
