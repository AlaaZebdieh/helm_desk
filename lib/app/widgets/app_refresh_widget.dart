import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AppRefreshWidget extends StatelessWidget {
  final Widget child;
  final RefreshController refreshController;

  final Widget? header;
  final Widget? footer;

  final bool enablePullUp;
  final bool enablePullDown;

  final void Function()? onRefresh;
  final void Function()? onLoading;

  const AppRefreshWidget({
    super.key,
    required this.child,
    required this.refreshController,

    this.header,
    this.footer,

    this.enablePullUp = false,
    this.enablePullDown = true,

    this.onRefresh,
    this.onLoading,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: SmartRefresher(
        controller: refreshController,
        enablePullDown: enablePullDown,
        enablePullUp: enablePullUp,
        header: header ?? const MaterialClassicHeader(),
        footer: footer ?? const ClassicFooter(),
        onRefresh: onRefresh,
        onLoading: onLoading,
        child: child,
      ),
    );
  }
}
