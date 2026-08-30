import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

import 'app_root.dart';

Future<void> main() async {
  await di.init();
  runApp(const AppRoot());
}
