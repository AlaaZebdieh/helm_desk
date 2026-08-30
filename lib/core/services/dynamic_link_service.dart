import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../../app/navigation/navigation_service.dart';

class DynamicLinkService {
  final NavigationService navigationService;
  final AppLinks appLink = AppLinks();

  bool hasHandledInitialLink = false;
  StreamSubscription<Uri?>? _linkSubscription;

  DynamicLinkService({required this.navigationService});

  /// استدعاء عند تشغيل التطبيق مرة واحدة
  Future<void> handleDynamicLinks() async {
    try {
      // جلب الرابط العميق عند بدء التطبيق
      final initialLink = await appLink.getInitialLink();
      if (initialLink != null) {
        debugPrint("DeepLink Initial Path: ${initialLink.path}");
        debugPrint("DeepLink Initial Host: ${initialLink.host}");
        hasHandledInitialLink = true;
        await _handleDeepLink(initialLink);
      }
    } catch (e) {
      debugPrint("Error fetching initial link: $e");
    }

    // الاستماع للروابط أثناء تشغيل التطبيق
    _listenForLinks();
  }

  void _listenForLinks() {
    _linkSubscription = appLink.uriLinkStream.listen(
      (Uri? uri) async {
        if (uri != null) {
          debugPrint("DeepLink Stream Path: ${uri.path}");
          if (hasHandledInitialLink) {
            hasHandledInitialLink = false;
            return;
          }
          await _handleDeepLink(uri);
        }
      },
      onError: (error) {
        debugPrint("Dynamic link stream error: $error");
      },
    );
  }

  /// معالجة الرابط العميق
  Future<void> _handleDeepLink(Uri deepLink) async {
    // مثال توجيه حسب path
    // switch (deepLink.path) {
    //   case '/profile':
    //     navigationService.pushNamed(
    //       '/profile',
    //       arguments: deepLink.queryParameters,
    //     );
    //     break;
    //   case '/product':
    //     navigationService.pushNamed(
    //       '/product',
    //       arguments: deepLink.queryParameters,
    //     );
    //     break;
    //   default:
    //     debugPrint("Unhandled deep link path: ${deepLink.path}");
    // }
  }

  /// الغاء الاستماع عند عدم الحاجة (مثلاً عند dispose)
  void dispose() {
    _linkSubscription?.cancel();
  }
}
