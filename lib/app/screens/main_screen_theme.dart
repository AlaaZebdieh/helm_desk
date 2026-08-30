import 'package:flutter/material.dart';

import '../utils/extensions/context_extensions.dart';

class MainScreenTheme extends StatelessWidget {
  final Widget child;
  final Widget? floatingButton;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;

  const MainScreenTheme({
    super.key,
    required this.child,
    this.floatingButton,
    this.appBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: backgroundColor,
        appBar: appBar,
        floatingActionButton: floatingButton,
        body: Container(
          height: context.height,
          width: context.width,
          padding: EdgeInsets.only(
            top: context.topPadding,
            bottom: context.bottomPadding,
          ),
          child: child,
        ),
      ),
    );
  }
}
